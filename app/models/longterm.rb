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
end