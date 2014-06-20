class window.Graphs
  constructor: ->
    @setup()

  setup: ->
    @chart_a = $("#chart_a")
    @changeDayChartA()
    @changeDayChartC()
    @changeContentChartC()
    @changeDayChartD()
    @changeContentChartD()
    @changeDayChartE()
    @changeContentChartE()
    @setTitleSelectTag()

  changeDayChartA: ->
    $("#pie_chart").change((e) =>
      url = "/graphs/chart_a?day=" + $("#pie_chart").val()
      param = window.location.search.substring(1)
      if param != ""
        url = url + "&gateway_id=" +param.split("=")[1]
      $("#loading").removeClass("hide")
      $("#chart_a").addClass("hide")
      $.ajax({
      url: url
      type: 'GET'
      success: (res) ->
        $("#chart_a").html(res)
      error: (res) ->
        return
      complete: (res) ->
        $("#loading").addClass("hide")
        $("#chart_a").removeClass("hide")
      })
    )

  changeDayChartC: ->
    $("#line_chart").change((e) =>
      @processChangeChartC()
    )

  changeContentChartC: ->
    $("#line_chart_ext").change((e) =>
      @processChangeChartC()
    )

  processChangeChartC: ->
    url = "/graphs/change_chart_c?day=" + $("#line_chart").val()
    url += "&object_id=" + $("#line_chart_ext").val()
    $("#chart_content_c #lloading").removeClass("hide")
    $("#chart_c").addClass("hide")
    $.ajax({
    url: url
    type: 'GET'
    success: (res) ->
      $("#chart_c").html(res)
    error: (res) ->
      return
    complete: (res) ->
      $("#chart_content_c #lloading").addClass("hide")
      $("#chart_c").removeClass("hide")
    })

  changeDayChartD: ->
    $("#column_chart").change((e) =>
      @processChangeChartD()
    )

  changeContentChartD: ->
    $("#column_chart_ext").change((e) =>
      @processChangeChartD()
    )

  processChangeChartD: ->
    url = "/graphs/change_chart_d?day=" + $("#column_chart").val()
    url += "&object_id=" + $("#column_chart_ext").val()
    $("#chart_content_d #lloading").removeClass("hide")
    $("#chart_d").addClass("hide")
    $.ajax({
    url: url
    type: 'GET'
    success: (res) ->
      $("#chart_d").html(res)
    error: (res) ->
      return
    complete: (res) ->
      $("#chart_content_d #lloading").addClass("hide")
      $("#chart_d").removeClass("hide")
    })

  changeDayChartE: ->
    $("#total_chart_day").change((e) =>
      @processChangeChartE()
    )

  changeContentChartE: ->
    $("#total_chart_ext").change((e) =>
      @processChangeChartE()
    )

  processChangeChartE: ->
    gateway_id = window.location.search.substring(1).split("=")[1]
    url = "/graphs/change_total_chart?gateway_id="+gateway_id+"&day=" + $("#total_chart_day").val()
    url += "&channel_id=" + $("#total_chart_ext").val()
    $("#total_chart_content #lloading").removeClass("hide")
    $("#total_chart").addClass("hide")
    $.ajax({
            url: url
            type: 'GET'
            success: (res) ->
              $("#total_chart").html(res)
            error: (res) ->
              return
            complete: (res) ->
              $("#total_chart_content #lloading").addClass("hide")
              $("#total_chart").removeClass("hide")
    })

  setTitleSelectTag: ->
    $("#column_chart_ext").hover ->
      $(this).attr("title", $(this).children(":selected").text())
    $("#line_chart_ext").hover ->
      $(this).attr("title", $(this).children(":selected").text())
    $("#total_chart_ext").hover ->
      $(this).attr("title", $(this).children(":selected").text())
