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

      Longterm.save_from_json_post(json_data)
      Instant.save_from_json_post(json_data)

      instant_object = 

      response = {:sleep => 10}
      response
    end
  end
end