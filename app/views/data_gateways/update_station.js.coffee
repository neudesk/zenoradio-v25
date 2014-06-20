if <%= @next.present? %>
  $(location).attr('href',"<%= @next %>")
else
  $("#information").html "<%= escape_javascript(render 'new_settings/information') %>"

  $(".loaded").show()
  $(".loading").hide()

  $("select.select").each ->
    if $(this).hasClass("without_search")
      $(this).select2
        allowClear: true
        minimumResultsForSearch: -1
    else if $(this).hasClass("without_css")
    else
      $(this).select2
        allowClear: true

  $(".ajax-submit").on "click", (e) ->
    e.preventDefault()
    $(this).parents("form").submit()
    $(".loaded").hide()
    $(".loading").show()
