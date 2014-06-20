$ ->
  $(document).ready customHooks
  $(document).on "page:load", customHooks

customHooks = ->
  if $("#user_permission_id").length > 0
    reload(false)

  $("#user_permission_id").on "change", (e) ->
    reload(true)

  $("#user_filter").on "change", (e) ->
    $(this).parents("form").submit()

  $("#user_country_holder").each ->
    records = $(this).data("data")
    if records == null
      $(this).select2()
    else if records != undefined
      obj = []
      $.each records, (index, value) ->
        if value != ""
          obj.push({"id":value, "text": value})
      $("#user_country_holder").select2(
      ).select2 "data", obj

  $("#add_new_group").on "click", (e) ->
    e.preventDefault()
    showNewGroup("click")

  $(".sort_role").on "click", (e) ->
    permission = $(this).data("permission")
    $("#user_filter").val(permission)
    $("#new_user").submit()


reload = (exist) ->
  if $("#user_permission_id").val() == "1" or $("#user_permission_id").val() == undefined or $("#user_permission_id").val() == ""
    $("#group_tr").hide()
    $("#new_group_tr").hide()
  else
    if $("#user_new_group").val() != "" && !exist
      showNewGroup("not_click")
    else
      $("#group_tr").show()
      $("#new_group_tr").hide()
      $.ajax(
        url: "/admin/users/groups_options"
        data: {
          role: $("#user_permission_id").val()
          user_id: $("#permission_id_for_js").data("user")
        }
      ).done (option_list) ->
        $("#user_group").find("option").remove()
        $('#user_group').append "<option></option>"
        $('#user_group').append option_list.list
        if option_list.name != undefined
          $(".user_group").find(".select2-chosen").html("<div>#{option_list.name}</div>")
        else
          $(".user_group").find(".select2-chosen").html("")

showNewGroup = (event) ->
  if event == "click"
    $("#user_new_group").val("")
  $("#group_tr").hide()
  $("#new_group_tr").show()





