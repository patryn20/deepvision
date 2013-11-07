module Longview
  class API < Grape::API
    version 'v1', using: :path, vendor: 'deepvision'
    format :json

    post :log do
      @r = LovelyRethink.db
      # Longview agent submits with multipart data. Open as tempfile through Gzip reader
      post_file = Zlib::GzipReader.new(params[:data].tempfile)

      json_data = post_file.read

      post_file.close

      decoded_data = JSON::parse(json_data)

      host = Host.get_by_id(decoded_data['apikey'])

      if Host.key_valid_and_active?(decoded_data['apikey'], host)

        Longterm.save_from_json_post(decoded_data)
        Instant.save_from_json_post(decoded_data)

        response = {:sleep => (host.nil? || host["interval"].nil?) ? 10 : host["interval"] }

      else
        response = {:die => "please"}
      end

      response
    end
  end
end