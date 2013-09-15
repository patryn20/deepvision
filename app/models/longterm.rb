class Longterm

  @r = LovelyRethink.db
  @rr = RethinkDB::RQL.new

  def self.save_from_json_post(json_string)
    object = JSON::parse(json_string)

    provided_api_key = object['apikey']

    longterm_object = object['payload'][0]['LONGTERM']
    longterm_object['id'] = provided_api_key + "-" + Time.now.to_i.to_s
    longterm_object['apikey'] = provided_api_key

    @r.table('longterm').insert(longterm_object).run(durability: "soft")
  end

  def self.get_all_most_recent
    hosts = @r.table('hosts').run
    hosts.map { |host| {:hosts => host, :longterm => Longterm.get_last_entry_by_apikey(host["id"]).first} }
  end

  def self.get_last_entry_by_apikey(apikey)
    @r.table('longterm').get_all(apikey, :index => "apikey").orderby(@rr.desc(:id)).limit(1).run
  end
end