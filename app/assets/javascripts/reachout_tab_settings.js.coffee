class window.ReachoutTabSettings
    $(".num_value").blur (e)=>
      if $(e.target).parent().attr('class') == "call_time_setting"
         data = {'val1':$('#val1').val(), 'val2': $('#val2').val()}
      else
        data = {'value':$(e.target).val() }
      url = "/reachout_tab_settings/update_setting/" + $(e.target).data('val') 
      $.ajax({
       url: url
       data: data
       type: 'PUT'
       success: (res) ->
       error: (res) ->
         return
       complete: (res) ->
       })

    $(".text_value").blur (e)=>
      data = $(e.target).val()
      url = "/reachout_tab_settings/update_setting/" + $(e.target).data('val') 
      $.ajax({
       url: url
       data: {'value':data}
       type: 'PUT'
       success: (res) ->
       error: (res) ->
         return
       complete: (res) ->
       })

     $("#btn_search").click =>
        data = $('#txt_search').val()
        url = "/reachout_tab_settings/search_phone" 
        $.ajax({
         url: url
         data: {'phone_number':data}
         type: 'GET'
         success: (res) ->
          html = ''
          for result in res.dnc_list
           html +='<li id="'+result.id+'"><p class="phone_number">'+result.phone_number+'</p><button class="phone_delete" data-val="'+result.id+'">x</button></li>'
          $('.dnc_list').html(html)
         error: (res) ->
           return
         complete: (res) ->
         })
      $("#save_call_time").click =>
        if $('#id').val() == ''
          $('.error').text('ID field is empty.')
          return 
        if $('#call_time_name').val() == ''
          $('.error').text('Name field is empty.')
          return 
        if $('#ct_default_stop').val() == ''
          $('.error').text('Start Time field is empty.')
          return 
        if $('#ct_default_start').val() == ''
          $('.error').text('End Time field is empty.')
          return 
        url = "/reachout_tab_settings/add_call_time"
        $.ajax({
         url: url,
         data: $('#call_time_form').serialize(),
         type: 'POST'
         success: (res) ->
          if res == "1"
            $('.error').text('Call time has no saved.')
          else
            window.location.href = '/reachout_tab_settings/index'
         error: (res) ->
           return
         complete: (res) ->
         })
     $("#settings_new").click =>
      $('.settings_form').toggle()
     
     $(".add_call").click =>
      $('.call_time_form').toggle()

     $("#add_phone").click =>
      data = $('#txt_phone').val()
      url = "/reachout_tab_settings/add_phone_dnc" 
      $.ajax({
       url: url
       data: {'phone_number':data}
       type: 'POST'
       success: (res) ->
        if res.message =="Succes"
          $('.dnc_list').append('<li id="'+res.id+'"><p class="phone_number">'+data+'</p><button class="phone_delete" data-val="'+res.id+'">x</button></li>')
          $('#txt_phone').val('')
          $('.info').append('<div class="alert fade in alert-succes"><button class="close" data-dismiss="alert">×</button>Phone number saved successfully.</div>')
        else
          $('.info').append('<div class="alert fade in alert-error"><button class="close" data-dismiss="alert">×</button>' + res.message + '</div>')
        setTimeout(show_alert,5000)
       error: (res) ->
         return
       complete: (res) ->
       })

     $("#save_settings").click =>
        url = "/reachout_tab_settings/add_setting" 
        if $('#name').val() == ""
          $('.info').append('<div class="alert fade in alert-error"><button class="close" data-dismiss="alert">×</button>Please add Setting name.</div>')
        else
          $.ajax({
           url: url
           data: $('#settings_form').serialize()
           type: 'POST'
           success: (res) ->
              window.location.href = "/reachout_tab_settings/index"
           error: (res) ->
             return
           complete: (res) ->
           })
        

     $(document).on('click', '.change_status_broadcaster', ( (e) -> 
        data = $(e.target).data('id')
        status = $(e.target).data('status')
        index = $(e.target).data('index')
        url = "/reachout_tab_settings/activate_broadcaster" 
        $.ajax({
         url: url
         data: {'id' : data, 'status': status}
         type: 'PUT'
         success: (res) ->
          if res.brd.reachout_tab_is_active == true
            status = "Active"
            action = "Disable"
            next_status = false
          else
            status = "Inactive"
            action = "Enable"
            next_status = true
          html = '<td>'+index+'</td><td>'+res.brd.title+'</td><td>'+status+'</td><td><a class="change_status_broadcaster"'
          html += 'data-index="'+index+'" data-name="'+res.brd.title+'" data-id="'+data+'" data-status="'+next_status+'">'+action+'</a></td>'
          $(e.target).parent().parent().html(html)
         error: (res) ->
           return
         complete: (res) ->
         })
      ))

      $(document).on('click', '.change_status_rca', ( (e) -> 
        data = $(e.target).data('id')
        status = $(e.target).data('status')
        index = $(e.target).data('index')
        url = "/reachout_tab_settings/activate_rca" 
        $.ajax({
         url: url
         data: {'id' : data, 'status': status}
         type: 'PUT'
         success: (res) ->
          if res.rca.reachout_tab_is_active == true
            status = "Active"
            action = "Disable"
            next_status = false
          else
            status = "Inactive"
            action = "Enable"
            next_status = true
          html = '<td>'+index+'</td><td>'+res.rca.title+'</td><td>'+status+'</td><td><a class="change_status_rca"'
          html += 'data-index="'+index+'" data-name="'+res.rca.title+'" data-id="'+data+'" data-status="'+next_status+'">'+action+'</a></td>'
          $(e.target).parent().parent().html(html)
         error: (res) ->
           return
         complete: (res) ->
         })
      ))

    
    $('#search_rca').click ->
       $('#txt_rca_search').val
       window.location.href = "/reachout_tab_settings/index?type=rca&search=" + $('#txt_rca_search').val()
    $('#txt_rca_search').bind('keypress', (e) ->
       if(e.keyCode==13)
         $('#txt_rca_search').val
         window.location.href = "/reachout_tab_settings/index?type=rca&search=" + $(e.target).val()
     )

    $('#search_broadcast').click ->
       $('#txt_broadcast_search').val
       window.location.href = "/reachout_tab_settings/index?type=brd&search=" + $('#txt_broadcast_search').val()
    $('#txt_broadcast_search').bind('keypress', (e) ->
       if(e.keyCode==13)
         $('#txt_broadcast_search').val
         window.location.href = "/reachout_tab_settings/index?type=brd&search=" + $(e.target).val()
     )

    $(document).on('click', '.phone_delete', ( (e) ->
       if confirm "Do you want to delete selected phone number from DNC list?"
         id = $(e.target).data('val')
         url = "/reachout_tab_settings/delete_phone_dnc/" + $(e.target).data('val') 
         $.ajax({
          url: url
          data: {'id':id}
          type: 'DELETE'
          success: (res) ->
           $('#'+id).remove();
          error: (res) ->
            return
          complete: (res) ->
          })
     )  )
    show_alert = () ->
      $('.info').html('')

    true

