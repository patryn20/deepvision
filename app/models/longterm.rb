class Longterm
  include CpuUsage

  @r = LovelyRethink.db
  @rr = RethinkDB::RQL.new

  def self.save_from_json_post(json_string)
    object = JSON::parse(json_string)

    provided_api_key = object['apikey']

    longterm_object = object['payload'][0]['LONGTERM']
    longterm_object['id'] = provided_api_key + "-" + object['timestamp'].to_s
    longterm_object['apikey'] = provided_api_key
    longterm_object['timestamp'] = object['timestamp']
    #longterm_object['uptime'] = object['payload'][0]['INSTANT']['Uptime']

    longterm_object['CPU.total.usage'] = Longterm.calculate_cpu_usage(longterm_object)
    # need to calculate the usage on a per CPU/core basis
    total_Bps, total_rx_Bps, total_tx_Bps = Longterm.calculate_network_usage(longterm_object)
    longterm_object['Network.Interface.total.Bps'] = total_Bps
    longterm_object['Network.Interface.total.rx_Bps'] = total_rx_Bps
    longterm_object['Network.Interface.total.tx_Bps'] = total_tx_Bps
    # need to calculate the usage on a per interface basis

    @r.table('longterm').insert(longterm_object).run(durability: "soft")
  end

  def self.get_all_most_recent
    hosts = @r.table('hosts').run
    hosts.map { |host| {:hosts => host, :longterm => Longterm.get_last_entry_by_apikey(host["id"]).first} }
  end

  def self.get_last_entry_by_apikey(apikey, skip = nil)
    r_obj = @r.table('longterm').get_all(apikey, :index => "apikey").orderby(@rr.desc(:id))
    r_obj.skip(skip) unless skip.nil?
    r_obj.limit(1).run
  end

  def self.get_previous_entry_by_id(id)
    @r.table('longterm').between(nil, id).limit(1).run
  end

  def self.get_highest_network_usage_in_range(longterm_object, range = 24.hours)
    end_time = Time.at longterm_object["timestamp"]
    start_time = end_time - range
    start_id = longterm_object["apikey"] + "-" + start_time.to_i.to_s
    end_id = longterm_object["apikey"] + "-" + end_time.to_i.to_s
    @r.table('longterm').between(start_id, end_id, :right_bound => 'closed').map {|record| record['Network.Interface.total.Bps']}.reduce {|left, right| @rr.branch(left > right, left, right)}.run
  end

  def self.calculate_cpu_usage(longterm_object)

    last_object = Longterm.get_last_entry_by_apikey(longterm_object['apikey'], 1).first

    if !last_object.nil?
      available_time = Longterm.available_cpu_time last_object['timestamp'], longterm_object['timestamp']

      second_cpu_times = longterm_object.select {|key, value| key.include?("CPU.cpu")}.values
      first_cpu_times = last_object.select {|key, value| key.include?("CPU.cpu")}.values

      cpu_cores = first_cpu_times.size / 3

      first_utilized_time = Longterm.sum_utilized_cpu_time *first_cpu_times
      second_utilized_time = Longterm.sum_utilized_cpu_time *second_cpu_times

      total_utilized_time = Longterm.utilized_cpu_time first_utilized_time, second_utilized_time

      cpu_usage = Longterm.cpu_utilization_percent(available_time, total_utilized_time, cpu_cores)

      return cpu_usage
    end

    nil

  end

  def self.calculate_memory_usage(longterm_object)
    total_memory = longterm_object["Memory.real.used"] + longterm_object["Memory.real.free"]
    memory_used_by_processes = longterm_object["Memory.real.used"] - longterm_object["Memory.real.buffers"] - longterm_object["Memory.real.cache"]
    ((memory_used_by_processes.to_f/total_memory.to_f) * 100.0).round(2)
  end

  def self.calculate_network_usage(longterm_object)
    last_object = Longterm.get_previous_entry_by_id(longterm_object['id']).first
    if !last_object.nil?
      time_diff = longterm_object["timestamp"] - last_object["timestamp"]
      current_rx_bytes = longterm_object.select {|key, value| key.include?(".rx_bytes")}.values.reduce(:+)
      last_rx_bytes = last_object.select {|key, value| key.include?(".rx_bytes")}.values.reduce(:+)
      current_tx_bytes = longterm_object.select {|key, value| key.include?(".tx_bytes")}.values.reduce(:+)
      last_tx_bytes = last_object.select {|key, value| key.include?(".tx_bytes")}.values.reduce(:+)

      rx_bytes_second = (current_rx_bytes - last_rx_bytes)/time_diff
      tx_bytes_second = (current_tx_bytes - last_tx_bytes)/time_diff
      total_bytes_second = rx_bytes_second + tx_bytes_second
      return total_bytes_second, rx_bytes_second, tx_bytes_second
    end

    [nil, nil, nil]
  end

  def self.calculate_swap_usage(longterm_object)
    total_swap = longterm_object["Memory.swap.free"] + longterm_object["Memory.swap.used"]
    ((longterm_object["Memory.swap.used"].to_f/total_swap.to_f) * 100.0).round(2)
  end

  def self.calculate_max_load(longterm_object)
    # count CPUs and use as maximum optimal load
    longterm_object.select {|key, value| key[/CPU\.cpu[\d]\.user/]}.length
  end

  

end