class Longterm
  include CpuUsage

  @r = LovelyRethink.db
  @rr = RethinkDB::RQL.new

  def self.save_from_json_post(object)
    provided_api_key = object['apikey']

    longterm_object = object['payload'][0]['LONGTERM'].dup
    previous_longterm_object = Longterm.get_last_entry_by_apikey(provided_api_key, 1).first
    longterm_object['id'] = provided_api_key + '-' + object['timestamp'].to_s
    longterm_object['apikey'] = provided_api_key
    longterm_object['timestamp'] = object['timestamp']
    #longterm_object['uptime'] = object['payload'][0]['INSTANT']['Uptime']

    longterm_object['CPU.total.usage'] = Longterm.calculate_cpu_usage(longterm_object, previous_longterm_object)
    # need to calculate the usage on a per CPU/core basis
    total_bps, total_rx_bps, total_tx_bps = Longterm.calculate_network_usage(longterm_object, previous_longterm_object)
    longterm_object['Network.Interface.total.Bps'] = total_bps
    longterm_object['Network.Interface.total.rx_Bps'] = total_rx_bps
    longterm_object['Network.Interface.total.tx_Bps'] = total_tx_bps
    # need to calculate the usage on a per interface basis

    longterm_object['Disk.total.reads_ps'] = Longterm.calculate_disk_read_rate(longterm_object, previous_longterm_object)
    longterm_object['Disk.total.writes_ps'] = Longterm.calculate_disk_write_rate(longterm_object, previous_longterm_object)

    @r.table('longterm').insert(longterm_object).run(durability: 'soft')
  end

  def self.get_all_most_recent
    hosts = @r.table('hosts').run
    hosts.map { |host| {:hosts => host, :longterm => Longterm.get_last_entry_by_apikey(host['id']).first} }
  end

  def self.get_last_entry_by_apikey(apikey, skip = nil)
    r_obj = @r.table('longterm').get_all(apikey, :index => 'apikey').orderby(@rr.desc(:id))
    r_obj.skip(skip) unless skip.nil?
    r_obj.limit(1).run
  end

  def self.get_host_disks(apikey)
    longterm = Longterm.get_last_entry_by_apikey(apikey).first()

    attributes = [["Disk.reads", /^Disk\..*\.reads$/], ["Disk.writes", /^Disk\..*\.writes$/]]

    disk_array = []

    attributes.each do |attribute|
      keys = longterm.select {|key, value| key. =~ attribute[1]}.keys
      keys.each do |key|
        disk = key.split('.')[1]

        if !disk_array.include?(disk)
          disk_array.push disk
        end


      end
    end

    disk_array.sort
  end

  def self.get_host_disk_stats(apikey, disks, start_time = 30.minutes, end_time = 0.minutes, interval = nil)
    end_time = Time.now - end_time
    start_time = end_time - start_time
    end_timestamp = end_time.to_i
    start_timestamp = start_time.to_i
    start_id = "#{apikey}-#{start_timestamp.to_s}"
    end_id = apikey + '-' + end_timestamp.to_s

    disk_fields = disks.map {|disk| ["Disk.#{disk}.reads", "Disk.#{disk}.writes"]}.flatten
    with_fields_array = disk_fields.dup
    with_fields_array << "timestamp"
    base_fields_hash = Hash[disk_fields.map {|field| [field, 0]}]
    base_fields_hash["count"] = 0
    base_fields_hash["timestamp"] = nil
    base_fields_hash["min_timestamp"] = nil
    base_fields_hash["max_timestamp"] = nil

    group_lambda = self.get_group_by_interval(interval)

    query = @r.table('longterm').between(start_id, end_id, :right_bound => 'closed').grouped_map_reduce(
      group_lambda,
      lambda {|longterm|
        field_hash = Hash[disk_fields.map {|field| [field, @rr.branch(longterm.has_fields(field), longterm[field], 0)]}]
        field_hash["timestamp"]  = longterm["timestamp"]
        field_hash["count"] = 1
        field_hash["min_timestamp"] = longterm["timestamp"]
        field_hash["max_timestamp"] = longterm["timestamp"]
        return field_hash
      },
      base_fields_hash,
      lambda { |acc, longterm|
        accumulator_hash = Hash[disk_fields.map {|field| [field, @rr.branch(acc[field] > longterm[field], acc[field], longterm[field])]}]
        accumulator_hash["min_timestamp"] = @rr.branch((acc["min_timestamp"] < longterm["min_timestamp"]), acc["min_timestamp"], longterm["min_timestamp"])
        accumulator_hash["max_timestamp"] = @rr.branch(acc["max_timestamp"] > longterm["max_timestamp"], acc["max_timestamp"], longterm["max_timestamp"])
        accumulator_hash["count"] = acc["count"].add(longterm["count"])
        return accumulator_hash
      }
    ).map(
      lambda { |longterm|
        final_values = Hash[disk_fields.map {|field| [field, longterm["reduction"][field]]}]
        final_values["timestamp"] = longterm["group"]
        final_values["min_timestamp"] = longterm["reduction"]["min_timestamp"]
        final_values["max_timestamp"] = longterm["reduction"]["max_timestamp"]
        return final_values
      }
    ).run
  end

  def self.get_host_network_interfaces(apikey)
    longterm = Longterm.get_last_entry_by_apikey(apikey).first()

    attributes = [["Network.rx_Bps", /Network\.Interface\..*\.rx_bytes/], ["Network.tx_Bps", /Network\.Interface\..*\.tx_bytes/]]

    interface_array = []

    attributes.each do |attribute|
      keys = longterm.select {|key, value| key. =~ attribute[1]}.keys
      keys.each do |key|
        interface = key.split('.')[2]

        if !interface_array.include?(interface)
          interface_array.push interface
        end


      end
    end

    interface_array.sort
  end

  def self.get_host_network_stats(apikey, interfaces, start_time = 30.minutes, end_time = 0.minutes, interval = nil)
    end_time = Time.now - end_time
    start_time = end_time - start_time
    end_timestamp = end_time.to_i
    start_timestamp = start_time.to_i
    start_id = "#{apikey}-#{start_timestamp.to_s}"
    end_id = apikey + '-' + end_timestamp.to_s

    interface_fields = interfaces.map {|interface| ["Network.Interface.#{interface}.rx_bytes", "Network.Interface.#{interface}.tx_bytes"]}.flatten
    with_fields_array = interface_fields.dup
    with_fields_array << "timestamp"
    base_fields_hash = Hash[interface_fields.map {|field| [field, 0]}]
    base_fields_hash["count"] = 0
    base_fields_hash["timestamp"] = nil
    base_fields_hash["min_timestamp"] = nil
    base_fields_hash["max_timestamp"] = nil

    group_lambda = self.get_group_by_interval(interval)

    query = @r.table('longterm').between(start_id, end_id, :right_bound => 'closed').grouped_map_reduce(
      group_lambda,
      lambda {|longterm|
        field_hash = Hash[interface_fields.map {|field| [field, @rr.branch(longterm.has_fields(field), longterm[field], 0)]}]
        field_hash["timestamp"]  = longterm["timestamp"]
        field_hash["count"] = 1
        field_hash["min_timestamp"] = longterm["timestamp"]
        field_hash["max_timestamp"] = longterm["timestamp"]
        return field_hash
      },
      base_fields_hash,
      lambda { |acc, longterm|
        accumulator_hash = Hash[interface_fields.map {|field| [field, @rr.branch(acc[field] > longterm[field], acc[field], longterm[field])]}]
        accumulator_hash["min_timestamp"] = @rr.branch((acc["min_timestamp"] < longterm["min_timestamp"]), acc["min_timestamp"], longterm["min_timestamp"])
        accumulator_hash["max_timestamp"] = @rr.branch(acc["max_timestamp"] > longterm["max_timestamp"], acc["max_timestamp"], longterm["max_timestamp"])
        accumulator_hash["count"] = acc["count"].add(longterm["count"])
        return accumulator_hash
      }
    ).map(
      lambda { |longterm|
        final_values = Hash[interface_fields.map {|field| [field, longterm["reduction"][field]]}]
        final_values["timestamp"] = longterm["group"]
        final_values["min_timestamp"] = longterm["reduction"]["min_timestamp"]
        final_values["max_timestamp"] = longterm["reduction"]["max_timestamp"]
        return final_values
      }
    ).run
  end

  def self.get_host_overview_stats(apikey, start_time = 30.minutes, end_time = 0.minutes, interval = nil)
    attributes = ["CPU.total.usage", "Disk.reads", "Disk.writes", "Load", "Memory.real.used", "Memory.real.cache", "Memory.real.buffers", "Memory.swap.used", "Network.Interface.total.rx_Bps", "Network.Interface.total.tx_Bps"]
    end_time = Time.now - end_time
    start_time = end_time - start_time
    end_timestamp = end_time.to_i
    start_timestamp = start_time.to_i
    start_id = "#{apikey}-#{start_timestamp.to_s}"
    end_id = apikey + '-' + end_timestamp.to_s

    group_lambda = self.get_group_by_interval(interval)

    query = @r.table('longterm').between(start_id, end_id, :right_bound => 'closed').with_fields(
      ["timestamp",
       "CPU.total.usage",
       "Load",
       "Memory.real.free",
       "Memory.real.used",
       "Memory.real.cache",
       "Memory.real.buffers",
       "Memory.swap.used",
       "Network.Interface.total.rx_Bps",
       "Network.Interface.total.tx_Bps",
       "Disk.total.reads_ps",
       "Disk.total.writes_ps"]
    ).grouped_map_reduce(
      group_lambda,
      lambda {|longterm|
        return {
          "CPU.total.usage" => longterm["CPU.total.usage"],
          "Load" => longterm["Load"],
          "Memory.real.free" => longterm["Memory.real.free"],
          "Memory.real.used" => longterm["Memory.real.used"],
          "Memory.real.cache" => longterm["Memory.real.cache"],
          "Memory.real.buffers" => longterm["Memory.real.buffers"],
          "Memory.swap.used" => longterm["Memory.swap.used"],
          "Network.Interface.total.rx_Bps" => longterm["Network.Interface.total.rx_Bps"],
          "Network.Interface.total.tx_Bps" => longterm["Network.Interface.total.tx_Bps"],
          "Disk.total.reads_ps" => longterm["Disk.total.reads_ps"],
          "Disk.total.writes_ps" => longterm["Disk.total.writes_ps"],
          "count" => 1}
      },
      {
          "CPU.total.usage" => 0,
          "Load" => 0,
          "Memory.real.free" => 0,
          "Memory.real.used" => 0,
          "Memory.real.cache" => 0,
          "Memory.real.buffers" => 0,
          "Memory.swap.used" => 0,
          "Network.Interface.total.rx_Bps" => 0,
          "Network.Interface.total.tx_Bps" => 0,
          "Disk.total.reads_ps" => 0,
          "Disk.total.writes_ps" => 0,
          "count" => 0},
      lambda { |acc, longterm|
        return {
          "CPU.total.usage" => acc["CPU.total.usage"].add(longterm["CPU.total.usage"]),
          "Load" => acc["Load"].add(longterm["Load"]),
          "Memory.real.free" => acc["Memory.real.free"].add(longterm["Memory.real.free"]),
          "Memory.real.used" => acc["Memory.real.used"].add(longterm["Memory.real.used"]),
          "Memory.real.cache" => acc["Memory.real.cache"].add(longterm["Memory.real.cache"]),
          "Memory.real.buffers" => acc["Memory.real.buffers"].add(longterm["Memory.real.buffers"]),
          "Memory.swap.used" => acc["Memory.swap.used"].add(longterm["Memory.swap.used"]),
          "Network.Interface.total.rx_Bps" => acc["Network.Interface.total.rx_Bps"].add(longterm["Network.Interface.total.rx_Bps"]),
          "Network.Interface.total.tx_Bps" => acc["Network.Interface.total.rx_Bps"].add(longterm["Network.Interface.total.rx_Bps"]),
          "Disk.total.reads_ps" => acc["Disk.total.reads_ps"].add(longterm["Disk.total.reads_ps"]),
          "Disk.total.writes_ps" => acc["Disk.total.writes_ps"].add(longterm["Disk.total.writes_ps"]),
          "count" => acc["count"].add(longterm["count"])
        }}
    ).map(
      lambda { |longterm|
        return {
          "timestamp" => longterm["group"],
          "CPU.total.usage" => longterm["reduction"]["CPU.total.usage"].div(longterm["reduction"]["count"]),
          "Load" => longterm["reduction"]["Load"].div(longterm["reduction"]["count"]),
          "Memory.real.free" => longterm["reduction"]["Memory.real.free"].div(longterm["reduction"]["count"]),
          "Memory.real.used" => longterm["reduction"]["Memory.real.used"].div(longterm["reduction"]["count"]),
          "Memory.real.cache" => longterm["reduction"]["Memory.real.cache"].div(longterm["reduction"]["count"]),
          "Memory.real.buffers" => longterm["reduction"]["Memory.real.buffers"].div(longterm["reduction"]["count"]),
          "Memory.swap.used" => longterm["reduction"]["Memory.swap.used"].div(longterm["reduction"]["count"]),
          "Network.Interface.total.rx_Bps" => longterm["reduction"]["Network.Interface.total.rx_Bps"].div(longterm["reduction"]["count"]),
          "Network.Interface.total.tx_Bps" => longterm["reduction"]["Network.Interface.total.tx_Bps"].div(longterm["reduction"]["count"]),
          "Disk.total.reads_ps" => longterm["reduction"]["Disk.total.reads_ps"].div(longterm["reduction"]["count"]),
          "Disk.total.writes_ps" => longterm["reduction"]["Disk.total.writes_ps"].div(longterm["reduction"]["count"])
        }
      }
    )

    query.run
  end

  def self.get_range_by_apikey(apikey, start_time = 30.minutes, end_time = 0.minutes, attributes = nil, interval = nil)
    end_time = Time.now - end_time
    start_time = end_time - start_time
    end_timestamp = end_time.to_i
    start_timestamp = start_time.to_i
    start_id = "#{apikey}-#{start_timestamp.to_s}"
    end_id = apikey + '-' + end_timestamp.to_s
    query = @r.table('longterm').between(start_id, end_id, :right_bound => 'closed')
    query.orderby(@rr.asc(:id)).run
  end

  def self.get_group_by_interval(interval)
    case interval
      #when 4 #30 days
      #  # every 15 minutes
      #  group_lambda = lambda {|longterm|
      #    return @rr.epoch_time(longterm["timestamp"]).date().add(
      #        @rr.epoch_time(longterm["timestamp"]).hours().mul(3600)
      #    ).add(
      #        @rr.epoch_time(longterm["timestamp"]).minutes().sub(@rr.epoch_time(longterm["timestamp"]).minutes().mod(15)).mul(60)
      #    ).to_epoch_time
      #  }
      #when 3 #7 days
      #  #every five minutes
      #  group_lambda = lambda {|longterm|
      #    return @rr.epoch_time(longterm["timestamp"]).date().add(
      #        @rr.epoch_time(longterm["timestamp"]).hours().mul(3600)
      #    ).add(
      #        @rr.epoch_time(longterm["timestamp"]).minutes().sub(@rr.epoch_time(longterm["timestamp"]).minutes().mod(5)).mul(60)
      #    ).to_epoch_time
      #  }

      #when 5 #year or greater
      #  #every hour
      #  group_lambda = lambda {|longterm|
      #    return @rr.epoch_time(longterm["timestamp"]).date().add(
      #        @rr.epoch_time(longterm["timestamp"]).hours().mul(3600)
      #    ).to_epoch_time()
      #  }
      when 5, 4, 3, 2
        #every 30 seconds
        group_lambda = lambda {|longterm|
          return @rr.epoch_time(longterm["timestamp"]).date().add(
              @rr.epoch_time(longterm["timestamp"]).hours().mul(3600)
          ).add(
              @rr.epoch_time(longterm["timestamp"]).minutes().mul(60)
          ).add(
              @rr.epoch_time(longterm["timestamp"]).seconds().sub(@rr.epoch_time(longterm["timestamp"]).seconds().mod(30))
          ).to_epoch_time
        }
      else
        group_lambda = lambda {|longterm|
          return longterm["timestamp"]
        }
    end
    return group_lambda
  end

  def self.get_previous_entry_by_id(id)
    @r.table('longterm').between(nil, id).orderby(@rr.desc(:id)).limit(1).run
  end

  def self.get_highest_network_usage(longterm_object)
    @r.table('longterm').get_all(longterm_object['apikey'], :index => 'apikey').map {|record| record['Network.Interface.total.Bps']}.reduce {|left, right| @rr.branch(left > right, left, right)}.run
  end

  def self.get_highest_network_usage_in_range(longterm_object, range = 24.hours)
    end_time = Time.at longterm_object['timestamp']
    start_time = end_time - range
    start_id = longterm_object['apikey'] + '-' + start_time.to_i.to_s
    end_id = longterm_object['apikey'] + '-' + end_time.to_i.to_s
    @r.table('longterm').between(start_id, end_id, :right_bound => 'closed').map {|record| record['Network.Interface.total.Bps']}.reduce {|left, right| @rr.branch(left > right, left, right)}.run
  end

  def self.calculate_cpu_usage(longterm_object, last_object = nil)

    if last_object.nil?
      last_object = Longterm.get_last_entry_by_apikey(longterm_object['apikey'], 1).first
    end

    if !last_object.nil?
      available_time = Longterm.available_cpu_time last_object['timestamp'], longterm_object['timestamp']

      second_cpu_times = longterm_object.select {|key, value| key.include?('CPU.cpu')}.values
      first_cpu_times = last_object.select {|key, value| key.include?('CPU.cpu')}.values

      cpu_cores = first_cpu_times.size / 3

      first_utilized_time = Longterm.sum_utilized_cpu_time *first_cpu_times
      second_utilized_time = Longterm.sum_utilized_cpu_time *second_cpu_times

      total_utilized_time = Longterm.utilized_cpu_time first_utilized_time, second_utilized_time

      cpu_usage = Longterm.cpu_utilization_percent(available_time, total_utilized_time, cpu_cores)

      return cpu_usage
    end

    nil

  end

  def self.calculate_disk_rate(longterm_object, previous_longterm_object, key)
    time_diff = longterm_object['timestamp'].to_i - previous_longterm_object['timestamp'].to_i
    current_value = longterm_object[key]
    previous_value = previous_longterm_object[key]
    (current_value - previous_value)/time_diff
  end

  def self.calculate_disk_read_rate(longterm_object, previous_longterm_object = nil)
    if previous_longterm_object.nil?
      previous_longterm_object = Longterm.get_last_entry_by_apikey(longterm_object['apikey'], 1).first
    end
    current_reads = longterm_object.select {|key, value| key =~ /Disk\..*\.reads/}.values.reduce(:+)
    previous_reads = previous_longterm_object.select {|key, value| key =~ /Disk\..*\.reads/}.values.reduce(:+)
    if !current_reads.nil? && !previous_reads.nil?
      read_rate = ((current_reads - previous_reads).to_f.round(2).quo((longterm_object['timestamp'] - previous_longterm_object['timestamp']).to_f().round(2))).round(2)
      return (read_rate < 0) ? 0.00 : read_rate
    else
      return 0.0
    end
  end

  def self.calculate_disk_write_rate(longterm_object, previous_longterm_object = nil)
    if previous_longterm_object.nil?
      previous_longterm_object = Longterm.get_last_entry_by_apikey(longterm_object['apikey'], 1).first
    end
    current_writes = longterm_object.select {|key, value| key =~ /Disk\..*\.writes/}.values.reduce(:+)
    previous_writes = previous_longterm_object.select {|key, value| key =~ /Disk\..*\.writes/}.values.reduce(:+)
    if !current_writes.nil? && !previous_writes.nil?
      write_rate = ((current_writes - previous_writes).to_f.round(2).quo((longterm_object['timestamp'] - previous_longterm_object['timestamp']).to_f().round(2))).round(2)
      return (write_rate < 0) ? 0.00 : write_rate
    else
      return 0.0
    end
  end

  def self.calculate_memory_usage(longterm_object)
    total_memory = longterm_object['Memory.real.used'] + longterm_object['Memory.real.free']
    memory_used_by_processes = longterm_object['Memory.real.used'] - longterm_object['Memory.real.buffers'] - longterm_object['Memory.real.cache']
    ((memory_used_by_processes.to_f/total_memory.to_f) * 100.0).round(2)
  end

  def self.calculate_network_rate(longterm_object, previous_longterm_object, key)
    time_diff = longterm_object['max_timestamp'].to_i - previous_longterm_object['max_timestamp'].to_i
    current_value = longterm_object[key]
    previous_value = previous_longterm_object[key]

    if !current_value.nil? && !previous_value.nil?
      return (current_value - previous_value).to_f/time_diff.to_f
    end
    0
  end

  def self.calculate_network_usage(longterm_object, last_object = nil)
    if last_object.nil?
      last_object = Longterm.get_last_entry_by_apikey(longterm_object['apikey'], 1).first
    end
    if !last_object.nil?
      time_diff = longterm_object['timestamp'].to_i - last_object['timestamp'].to_i
      current_rx_bytes = longterm_object.select {|key, value| key.include?('.rx_bytes')}.values.reduce(:+)
      last_rx_bytes = last_object.select {|key, value| key.include?('.rx_bytes')}.values.reduce(:+)
      current_tx_bytes = longterm_object.select {|key, value| key.include?('.tx_bytes')}.values.reduce(:+)
      last_tx_bytes = last_object.select {|key, value| key.include?('.tx_bytes')}.values.reduce(:+)

      rx_bytes_second = (current_rx_bytes - last_rx_bytes)/time_diff
      tx_bytes_second = (current_tx_bytes - last_tx_bytes)/time_diff
      total_bytes_second = rx_bytes_second + tx_bytes_second
      return total_bytes_second, rx_bytes_second, tx_bytes_second
    end

    [nil, nil, nil]
  end

  def self.calculate_swap_usage(longterm_object)
    total_swap = longterm_object['Memory.swap.free'] + longterm_object['Memory.swap.used']
    ((longterm_object['Memory.swap.used'].to_f/total_swap.to_f) * 100.0).round(2)
  end

  def self.calculate_max_load(longterm_object)
    # count CPUs and use as maximum optimal load
    longterm_object.select {|key, value| key[/CPU\.cpu[\d]\.user/]}.length
  end

  

end