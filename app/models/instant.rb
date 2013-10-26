class Instant

  @r = LovelyRethink.db

  def self.save_from_json_post(object)
    provided_api_key = object['apikey']

    instant_object = object['payload'][0]['INSTANT'].dup
    instant_object['timestamp'] = object['payload'][0]['timestamp']
    instant_object['id'] = provided_api_key

    @r.table('instant').insert(instant_object).run(durability: 'soft', upsert: true)
  end

  def self.get_by_id(id)
    @r.table('instant').get(id).run
  end
end