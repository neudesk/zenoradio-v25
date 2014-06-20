class Graph
  def self.generate_for(days, station)
    case days
    when "today"
      start_date = Date.today.beginning_of_day
      self.generate_for_recent(station, start_date)
    when "yesterday"
      start_date = Date.yesterday.beginning_of_day
      self.generate_for_recent(station, start_date)
    when "30days"
      start_date = Date.today - 30.days
      self.generate_for_long(station, start_date, 3)
    when "90days"
      start_date = Date.today - 100.days
      self.generate_for_long(station, start_date, 10)
    end
  end

  def self.generate_for_long(station, start_date, counter)
    if DateTime.now.strftime("%m") >= "01" && DateTime.now.strftime("%m") < "07"
      end_table_name = "report_#{DateTime.now.strftime('%Y')}_1"
    else
      end_table_name = "report_#{DateTime.now.strftime('%Y')}_2"
    end

    arr = []
    (0..9).each do |interval|
      start_date1 = start_date + ((interval * counter) + 1).days
      end_date = start_date1 + (counter - 1).days
      sql = "SELECT report_date,users_by_time FROM #{end_table_name} WHERE report_date >= '#{start_date1}' AND  report_date <= '#{end_date}' AND gateway_id = #{station.id}"
      result =  ActiveRecord::Base.connection.execute(sql).to_a
      if result.present?
        arr << [end_date.strftime("%b %e"), result.collect {|x| x.last}.sum ]
      else
        arr << [end_date.strftime("%b %e"), 0]
      end
    end
    return arr
  end

  def self.generate_for_recent(station, start_date)
    arr = []
    (0..7).each do |interval|
      start_time = interval * 3
      result = ReportUsersByTime.where(report_date: start_date.to_date, report_hours: [start_time, start_time + 1, start_time + 2], gateway_id: station.id)
      puts result.inspect
      arr << [start_time, result.size]
    end
    return arr
  end
end