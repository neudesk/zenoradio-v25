class window.Reports
  constructor: ->
    @setup()

  setup: ->

    get_graphs_data()
    graphs()

  graphs = () ->
    $("#month").change((e) =>
      get_graphs_data()
      true
    )
    $("#entryway_id").change((e) =>
      get_graphs_data()
      true
    )
    true
  get_graphs_data = () ->
    url = "/reports/get_graphs?month=" + $("#month").val()+"&entryway_id=" + $('#entryway_id').val()
    param = window.location.search.substring(1)
    if param != ""
      url = url + "&gateway_id=" +param.split("=")[1]
    $(".loading").show()
    $.ajax({
       url: url
       type: 'GET'
       success: (res) ->
         $(".minutes_graph").html(res)
       error: (res) ->
         return
       complete: (res) ->
         $(".loading").hide()
       })
    true

  