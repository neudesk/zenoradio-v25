class window.ReachoutTab
  constructor: (options)->
    @setup(options)
 
  setup: (options)->
    d = new Date()
    month = d.getMonth() + 1
    day = d.getDate() + 1
    year = d.getFullYear()

    $("#hourpicker").datetimepicker
      format:'H:i',
      datepicker:false,
      value: d.getHours() + ":" +  (parseInt(d.getMinutes()) + 5)
      step: 10
      minTime:d.getHours() + ":" +  d.getMinutes(),
      maxTime:'17:00'

    $("#datepicker").datetimepicker
      format:'Y-m-d H:i',
      minDate: year + "/" + month + "/" + day 
      value: year + "-" + month + "-" + day + " " + "09:00"
      step: 10
      minTime:'9:00',
      maxTime:'17:00'

    $('#campaigns').click ->
      $('.campaign_box').toggle()
    true
    $('input[name="schedule"]').click ->
      if $('input[name="schedule"]:checked').val() == "send_later"
        $("#datepicker").show()
        $("#hourpicker").hide()
      else
        $("#datepicker").hide()
        $("#hourpicker").show()

    $('.send').click (e) ->
      $('.error').text("")
      if $('#prompt').val() == ""
        $('.error').text('Please select a wav file.')
        return false
      if $('#date').val() == "" && $(".schedule").val() == "send_later"
        $('.error').text('Please select a schedule date.')
        return false
      $('#schedule_type').val($('input[name="schedule"]:checked').val())

    
