class ReportsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @gateway_id = params[:gateway_id] || params[:station_id]
    @gateway_id = current_user.stations[0].id if current_user.stations.length == 1
    @no_of_stations = current_user.stations.length
    @all_current_user_did = DataEntryway.where("gateway_id = '#{@gateway_id}' and is_deleted = false").select("data_entryway.did_e164, data_entryway.id").order(:did_e164)
    #get_graphs
  end
  def get_graphs
    gateway_id = params[:gateway_id] 
    gateway_id = current_user.stations[0].id if current_user.stations.length == 1
    number = (params[:month] == "") ? 0 : params[:month].to_i
    entryway_id = (params[:entryway_id].to_i == 0)? nil : params[:entryway_id]
    reports =  reports_data(number, gateway_id,entryway_id)
    total_minutes = total_minutes_chart(reports)
    minutes = DataListenerAtGateway.get_total_minutes(current_user, gateway_id)
    month = number.month.ago
    render :partial => "reports/graphs", :locals => {:total_minutes => total_minutes, :reports => reports,:month => month, :minutes => minutes }
  end

  def total_minutes_chart(reports)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table.new_column('number', 'Minutes')
    rows = []
    reports.each do |rep|
      rows<< [rep[0].strftime("%d").to_s,rep[4]]
    end
    data_table.add_rows(rows)
    opts = { width: 940,
      height: 250,
      title: 'Total Minutes',
      :titleTextStyle => {color: '#11515E', fontSize: '14', bold: true},
      colors: ["#AE94D1"],
      :chartArea => {:left => 70, :top => 40, :width => 770},
      areaOpacity: 1.0, hAxis: {slantedTextAngle: 45, slantedText: true}}
    GoogleVisualr::Interactive::AreaChart.new(data_table, opts)
  end
  
  def reports_data(number,gateway_id = nil,entryway_id = nil)
    begin
      year = number.month.ago.beginning_of_month.strftime('%Y')
      month = number.month.ago.end_of_month.strftime('%m')
      days = Time.days_in_month(number.month.ago.strftime('%m').to_i, year=number.month.ago.strftime('%Y').to_i)
      sql_result = nil

      start_date = Date.parse("#{year}-#{month}-#{01}")
      end_date = Date.parse("#{year}-#{month}-#{days}")
      
      if end_date.strftime("%m") >= "01" && end_date.strftime("%m") < "07"
        entryway_id.present? ? table_name = "report_by_did_#{end_date.strftime('%Y')}_1" : table_name = "report_#{end_date.strftime('%Y')}_1"
      else
        entryway_id.present? ? table_name = "report_by_did_#{end_date.strftime('%Y')}_2" : table_name = "report_#{end_date.strftime('%Y')}_2"
      end
      if ActiveRecord::Base.connection.tables.include?(table_name)
        if gateway_id.present? && entryway_id.blank?
          sql = " SELECT DATE(report_date),new_users,active_users,sessions,total_minutes FROM #{table_name} WHERE report_date >= '#{start_date}' 
            AND  report_date <= '#{end_date}' AND gateway_id = '#{gateway_id}'"
        elsif entryway_id.present? 
          sql = " SELECT DATE(report_date),new_users,active_users,sessions,total_minutes FROM #{table_name} WHERE report_date >= '#{start_date}' 
            AND  report_date <= '#{end_date}' AND entryway_id = '#{entryway_id}'"
        else
          if current_user.is_marketer?
            sql = " SELECT DATE(report_date),new_users,active_users,sessions,total_minutes FROM #{table_name} WHERE report_date >= '#{start_date}' 
            AND  report_date <= '#{end_date}' AND gateway_id IS NULL"
          else
            gateway_ids = current_user.stations.map(&:id)
            sql = " SELECT DATE(report_date) as dates,sum(new_users),sum(active_users),sum(sessions),sum(total_minutes) FROM #{table_name} WHERE report_date >= '#{start_date}' 
            AND  report_date <= '#{end_date}' AND gateway_id IN (#{gateway_ids.join(',')}) group by dates "
          end

        end
        sql_result =  ActiveRecord::Base.connection.execute(sql).to_a
        total_new_users = sql_result.map { |r| r[1]}.inject(:+)
        total_active_users = sql_result.map { |r| r[2]}.inject(:+)
        total_sessions = sql_result.map { |r| r[3]}.inject(:+)
        total_minutes = sql_result.map { |r| r[4]}.inject(:+)
        @totals = [total_new_users, total_active_users, total_sessions, total_minutes]
      end
      sql_result
      sql_result
    rescue => error
      error.message
    end
  end
  
end
