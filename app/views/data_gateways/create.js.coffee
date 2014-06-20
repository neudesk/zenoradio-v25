if <%= @next.present? %>
  $(location).attr('href',"<%= @next %>")
else
  $("#new_station_fields").html "<%= escape_javascript(render 'data_gateways/form', station: @new_station) %>"
  $("select.select").each ->
    if $(this).hasClass("without_search")
      $(this).select2
        allowClear: true
        minimumResultsForSearch: -1
    else if $(this).hasClass("without_css")
    else
      $(this).select2
        allowClear: true

  $(".icheck-me").each ->
    skin =  "_" + $(this).attr('data-skin')
    color = "-" + $(this).attr('data-color')
    $(this).iCheck(checkboxClass: 'icheckbox' + skin + color, radioClass: 'iradio' + skin + color)

