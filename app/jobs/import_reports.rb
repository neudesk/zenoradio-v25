class ImportReports < Struct.new(:param)
  def perform   
    begin
      p "START TIME :"
      p Time.now
      # *********************************************
      # ACTIVE USERS  = users who has activity in the last 30 days and TODAY
      # NEW USERS = user who has no activity in the last 30 day,but he has activity TODAY 
      # SESSION = total calls from TODAY
      # USERS BY TIME = distinct users by TODAY 
      # *********************************************
      st_date = nil
      ed_date = nil
      
      #RESET CRON JOB FUNCTIONALITY
      if param == "RESET"
        #GET THE FIRST RECORD AND LAST RECORD FROM DATABASE
        sql="SELECT concat('TRUNCATE TABLE ', TABLE_NAME, ';') FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'report_20%'"
        ActiveRecord::Base.connection.execute(sql).to_a.each do |truncate|
          ActiveRecord::Base.connection.execute(truncate[0])
        end

        start_date_sql = "SELECT DATE(date_start) as start_date FROM `log_call` ORDER BY date_start ASC limit 1"
        end_date_sql = "SELECT DATE(date_start) as end_date FROM `log_call` ORDER BY date_start DESC limit 1"
        
        st_date = Date.parse((ActiveRecord::Base.connection.execute(start_date_sql).to_a)[0][0].strftime("%Y-%m-%d"))
        ed_date = Date.parse((ActiveRecord::Base.connection.execute(end_date_sql).to_a)[0][0].strftime("%Y-%m-%d"))

        
      elsif param == "DAILY"
        # DAILY CRON JOB FUNCTIONALITY
        table_name=""
        if (DateTime.now-1.days).strftime("%m") >= "01" && (DateTime.now-1.days).strftime("%m") < "07"
          table_name = "report_#{(DateTime.now-1.days).strftime('%Y')}_1"
        else
          table_name = "report_#{(DateTime.now-1.days).strftime('%Y')}_2"
        end
        
        if ActiveRecord::Base.connection.tables.include?(table_name)
          start_date_sql = "SELECT report_date FROM `#{table_name}` ORDER BY report_date DESC LIMIT 1"
          first_date = (ActiveRecord::Base.connection.execute(start_date_sql).to_a)
          if first_date.present? && first_date[0][0].present?
            st_date= Date.parse(first_date[0][0].to_s)+1.days
            ed_date = DateTime.now-1.days
          else
            st_date = DateTime.now.at_beginning_of_month
            ed_date = DateTime.now-1.days
          end
        else 
          ActiveRecord::Schema.define(:version => 20140203143328) do
            create_table "#{table_name}", :force => true do |t|
              t.date     "report_date"
              t.integer  "active_users"
              t.integer  "new_users"
              t.integer  "users_by_time"
              t.integer  "sessions"
              t.integer  "total_minutes"
              t.integer  "gateway_id"
              t.datetime "created_at",    :null => false

            end
          end
          st_date= DateTime.now-1.days
          ed_date = DateTime.now - 1.days
        end
      end
      
      st_date.upto(ed_date) {|end_date|

        if end_date.strftime("%m") >= "01" && end_date.strftime("%m") < "07"
          table_name = "report_#{end_date.strftime('%Y')}_1"
        else
          table_name = "report_#{end_date.strftime('%Y')}_2"
        end
        
        if  !ActiveRecord::Base.connection.tables.include?(table_name)
          ActiveRecord::Schema.define(:version => 20140203143328) do
            create_table "#{table_name}", :force => true do |t|
              t.date     "report_date"
              t.integer  "active_users"
              t.integer  "new_users"
              t.integer  "users_by_time"
              t.integer  "sessions"
              t.integer  "total_minutes"
              t.integer  "gateway_id"
              t.datetime "created_at",    :null => false

            end
          end
        end
        p "******************************************************"
        p "----------------REPORTS AGGREGATE TABLE-------------- "
        p "******************************************************"
        p "Processing date : #{end_date}"
        
        day = end_date.strftime("%-d")
        start_date = end_date - 30.days
        end_month = end_date.strftime("%m")
        start_month = start_date.strftime("%m")
        end_year = end_date.strftime("%Y")
        start_year = start_date.strftime("%Y")
        
      
        active_users_sql = "SELECT COUNT(*) FROM (SELECT  listener_id,COUNT(listener_id) AS listener_count,GROUP_CONCAT(distinct(concat(DAY(date_start),'-',MONTH(date_start)))) as `dates`		      FROM 
                    `log_call` WHERE   DATE(date_start) > '#{start_date}'  AND DATE(date_start) <= '#{end_date}' GROUP BY listener_id HAVING 
                    dates LIKE '%,#{day}-#{end_date.strftime("%-m")}' AND listener_count > 1) as results"
      
        new_users_sql = "SELECT COUNT(*) from (SELECT listener_id,COUNT(listener_id) AS listener_count,GROUP_CONCAT(distinct(concat(DAY(date_start),'-',MONTH(date_start)))) as `dates` FROM 
                   `log_call`  WHERE DATE(date_start) > '#{start_date}' AND DATE(date_start) <= '#{end_date}' GROUP BY listener_id HAVING dates='#{day}-#{end_date.strftime("%-m")}') as results"
        
        total_users_by_time_sql ="Select Count(distinct listener_id) from log_call_#{end_year}_#{end_month} where DATE(date_start)='#{end_date}'"
        total_session_sql = "select count(*) from log_call_#{end_year}_#{end_month} where Date(date_start) = '#{end_date}'"
        total_minutes_sql = "SELECT sum(seconds/60) FROM `summary_listen` WHERE DATE(date) = '#{end_date.strftime("%Y-%m-%d")}'"
        
        
		    # BY GATEWAY_ID
        p "BY GATEWAY_ID : " + Time.now.to_s
        
        session_by_gateway_id_sql = "SELECT gateway_id,COUNT(gateway_id) as sessions from log_call_#{end_year}_#{end_month} where Date(date_start) = '#{end_date}' group by gateway_id"          
       
        users_by_gateway_id_sql = "SELECT gateway_id,COUNT(distinct listener_id) as users_sum  from log_call_#{end_year}_#{end_month} where DATE(date_start)='#{end_date}' GROUP BY gateway_id"
      
        total_minutes_by_gateway_id_sql = "SELECT gateway_id,sum(seconds/60) as total_minutes from  `summary_listen` WHERE DATE(date) = '#{end_date}' group by gateway_id"
       
        current_day_ids_sql = "SELECT distinct (listener_id),gateway_id FROM `log_call_#{end_year}_#{end_month}`
                                WHERE  date(date_start) = '#{end_date}' group by gateway_id,listener_id;"
        
        if (ActiveRecord::Base.connection.tables.include?("log_call_#{start_year}_#{start_month}"))
          last_days_ids_sql = "SELECT  distinct listener_id,gateway_id FROM `log_call_#{start_year}_#{start_month}`  
                              WHERE  date(date_start) > '#{start_date}' group by gateway_id,listener_id  
                              UNION ALL 
                              SELECT distinct listener_id,gateway_id  FROM `log_call_#{end_year}_#{end_month}` 
                              WHERE  date(date_start) < '#{end_date}' group by gateway_id,listener_id;"

        else
          last_days_ids_sql = "SELECT distinct listener_id,gateway_id  FROM `log_call_#{end_year}_#{end_month}` 
                              WHERE  date(date_start) < '#{end_date}' group by gateway_id,listener_id;"
        end

        session_by_did = ActiveRecord::Base.connection.execute(session_by_gateway_id_sql).to_a
        users_by_did = ActiveRecord::Base.connection.execute(users_by_gateway_id_sql).to_a   
        total_minutes_by_did = ActiveRecord::Base.connection.execute(total_minutes_by_gateway_id_sql).to_a
        last_days_ids = ActiveRecord::Base.connection.execute(last_days_ids_sql).to_a 
        current_day_ids = ActiveRecord::Base.connection.execute(current_day_ids_sql).to_a 

        session_by_did.each do |sessions|
          new_user=0
          active_user = 0
          
          last_gateway_id_res = []
          last_gateway_id = last_days_ids.select {|id| id[1]==sessions[0]}
          last_gateway_id.each { |item|  last_gateway_id_res << item[0] } if last_gateway_id.present?

          current_gateway_id_res = []
          current_gateway_id = current_day_ids.select {|id| id[1]==sessions[0]}
          current_gateway_id.each { |item|  current_gateway_id_res << item[0] } if current_gateway_id.present?

          current_gateway_id_res = current_gateway_id_res.present? ? current_gateway_id_res.uniq : nil
          last_gateway_id_res = last_gateway_id_res.present? ? last_gateway_id_res.uniq  : nil

          current_gateway_id_res.each do |id|
            if last_gateway_id_res.present? && (last_gateway_id_res.detect {|x| x == id}).present? 
              active_user +=1
            else
              new_user +=1
            end
          end
          
          users_by_time = users_by_did.detect {|s| s[0] == sessions[0] } 
          total_minutes  = total_minutes_by_did.detect {|t| t[0] == sessions[0]}
          
          sql_insert_gateways = "INSERT INTO #{table_name}( report_date,
                                                            active_users,
                                                            new_users,
                                                            users_by_time,
                                                            sessions,
                                                            total_minutes,
                                                            gateway_id,
                                                            created_at) 
                                          VALUES('#{end_date}',
                                                 '#{active_user}',
                                                 '#{new_user}', 
                                                 '#{users_by_time.present? ? users_by_time[1] : 0}',
                                                 '#{sessions[1]}',
                                                 '#{total_minutes.present? ? total_minutes[1] : 0 }', 
                                                 '#{sessions[0]}',
                                                 '#{Time.now.to_s(:db)}')"
          
          ActiveRecord::Base.connection.execute(sql_insert_gateways)
        end
        p "BY GATEWAY_ID END : " + Time.now.to_s
        p "========================================================================"
       
      
        #total reports without gateway_id
        new_users =  ActiveRecord::Base.connection.execute(new_users_sql).to_a
        p "*************************************************************************"
        p "By TOTAL  On date : #{end_date}" 
        p "new users  = " + new_users[0][0].to_s
        active_users =  ActiveRecord::Base.connection.execute(active_users_sql).to_a
        p "active_users = " + active_users[0][0].to_s
        sessions = ActiveRecord::Base.connection.execute(total_session_sql).to_a
        p "sessions = " + sessions[0][0].to_s
        users_by_time = ActiveRecord::Base.connection.execute(total_users_by_time_sql).to_a
        p "total_minutes = " + sessions[0][0].to_s
        total_minutes = ActiveRecord::Base.connection.execute(total_minutes_sql).to_a
        p "users_by_time = " + users_by_time[0][0].to_s
        sql_insert_totals = "INSERT INTO #{table_name}(report_date,
                                                      active_users,
                                                      new_users,
                                                      users_by_time,
                                                      sessions,
                                                      total_minutes,
                                                      created_at) 
                                  VALUES(' #{end_date}',
                                          '#{active_users[0][0]}',
                                          '#{new_users[0][0]}',
                                          '#{users_by_time[0][0]}',
                                          '#{sessions[0][0]}',
                                          '#{total_minutes[0][0]}'
                                         ,'#{Time.now.to_s(:db)}')"
        ActiveRecord::Base.connection.execute(sql_insert_totals)
        p "========================================================================"
      
      }
      p "END TIME :"
      p Time.now
      p "******************************************************"
      p "----------------END REPORTS AGGREGATE TABLE---------- "
      p "******************************************************"
    rescue => error
      p error.message
    end
  end
end
