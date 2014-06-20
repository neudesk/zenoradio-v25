class ReachoutTabListenerMinutes < Struct.new(:param)
  def perform   
    begin
      p "******************************************************"
      p "---REACHOUT TAB LISTENER MINUTES BY GATEWAY ID------- "
      p "******************************************************"
      p "START TIME :"
      p Time.now
      end_date = DateTime.now 
      start_date = DateTime.now - 5.months
      table_name = "reachout_tab_listener_minutes_by_gateway"
      if  !ActiveRecord::Base.connection.tables.include?(table_name)
        ActiveRecord::Schema.define(:version => 20140203143328) do
          create_table "#{table_name}", :force => true do |t|
            t.integer  "listener_id"
            t.string  "ani_e164"
            t.integer  "gateway_id"
            t.string  "did_e164"
            t.integer  "minutes"
            t.datetime "created_at",    :null => false
          end
        end
      else
        sql = "TRUNCATE TABLE `#{table_name}`"
        ActiveRecord::Base.connection.execute(sql)
      end
      amount_of_minutes = AdminSetting.find_by_name("MIN Listener amount of minutes").value
      amount_of_minutes = amount_of_minutes.present? ? amount_of_minutes.to_i : 60 #default value
      p "------------------------------"
      p "Processing date : #{end_date.strftime('%Y-%m-%d')}"
      p "------------------------------"
      p sql = "INSERT into #{table_name} (listener_ani_id,listener_id, ani_e164, gateway_id, did_e164, minutes, created_at)
               SELECT listener_ani_id,listener_id, ani_e164, gateway_id, did_e164, sum(seconds/60) as minutes,'#{end_date.strftime('%Y-%m-%d')}' as created_at from log_call 
              where date(date_start)>'#{start_date.strftime('%Y-%m-%d')}' and length(ani_e164)=11 group by gateway_id,listener_id  having minutes > #{amount_of_minutes}"
      ActiveRecord::Base.connection.execute(sql)
      p "INSERT OPERATION EXECUTED"
      update_sql = "UPDATE reachout_tab_listener_minutes_by_gateway
        INNER JOIN data_listener_ani as dla on dla.id =reachout_tab_listener_minutes_by_gateway.listener_ani_id
        INNER JOIN data_listener_ani_carrier as dlac on dlac.id = dla.carrier_id
        SET reachout_tab_listener_minutes_by_gateway.carrier_id = dla.carrier_id,
        reachout_tab_listener_minutes_by_gateway.carrier_title = dlac.title"
      ActiveRecord::Base.connection.execute(update_sql)
      p "UPDATE OPERATION EXECUTED"
      p "END TIME :"
      p Time.now
      p "******************************************************"
      p "-- END REACHOUT TAB LISTENER MINUTES BY GATEWAY ID--- "
      p "******************************************************"
    rescue
    end
  end
  

end