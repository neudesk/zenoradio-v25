class window.CampaignResults
  constructor: (options)->
    @setup(options)
 
  setup: (options)-> 
   $(document).on('click', '.campaign_list', ( (e) -> 
       gateway_id = $(this).data('id')
       if $('.campaigns_box_'+gateway_id).is(':visible')
          $(this).children('i').removeClass('fa-angle-down')
          $(this).children('i').addClass('fa-angle-up')
          $('.campaigns_box_'+gateway_id).hide()
       else
          $('.cmp_table').hide()
          $('.campaigns_box_'+gateway_id).show()
          $('.campaigns_box_'+gateway_id).html('<div style="width:100px;height:200px;margin: 0 auto;"><img style="margin-top:30px;width:32px;height:32px;" alt="Loader" src="/assets/ajax/loader.gif"></div>')
          $('.fa').removeClass('fa-angle-down').addClass('fa-angle-up')
          $(this).children('i').removeClass('fa-angle-up').addClass('fa-angle-down')
          url = "/campaign_results/get_campaigns_by_gateway_id?gateway_id="+ gateway_id
          $.ajax({
          url: url
          type: 'GET'
          success: (res) ->
           $('.campaigns_box_'+gateway_id).html(res)
          error: (res) ->
            return
          complete: (res) ->
          })
    ))
  $(document).on('click','.show_campaign_status',( (e) ->
       $("#showContentModal").modal("show");
       $("#showContentModal").html('<div style="width:100%;height:240px;"><img style="margin:102px 0 0 262px;width:32px;height:32px;" alt="Loader" src="/assets/ajax/loader.gif"></div>')
       campaign_id = $(this).data('id')
       url = "/campaign_results/get_campaign_status?campaign_id="+ campaign_id
       $.ajax({
          url: url
          type: 'GET'
          success: (res) ->
           $("#showContentModal").html(res)
          error: (res) ->
            return
          complete: (res) ->
          })))
  $(document).on('click','.custom_pagination',( (e) ->
          gateway_id = $(this).data('value')
          page = $(this).data('id')
          url = "/campaign_results/get_campaigns_by_gateway_id?gateway_id="+ gateway_id+"&page="+page
          $.ajax({
          url: url
          type: 'GET'
          success: (res) ->
           $('.campaigns_box_'+gateway_id).html(res)
          error: (res) ->
            return
          complete: (res) ->
          }) 
      ))
      
      