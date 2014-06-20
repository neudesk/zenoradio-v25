class HomeController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :filter_data_to_slides, :only => [:slider_search]


  def index
    if !current_user.is_marketer?
      @map_of_listeners = map_of_listeners
    end
    @result_total = status
    report_type = params[:type].present? ? params[:type] : "gateway"
    @stations_result = Kaminari.paginate_array(stations(report_type)).page(params[:page]).per(10) if stations(report_type).present?
    @total_minutes = total_minutes_chart
    if current_user.is_rca?
      @result = get_top_3_stations("rca_id", current_user.id).sort { |a, b| b[3].to_i <=> a[3].to_i }
    end
  end

  def get_map_of_listeners
    render :json => map_of_listeners
  end

  def total_minutes_chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table.new_column('number', 'Minutes')
    rows = get_total_minutes
    #SummaryListen.report_minutes(current_user, day, gateway_id, channel_id)
    data_table.add_rows(rows)
    opts = {width: 930,
            height: 250,
            title: 'Total Minutes',
            :titleTextStyle => {color: '#11515E', fontSize: '14', bold: true},
            colors: ["#AE94D1"],
            :chartArea => {:left => 75, :top => 40, :width => 750},
            areaOpacity: 1.0, hAxis: {slantedTextAngle: 45, slantedText: true}}
    GoogleVisualr::Interactive::AreaChart.new(data_table, opts)
  end

  def get_total_minutes
    results = []

    if current_user.is_marketer?
      sql = "SELECT report_hours,total_minutes from report_total_minutes_by_hour where  gateway_id IS NULL "
    else
      gateway_ids = (current_user.stations.present? ? current_user.stations.map(&:id) : nil)
      if gateway_ids.present?
        sql = "SELECT report_hours,sum(total_minutes) from report_total_minutes_by_hour where gateway_id IN (#{gateway_ids.join(',')}) GROUP BY report_hours "
      end
    end
    if sql.present?
      sql_result = ActiveRecord::Base.connection.execute(sql).to_a
      results =[]
      (0..23).each do |hour|
        result = sql_result.detect { |r| r[0] == hour }
        if hour <= 11
          h = hour > 0 ? hour : 12
          results << [h.to_s + " AM", result.present? ? result[1] : 0]
        else
          h = hour > 12 ? hour-12 : 12
          results << [h.to_s + " PM", result.present? ? result[1] : 0]
        end
      end
    end
    results
  end


  def track_customize
    broken_down, from_day = get_filter_time(params[:day_id].to_i)
    current_user.track_aggregate_customs(params[:check_list], broken_down, from_day)
    flash[:notice] = "Updated successfully."
    render :nothing => true
  end

  def get_top_3_stations(type, id)
    result = []
    if DateTime.now.strftime("%m") >= "01" && DateTime.now.strftime("%m") < "07"
      table_name = "report_#{DateTime.now.strftime('%Y')}_1"
    else
      table_name = "report_#{DateTime.now.strftime('%Y')}_2"
    end
    where = "AND dg.#{type} = #{id}"

    five_weeks_sql = "SELECT GROUP_CONCAT(res.report_week order by res.report_week ASC), GROUP_CONCAT(total_minutes order by res.report_week ASC),res.title,res.id,count(total_minutes) as total FROM
                        ( SELECT WEEK(report.report_date,6) as report_week, sum(total_minutes) as total_minutes,dg.title,dg.id FROM #{table_name} as report 
                         INNER JOIN data_gateway as dg on dg.id = report.gateway_id 
                          WHERE report_date >= CURDATE() - INTERVAL 5 WEEK and dg.title IS NOT NULL and dg.is_deleted = false
                          #{where}
                          GROUP BY dg.id,report_week HAVING total_minutes > 1000 ) as res 
                        GROUP BY res.id HAVING total >= 5"

    last_week_sql = "SELECT sum(total_minutes),dg.title,dg.id FROM #{table_name} as report
                         INNER JOIN data_gateway as dg on dg.id = report.gateway_id 
                          WHERE report_date >= '#{1.week.ago.at_beginning_of_week(:sunday).strftime("%Y-%m-%d")}' 
                                and report_date < '#{(DateTime.now - 1.week).strftime("%Y-%m-%d")}' 
                                and dg.title IS NOT NULL and dg.is_deleted = false
                         #{where}
                          GROUP BY dg.id"

    current_week_sql = "SELECT sum(total_minutes),dg.title,dg.id FROM #{table_name} as report
                         INNER JOIN data_gateway as dg on dg.id = report.gateway_id 
                        WHERE report_date >= '#{0.week.ago.at_beginning_of_week(:sunday).strftime("%Y-%m-%d")}' and report_date <= '#{DateTime.now.strftime("%Y-%m-%d")}' 
                      and dg.title IS NOT NULL and dg.is_deleted = false
                       #{where}
                          GROUP BY dg.id"


    last_weeks_data =ActiveRecord::Base.connection.execute(five_weeks_sql).to_a
    current_week_data =ActiveRecord::Base.connection.execute(current_week_sql).to_a

    if params["type"] == "minutes" || params["type"] == "users"

      last_weeks_data.each do |last|
        current = []
        current = current_week_data.detect { |curr| curr[2] == last[3] } if current_week_data[0].present?
        results = last[1].split(',')
        no_of_current_week = DateTime.now.cweek
        weeks_no_res = last[0].split(',')

        if results.length < 5
          ((no_of_current_week-5)..no_of_current_week).each_with_index do |w, index|
            if weeks_no_res[index].to_i != w.to_i
              weeks_no_res.insert(index, 0)
              results.insert(index, 0)
            end
          end
        end
        one_week = results.present? && results[4].present? ? results[4] : 0
        current_week = current.present? && current[0].present? ? current[0] : 0
        title = last[2]
        id = last[3]
        result << [title, id, one_week.to_i, current_week.to_i]
      end

    else
      current_to_last_week_data = ActiveRecord::Base.connection.execute(last_week_sql).to_a
      last_weeks_data.each do |last|
        current = []
        current = current_week_data.detect { |curr| curr[2] == last[3] } if current_week_data[0].present?
        current_to_last_week = []
        current_to_last_week = current_to_last_week_data.detect { |curr| curr[2] == last[3] } if current_to_last_week_data[0].present?

        results = last[1].split(',')
        no_of_current_week = DateTime.now.cweek
        weeks_no_res = last[0].split(',')

        if results.length < 5
          ((no_of_current_week-5)..no_of_current_week).each_with_index do |w, index|
            if weeks_no_res[index].to_i != w.to_i
              weeks_no_res.insert(index, 0)
              results.insert(index, 0)
            end
          end
        end

        two_weeks = results.present? && results[3].present? ? results[3] : 0
        one_week = results.present? && results[4].present? ? results[4] : 0
        current_week = current.present? && current[0].present? ? current[0] : 0
        last_week = current_to_last_week.present? && current_to_last_week[0].present? ? current_to_last_week[0] : 0

        first_val, compare_current_val = 0, 0

        if two_weeks != 0 && one_week != 0
          first_val = (100-((one_week.to_i * 100)/two_weeks.to_i))
        end

        if  last_week.present? && last_week != 0 && current_week.present? && current_week != 0
          compare_current_val = (100-((current_week.to_i * 100)/last_week.to_i))
        end
        title = last[2]
        id = last[3]
        result << [title, id, first_val, compare_current_val]
      end
    end
    result
  end

  # Map of listeners
  def map_of_listeners
    if current_user.is_broadcaster? || current_user.is_rca?
      results = []
      log_call_results = []
      user_stations = current_user.stations
      if user_stations.present?
        where = "and n.call_gateway_id in (#{user_stations.map(&:id).join(',')})"
        sql_log_call = "select n.call_ani_e164 from now_session as n, data_gateway as g  where n.call_gateway_id=g.id and n.call_ani_e164 <>'' #{where}"
        result_log_call = ActiveRecord::Base.connection.execute(sql_log_call).to_a
        all_listeners = result_log_call.length
        uniq_listeners = result_log_call.uniq.length

        result_log_call.each do |listener|
          log_call_results << listener[0].slice(0, 3) if listener[0].to_s.length == 11 && listener[0].to_s.slice!(0) == "1"
        end

        listener_codes = log_call_results.join(',')
        if listener_codes.present?
          area_codes = AreaCodes.where("area_code in (#{listener_codes})").group(:area_code)
          area_codes.each_with_index do |ac, index|
            listeners_count = log_call_results.select { |l| ac['area_code'] == l }.length
            if listeners_count > 1
              (1..listeners_count).each_with_index do |lis, index|
                increment_value = index/1125213.00+0.002212
                results << {:area_code => ac['area_code'], :lat => ac['latitude'].to_f+increment_value, :long => ac['longitude'].to_f+increment_value, :listener_count => listeners_count}
              end
            else
              results << {:area_code => ac['area_code'], :lat => ac['latitude'].to_f, :long => ac['longitude'].to_f, :listener_count => listeners_count}
            end

          end
        end
        us_listeners = results.length
        {:results => results, :us_listeners => us_listeners, :all_listeners => all_listeners, :uniq_listeners => uniq_listeners}
      end

    end
  end

  #
  #  Dashboard
  #

  def get_status
    @result_total = status
    render :partial => "summary_head_list"
  end

  def get_stations
    @stations_result = Kaminari.paginate_array(stations(params[:type])).page(params[:page]).per(10)
    render :partial => "summary_list_body"
  end

  def status
    result = []
    if current_user.is_broadcaster? || current_user.is_rca?
      user_stations = current_user.stations
      if user_stations.present?
        sql = "select count(*),count(distinct(call_gateway_id)),count(distinct(listen_content_id)),count(distinct(call_server_id)) from now_session
                 where call_gateway_id in (#{user_stations.map(&:id).join(',')}) and call_ani_e164 <>''"
        result = ActiveRecord::Base.connection.execute(sql).to_a[0]
      end
    else
      sql = "select count(*),count(distinct(call_gateway_id)),count(distinct(listen_content_id)),count(distinct(call_server_id)) from now_session where call_ani_e164 <>''"
      result = ActiveRecord::Base.connection.execute(sql).to_a[0]
    end
    result
  end

  def stations(type)
    results = []
    date = (DateTime.now - 15.minutes).strftime("%Y-%m-%d %H:%M:%S")

    where = ""
    where_session = ""
    user_has_stations = true

    if current_user.is_broadcaster? || current_user.is_rca?
      user_stations = current_user.stations
      if user_stations.present?
        where = "and gateway_id in (#{user_stations.map(&:id).join(',')})"
        where_session = "and g.id in (#{user_stations.map(&:id).join(',')})"
      else
        user_has_stations = false
      end
    end
    if user_has_stations
      case type
        when "gateway"
          sql_now_session = "SELECT  g.id,'', g.title,count(*) FROM now_session as n, data_gateway as g  where n.call_gateway_id=g.id group by g.id "
          sql_log_call ="SELECT 
                    gateway_id,count(*),sum(seconds),
                    sum(if( (seconds>=0) and (seconds<60) ,1,0)),
                    sum(if( (seconds>=60) and (seconds<900) ,1,0)) ,
                    sum(if( (seconds>=900) ,1,0)) 
                  FROM
                    log_call 
                  WHERE 
                    seconds is not null 
                    and date_stop is not null 
                    and date_stop> '#{date}'
                   #{where}
                  GROUP by gateway_id "
        when "content"
          sql_now_session = "SELECT conf.id, g.id, CONCAT(if(c.title is null,'-',c.title), ' / ', if(g.title is null,'-',g.title)),count(*)  
                    FROM now_session as n, data_content as c, data_gateway as g, data_gateway_conference as conf  
                    where n.listen_gateway_conference_id=conf.id and conf.gateway_id=g.id and conf.content_id=c.id #{where_session}
                    group by conf.id "
          sql_log_call = "select 
                    gateway_conference_id,count(*),sum(seconds),
                    sum(if( (seconds>=0) and (seconds<60) ,1,0)),
                    sum(if( (seconds>=60) and (seconds<900) ,1,0)) ,
                    sum(if( (seconds>=900) ,1,0)) 
                  from
                    log_listen
                  where 
                    seconds is not null 
                    and date_stop is not null 
                    and date_stop> '#{date}'
                    group by gateway_conference_id"

        when "entryway"
          sql_now_session = "SELECT e.id, g.id, CONCAT(if(e.title is null,'-',e.title), ' / ', if(g.title is null,'-',g.title)),count(*)  
                        FROM now_session as n, data_entryway as e, data_gateway as g   
                        where n.call_gateway_id=g.id and n.call_entryway_id=e.id #{where_session}
                        group by e.id "
          sql_log_call = "select 
                      entryway_id,count(*),sum(seconds),
                      sum(if( (seconds>=0) and (seconds<60) ,1,0)),
                      sum(if( (seconds>=60) and (seconds<900) ,1,0)) ,
                      sum(if( (seconds>=900) ,1,0)) 
                    from
                      log_call
                    where 
                      seconds is not null 
                      and date_stop is not null 
                      and date_stop>'#{date}'
                      #{where}
                      group by entryway_id"
      end


      result_now_session = ActiveRecord::Base.connection.execute(sql_now_session).to_a
      result_log_call = ActiveRecord::Base.connection.execute(sql_log_call).to_a

      result_now_session.each do |session|
        item = result_log_call.detect { |r| session[0] == r[0] }
        acd_3_percent, acd_2_percent, acd_3_percent = [0, 0, 0]
        if item.present?
          if item[1].present? && item[1]> 0 && item[3].present? && item[3]> 0
            acd_1_percent = 100 *(item[3].to_f / item[1].to_f)
          end
          if item[1].present? && item[1]> 0 && item[4].present? && item[4]> 0
            acd_2_percent = 100 *(item[4].to_f / item[1].to_f)
          end
          if item[1].present? && item[1]> 0 && item[5].present? && item[5]> 0
            acd_3_percent = 100 *(item[5].to_f / item[1].to_f)
          end
          results << [item[0], session[2], session[3], item[1], acd_1_percent.to_i, acd_2_percent.to_i, acd_3_percent.to_i]
        end
      end
      results.sort { |a, b| b[2] <=> a[2] }
    end

  end


  protected
  def get_filter_time(time)
    from_day = time.days.ago
    broken_down = :day
    case time
      when TWENTY_FOUR_HOURS
        broken_down = :hour
      when SEVEN_DAYS_BY_HOURS
        broken_down = :hour
        from_day = 7.days.ago
    end
    return broken_down, from_day
  end
end
