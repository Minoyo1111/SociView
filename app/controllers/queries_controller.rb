class QueriesController < ApplicationController
  before_action :authenticate_user!
  layout "homepage"

  def index
    @wordcloud = wordcloud_queries_path
    @sentiment = sentiment_queries_path
    @volume = volume_queries_path
    @list = list_queries_path
    @topic = topic_queries_path
  end

  def list
  end

  def sentiment; end

  def sentpost
    @theme = params[:theme]
    @source = [params[:dcard], params[:ptt]]
    @start = params[:user][:start].to_date
    @end = params[:user][:end].to_date
    @type = [params[:post], params[:comment]]

    # 主題查詢條件（現在是隨便寫）
    @query = ""
    if @theme == "1"
      @query = "%期末%"
    elsif @theme == "2"
      @query = "%筆電%"
    else
      @query = "%貓%"
    end

    @post_result = Post.where("created_at >= ? and created_at <=?", @start.midnight, @end.end_of_day).where("content like ?", @query).or(Post.where("title like ?", @query))

    @comment_result = Comment.where("created_at >= ? and created_at <=?", @start.midnight, @end.end_of_day).where(:pid => Post.where("content like ?", @query).or(Post.where("title like ?", @query)).pluck(:pid)).or(Comment.where("content like ?", @query))

<<<<<<< HEAD
    @comment_result = Comment.where('created_at >= ? and created_at <=?', @start.midnight, @end.end_of_day).where(:pid => Post.where("content like ?",@query).or(Post.where("title like ?", @query)).pluck(:pid)).or(Comment.where("content like ?", @query))
    
=======
    # 計算符合搜尋條件的資料筆數
>>>>>>> add volume chart
    post_count = @post_result.count
    comment_count = @comment_result.count

    gon.start = @start
    gon.end = @end

    if params[:post] && params[:comment]
      @count = post_count + comment_count
      gon.result = @post_result + @comment_result
    elsif params[:post] && !params[:comment]
      @count = post_count
      gon.result = @post_result
    else
      @count = comment_count
      gon.result = @comment_result
    end
  end

  def volume
    # pass value down to api action
    @theme = params[:theme]
    @source = params[:dcard]
    @start = params[:user][:start].to_date
    @end = params[:user][:end].to_date
    @type = [params[:post], params[:comment]]

    @post_result = Post.where("created_at >= ? and created_at <=?", @start.midnight, @end.end_of_day).where("content like ?", "%#{@theme}%").or(Post.where("title like ?", "%#{@theme}%"))

    @comment_result = Comment.where("created_at >= ? and created_at <=?", @start.midnight, @end.end_of_day).where(:pid => Post.where("content like ?", "%#{@theme}%").or(Post.where("title like ?", "%#{@theme}%")).pluck(:pid)).or(Comment.where("content like ?", "%#{@theme}%"))

    # 計算符合搜尋條件的資料筆數
    post_count = @post_result.count
    comment_count = @comment_result.count

    gon.start = @start
    gon.end = @end

    if params[:post] && params[:comment]
      @count = post_count + comment_count
      gon.result = @post_result + @comment_result
    elsif params[:post] && !params[:comment]
      @count = post_count
      gon.result = @post_result
    else
      @count = comment_count
      gon.result = @comment_result
    end
  end

  def topic ; end

  def topicpost 
    @theme = params[:theme]
    @source = [params[:dcard],params[:ptt]]
    @start = params[:user][:start].to_date 
    @end = params[:user][:end].to_date
    @type = [params[:post],params[:comment]]

    @query = ""
    if @theme == "1"
      @query = "%期末%"
    elsif @theme == "2"
      @query = "%筆電%"
    else 
      @query = "%貓%"
    end 
    
    post_result = Post.where('created_at >= ? and created_at <=?', @start.midnight, @end.end_of_day).where("content like ?",@query).or(Post.where("title like ?",@query))

    comment_result = Comment.where('created_at >= ? and created_at <=?', @start.midnight, @end.end_of_day).where(:pid => Post.where("content like ?",@query).or(Post.where("title like ?", @query)).pluck(:pid)).or(Comment.where("content like ?", @query))
    
    post_count = post_result.count
    comment_count = comment_result.count

    if params[:post] && params[:comment] 
      @count = post_count + comment_count
      result = post_result.select(:token, :id)|comment_result.select(:token, :id)
    elsif params[:post] && !params[:comment] 
      @count = post_count
      result = post_result.select(:token, :id)
    else
      @count = comment_count
      result = comment_result.select(:token, :id)
    end 

    CSV.open("data/topic_text.csv", "wb") do |csv|
      result.find_all do |res|
        csv << res.attributes.values
      end
    end
    `python3 lib/tasks/Topic/main.py`
  end 

  def wordcloud ; end

  def cloudpost
    @theme = params[:theme]
    @source = [params[:dcard],params[:ptt]]
    @start = params[:user][:start].to_date 
    @end = params[:user][:end].to_date
    @type = [params[:post],params[:comment]]

    @query = ""
    if @theme == "1"
      @query = "%期末%"
    elsif @theme == "2"
      @query = "%筆電%"
    else 
      @query = "%貓%"
    end 
    
    post_result = Post.where('created_at >= ? and created_at <=?', @start.midnight, @end.end_of_day).where("content like ?",@query).or(Post.where("title like ?",@query))

    comment_result = Comment.where('created_at >= ? and created_at <=?', @start.midnight, @end.end_of_day).where(:pid => Post.where("content like ?",@query).or(Post.where("title like ?", @query)).pluck(:pid)).or(Comment.where("content like ?", @query))
    
    post_count = post_result.count
    comment_count = comment_result.count

    if params[:post] && params[:comment] 
      @count = post_count + comment_count
      result = post_result.select(:token, :id)|comment_result.select(:token, :id)
    elsif params[:post] && !params[:comment] 
      @count = post_count
      result = post_result.select(:token, :id)
    else
      @count = comment_count
      result = comment_result.select(:token, :id)
    end 

    CSV.open("data/cloud_text.csv", "wb") do |csv|
      result.find_all do |res|
        csv << res.attributes.values
      end
    end
    `python3 lib/tasks/Wordcloud/main.py`
  end

  def diffusion
  end
end