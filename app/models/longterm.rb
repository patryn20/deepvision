class Longterm

  @r = LovelyRethink.db

  def self.save_from_json_post(json_string)
    object = JSON::parse(json_string)

    provided_api_key = object['apikey']

    longterm_object = object['payload'][0]['LONGTERM']
    longterm_object['id'] = provided_api_key + "-" + Time.now.to_i.to_s
    longterm_object['apikey'] = provided_api_key

    @r.table('longterm').insert(longterm_object).run(durability: "soft")
  end
end