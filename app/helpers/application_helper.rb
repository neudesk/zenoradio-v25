module ApplicationHelper
  def get_list_weeks_of_current_year
    start = DateTime.now.beginning_of_year
    ende = DateTime.now.end_of_year

    weeks = []
    while start < ende
      weeks << ["#{start.strftime("%b")} #{start.beginning_of_week.strftime("%d")}-#{start.end_of_week.strftime("%d")}", start.cweek]  # <-- enhanced
      start += 1.week
    end
    weeks
  end

  def get_hours_list
    hours = []
    (1..24).each do |t|
      hours << t
    end

    hours
  end


  def get_4_weeks_name
    start = DateTime.current.beginning_of_week
    ende = DateTime.current.end_of_week

    @result = []

    (0..7).each do |i|
      @result << "#{start.strftime("%b %d")}-#{ende.strftime("%d")}"
      start -= 1.week
      ende -= 1.week
    end

    @result
    # start = DateTime.now.beginning_of_year
    # ende = DateTime.now.end_of_year

    # weeks = []
    # _4weeks= []
    # while start < ende
    #   weeks << ["#{start.strftime("%b")} #{start.beginning_of_week.strftime("%d")}-#{start.end_of_week.strftime("%d")}", start.cweek]  # <-- enhanced
    #   prev_month = DateTime.now - 1.month
    #   if start.strftime("%b") == Date.today.strftime("%b") || start.strftime("%b") == prev_month.strftime("%b")
    #     # puts "#{start.strftime("%b")} #{start.beginning_of_week.strftime("%d")}-#{start.end_of_week.strftime("%d")} => #{start.cweek}"
    #     # _4weeks << ["#{start.strftime("%b")} #{start.beginning_of_week.strftime("%d")}-#{start.end_of_week.strftime("%d")}", start.cweek]  # <-- enhanced
    #     _4weeks << "#{start.strftime("%b")} #{start.beginning_of_week.strftime("%d")}-#{start.end_of_week.strftime("%d")}"  # <-- enhanced
    #   end
    #   start += 1.week
    # end

    # _4weeks.reverse
  end

  def current_week 
    [Date.today.beginning_of_month.strftime("%b"), 
     Date.today.beginning_of_week.strftime("%d"), "-",
     Date.today.end_of_week.strftime("%d")].join(" ")
  end 

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}.merge({gateway_id: params[:gateway_id], week: params[:week], page: params[:page]}), {:class => css_class}
  end

  def cal_percent(a,b)
    if (b.blank? || b.nil?) && a.blank?
      return ""
    end

    a = a.to_f
    b = b.to_f
    c = a - b
    
    if a == 0
      return ""
    end

    c = (c / a) * 100
    return "#{print2digits(c)}%"
  end

  def print2digits(a)
    if a.blank?
      return ""
    end

    return sprintf("%02.2f", a)
  end

  #Slider sort order has changed to horizontal order
  #This method helps to change verical order to horizontal order
  #item_size: size of items need to be displayed
  #w: width of a slider page
  #h: height of a slider page
  #Example: 
  #1  4  7  10
  #2  5  8  11
  #3  6  9  12
  #============
  #1  2  3  4
  #5  6  7  8
  #9  10 11 12
  def cal_slider_pos_arr(item_size, w, h)
    r = []
    page_size = (item_size.to_f/(h*w).to_f).ceil
    (1..page_size).each do |page|
      offset = (page-1) * (h*w)
      (1..w).each do |i|
        (1..h).each do |j|
          r<<(offset+i+(j-1)*w-1)
        end
      end
    end
    r
  end

  def sort_slider_stations(stations, w, h)
    size = stations.length
    slider_pos_arr = cal_slider_pos_arr(size, w, h)
    result = []
    slider_pos_arr.each_with_index do |pos, index|
      result[index] = stations[pos]
    end
    
    result
  end

  def cal_slider_height(stations_size)
    height = stations_size <= 16 ? 1 : (stations_size <= 32 ? 2 : 3)
    height
  end

  def html_role(status, permission_id)
    return nil unless status.present?
    if status == "Broadcast user"
      content_tag :div, class: "btn btn-purple btn-squared btn-xs sort_role", data: {permission: permission_id} do
        "Broadcaster"
      end
    elsif status == "Super user"
      content_tag :div, class: "btn btn-orange btn-squared btn-xs sort_role", data: {permission: permission_id} do
        "Administrator"
      end
    elsif status == "3rd party user"
      content_tag :div, class: "btn btn-red btn-squared btn-xs sort_role", data: {permission: permission_id} do
        "Third Party"
      end
    elsif status == "RCA user"
      content_tag :div, class: "btn btn-teal btn-squared btn-xs sort_role", data: {permission: permission_id} do
        "RCA"
      end
    elsif status == "Zenoradio employee"
      content_tag :div, class: "btn btn-beige btn-squared btn-xs", data: {permission: permission_id} do
        "Employee"
      end
    end
  end

  def roles_for_new_select
    options = []
    x = SysUserPermission.find_by_title("Super Admin")
    options << ["Marketer", x.id]
    x = SysUserPermission.find_by_title("RCA User")
    options << ["RCA", x.id]
    x = SysUserPermission.find_by_title("Thirdparty User")
    options << ["Third Party", x.id]
    x = SysUserPermission.find_by_title("Broadcast user")
    options << ["Broadcaster", x.id]
    return options
  end

  def roles_for_new_select_with_all
    options = []
    options << ["All", 0]
    x = SysUserPermission.find_by_title("Super Admin")
    options << ["Marketer", x.id]
    x = SysUserPermission.find_by_title("RCA User")
    options << ["RCA", x.id]
    x = SysUserPermission.find_by_title("Thirdparty User")
    options << ["Third Party", x.id]
    x = SysUserPermission.find_by_title("Broadcast user")
    options << ["Broadcaster", x.id]
    return options
  end

  def displayable_tags(tags, count = 0)
    return nil unless tags.present?
    html = ""
    if count == 0
      tags.each do |tag|
        html << "<span class='label label-inverse inlined-block'>#{tag.title}</span>&nbsp;&nbsp;"
      end
    else
      tags.limit(3).each do |tag|
        html << "<span class='label label-inverse inlined-block'>#{tag.title}</span>&nbsp;&nbsp;"
      end
    end
    html.html_safe
  end

  def displayable_countries(countries, count = 0)
    return nil unless countries.present?
    html = ""
    if count == 0
      countries.each do |tag|
        html << "<span class='label label-inverse inlined-block'>#{tag.title}</span>&nbsp;&nbsp;"
      end
    else
      countries.limit(3).each do |tag|
        html << "<span class='label label-inverse inlined-block'>#{tag.title}</span>&nbsp;&nbsp;"
      end
    end
    html.html_safe
  end

  def display_status(status)
    return nil unless status.present?
    if status == "unprocessed"
      content_tag :span, class: "label label-warning" do
        status.titleize
      end
    elsif status == "ignored"
      content_tag :span, class: "label label-info" do
        status.titleize
      end
    elsif status == "duplicate"
      content_tag :span, class: "label label-danger" do
        status.titleize
      end
    elsif status == "processed"
      content_tag :span, class: "label label-success" do
        status.titleize
      end
    elsif status == "enabled"
      content_tag :span, class: "label label-success" do
        status.titleize
      end
    elsif status == "disabled"
      content_tag :span, class: "label label-danger" do
        status.titleize
      end
    end
  end

  def role_for(id)
    return nil unless id.present?
    role = SysUserPermission.find_by_id(id)
    return nil unless role.present?

    x = case role.title
    when "Super user"
      "Marketer"
    when "RCA User"
      "RCA"
    when "3rd party user"
      "Third Party"
    when "Broadcast user"
      "Broadcaster"
    end
    return x
  end

  def html_date(date)
    return nil unless date.present?
    date.strftime("%B %d, %Y")
  end

  def shared_params(id = nil, path = nil)
    parameters = params.dup
    parameters.delete(:controller)
    parameters.delete(:action)
    parameters.delete(:utf8)

    if id.present?
      parameters[:station_id] = id
    end

    if path.present?
      str = path + "?"
      x = 1
      parameters.each do |key,value|
         str << "&" if x == 1
        if key == "q"
          xx = 1
          value.each do |kk,vv|
            if xx == 1 ? xx += 1 : str << "&"
              str += "q[#{key}]=#{value.to_s}"
            end
          end
          xx += 1
        else
          str += "#{key}=#{value.to_s}"
        end
        x += 1
      end
      str
    else
      parameters
    end
  end

  def html_days
    days = []
    (0..6).each do |x|
      days << (Date.today + x).strftime("%a")
    end
    return days
  end

  def last_week_minutes(station)
    return [] unless station.present?
    minutes = []
    (0..6).each do |x|
      reports = station.reports.where(report_date: ((Date.today - 7) + x))
      if reports.present?
        minutes << reports.collect(&:total_minutes).sum.to_i
      else
        minutes << 0
      end
    end
    return minutes
  end
end
