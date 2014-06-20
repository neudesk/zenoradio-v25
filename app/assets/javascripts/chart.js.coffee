$ ->
  $(document).ready customHooks
  $(document).on "page:load", customHooks

customHooks = ->
  if $("#user_graph").length > 0
    labels = $("#user_graph").data("labels")
    values = $("#user_graph").data("values")
    obj = []
    $.each labels, (index, label) ->
      obj.push([label, values[index]])

    $.plot "#user_graph", [obj],
      series:
        # points:
        #   show: true
        #   fillColor: "red"
        lines:
          show: true
          lineWidth: 3
        color: "blue"
      xaxis:
        mode: "categories"
        tickLength: 0
        font:
          size: 14
          color: "#000000"
      grid:
        backgroundColor: "#FFFFFF"
        hoverable: true

  previousPoint = null
  $("#user_graph").bind "plothover", (event, pos, item) ->
    $("#x").text pos.x.toFixed(2)
    $("#y").text pos.y.toFixed(2)
    if item
      unless previousPoint is item.dataIndex
        previousPoint = item.dataIndex
        $("#tooltip").remove()
        x = item.datapoint[0]
        y = item.datapoint[1]
        $.showTooltip item.pageX, item.pageY, "#{y} minutes"
    else
      $("#tooltip").remove()
      previousPoint = null
    return
