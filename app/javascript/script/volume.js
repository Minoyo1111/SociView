document.addEventListener("turbolinks:load", () => {
    start = gon.start;
    end = gon.end;
    theme1 = gon.theme1;
    theme2 = gon.theme2;
    theme3 = gon.theme3;
    count1 = gon.count1;
    count2 = gon.count2;
    count3 = gon.count3;
    let all_date = [];
    let count_line1 = {};
    let count_line2 = {};
    let count_line3 = {};

    for (
        let d = new Date(start); d <= new Date(end); d.setDate(d.getDate() + 1)
    ) {
        formatDt = `${new Date(d).getFullYear()}-${new Date(d).getMonth() + 1
      }-${new Date(d).getDate()}`;
        all_date.push(formatDt);
    }
    all_date.forEach((d) => {
        count_line1[d] = 0;
        count_line2[d] = 0;
        count_line3[d] = 0;
    });

    //待改進
    if (gon.result1 !== undefined) {
        gon.result1.forEach((e) => {
            d_result1 = `${new Date(e.created_at).getFullYear()}-${new Date(e.created_at).getMonth() + 1
        }-${new Date(e.created_at).getDate()}`;
            count_line1[d_result1] += 1;
        });
    }

    if (gon.result2 !== undefined) {
        //待改進
        gon.result2.forEach((e) => {
            d_result2 = `${new Date(e.created_at).getFullYear()}-${new Date(e.created_at).getMonth() + 1
        }-${new Date(e.created_at).getDate()}`;
            count_line2[d_result2] += 1;
        });
    }
    if (gon.result3 !== undefined) {
        //待改進
        gon.result3.forEach((e) => {
            d_result3 = `${new Date(e.created_at).getFullYear()}-${new Date(e.created_at).getMonth() + 1
        }-${new Date(e.created_at).getDate()}`;
            count_line3[d_result3] += 1;
        });
    }

    if (document.getElementById("volumePieChart")) {
        // pie chart
        const ctx_pie = document.getElementById("volumePieChart").getContext("2d");
        const pieChart = new Chart(ctx_pie, {
            type: "pie",
            data: {
                labels: [theme1, theme2],
                datasets: [{
                    data: [count1, count2],
                    backgroundColor: ["rgba(75,192,192,1)", "rgba(255,99,132,1)"],
                }, ],
            },
            options: {
                title: {
                    display: true,
                    text: "聲量圓餅圖",
                },
            },
        });
        (theme3 == null) ? "" : addData(pieChart, theme3, count3, "rgba(58,164,235,1)")

        // bar chart
        const ctx_bar = document.getElementById("volumeBarChart").getContext("2d");
        const barChart = new Chart(ctx_bar, {
            type: "bar",
            data: {
                labels: [theme1, theme2],
                datasets: [{
                    data: [count1, count2],
                    backgroundColor: ["rgba(75,192,192,0.5)", "rgba(255,99,132,0.5)"],
                }, ],
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            callback: function(value, index, values) {
                                return value + " 則";
                            },
                            beginAtZero: true,
                        },
                    }, ],
                },
                title: {
                    display: true,
                    text: "聲量長條圖",
                },
                legend: {
                    display: false,
                },
            },
        });
        (theme3 == null) ? "" : addData(barChart, theme3, count3, "rgba(58,164,235,0.5)")

        // line chart
        const ctx_line = document
            .getElementById("volumeLineChart")
            .getContext("2d");
        const lineChart = new Chart(ctx_line, {
            type: "line",
            data: {
                labels: all_date,
                datasets: [{
                        label: theme1,
                        data: Object.values(count_line1),
                        borderWidth: 1,
                        pointRadius: 5,
                        borderColor: "rgba(75,192,192,1)",
                        backgroundColor: "rgba(75,192,192,0.2)",
                    },
                    {
                        label: theme2,
                        data: Object.values(count_line2),
                        borderWidth: 1,
                        pointRadius: 5,
                        borderColor: "rgba(255,99,132,1)",
                        backgroundColor: "rgba(255,99,132,0.2)",
                    },
                ],
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            callback: function(value, index, values) {
                                return value + " 則";
                            },
                            beginAtZero: true,
                            stepSize: 1,
                        },
                    }, ],
                },
                title: {
                    display: true,
                    text: "聲量折線圖",
                },
            },
        });
        (theme3 == null) ? "" : addDataline(lineChart, theme3, Object.values(count_line3))
    }

    function addData(chart, label, data, bgc) {
        chart.data.labels.push(label);
        chart.data.datasets.forEach((dataset) => {
            dataset.data.push(data);
            dataset.backgroundColor.push(bgc);
        });
        chart.update();
    }

    function addDataline(chart, label, data) {
        const line3 = {
            'label': label,
            'data': data,
            'borderWidth': 1,
            'pointRadius': 5,
            'borderColor': "rgba(58,164,235,1)",
            'backgroundColor': "rgba(58,164,235,0.2)"
        }
        chart.data.datasets.push(line3);
        chart.update();
    }
});