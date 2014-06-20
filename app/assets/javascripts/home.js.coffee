$ ->
  class window.Home
    constructor: ->
      @setup()
      show_map()
    setup: ->
      $('.home').delegate "#select_type", "change", (e) ->
        e.preventDefault()
        $('#type').val($(e.target).val())
        get_summary_list()
      setInterval( ->
        get_summary_list()
        get_summary_head_list()
        show_map()
        true
      , 60000);
      
    
    
    get_summary_list = () ->
      $(".summary_list .icon-refresh").addClass("icon-refresh-animate");
      data = {'type':$('#type').val(),'page':GetURLParameter('page') }
      $.ajax 
          url: '/home/get_stations'
          type: 'GET'
          data: data
          success: (data) ->      
            $('.summary_list_body').html(data)
            $('.btn').val($('#type').val())
            $(".summary_list .icon-refresh").addClass("icon-refresh-animate");
           
          true
      true
    get_summary_head_list = () ->
      $(".summary_head_list .icon-refresh").addClass("icon-refresh-animate");
      $.ajax 
          url: '/home/get_status'
          type: 'GET'
          success: (data) ->      
            $('.summary_head_list').html(data)
            $(".summary_head_list .icon-refresh").removeClass("icon-refresh-animate");
          true
      true  
    show_map = () ->
      $.ajax({
       url: '/home/get_map_of_listeners'
       type: 'GET'
       dataType: 'json'
       success: (res) ->
         if res != null
            $('.total_listeners').text(res['all_listeners'])
            $('.uniq_listeners').text(res['uniq_listeners'])
            $('.us_listeners').text(res['us_listeners'])
            if res["results"].length > 0
             markers = []
             for r in res["results"]
                markers.push({lat:r["lat"], lng:r["long"]})
             handler = Gmaps.build("Google")
             handler.buildMap
               internal:
                 id: "map"
             , ->
               markers = handler.addMarkers(markers)
               handler.bounds.extendWith markers
               handler.fitMapToBounds()
               return
          
       error: (res) ->
         return
       complete: (res) ->
       })
     GetURLParameter = (sParam) ->
      sPageURL = window.location.search.substring(1)
      sURLVariables = sPageURL.split("&")
      i = 0

      while i < sURLVariables.length
        sParameterName = sURLVariables[i].split("=")
        return sParameterName[1]  if sParameterName[0] is sParam
        i++
      return

        
        
