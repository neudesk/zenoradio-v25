$("#edit_extension_modal").html "<%= escape_javascript(render 'data_gateway_conferences/form_modal', conference: @conference) %>"
$("#edit_extension_modal").modal "show"


$("select.select").each ->
  if $(this).hasClass("without_search")
    $(this).select2
      allowClear: true
      minimumResultsForSearch: -1
  else if $(this).hasClass("without_css")
  else
    $(this).select2
      allowClear: true

$("#submit_edit_extension_form").on "click", (e) ->
  e.preventDefault()
  has_error = false
  $("#edit_extension_form").find("input.required").each ->
    if $(this).val() == ""
      has_error = true
  if has_error
    $.alert("Please fill-up all the required fields")
  else
    $("#edit_extension_form").submit()

$("#data_gateway_conference_content_media_type").select2("val", "<%= @conference.content.media_type %>")


$.alert = (message, callback) ->
  return false unless message
  modal_html = "<div id='custom_alert' class='modal'><div class='modal-dialog'><div class='modal-content' id='modal_alert'><div class='modal-body'><p>#{message}</p></div><div class='modal-footer'><a data-dismiss='modal' class='button color'>OK</a></div></div></div></div>"
  $modal_html = $(modal_html)
  $modal_html.modal
    backdrop: 'static'