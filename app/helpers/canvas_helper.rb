module CanvasHelper
  def get_s3_path(url)
    root = "https://#{S3_BUCKET.name}.s3.#{ENV['AWS_REGION']}.amazonaws.com/"
    m = url.match("^" + root + "(.*)$")
    if m
      m[1]
    end
  end

  def split_base64(data)
    matches = /data:.*\/(.*);base64,(.*)/.match(data)
    return {
      'filetype' => matches[1],
      'data' => matches[2]
    }
  end

  def upload_image(data, path:, filename: nil)
    encoded = split_base64 data
    decoded = Base64.decode64(encoded['data']) 
    filetype = encoded['filetype']
    file = Tempfile.new(['', ".#{filetype}"], Rails.root.join('tmp').to_s, :encoding => 'ascii-8bit')
    url = ""
    begin
      file.write(decoded)
      if file.size > 1.megabyte
        puts "[ERROR] CanvasChannel.save_image - file is too large for upload: #{file.size/1024} KB"
      else
        puts "CanvasChannel.save_image - uploading image of size: #{file.size/1024} KB"
        path = path[-1] == '/' ? path : path + '/'
        if !filename
          filename = File.basename(file.path)
        end
        obj = S3_BUCKET.object(path + filename)
        obj.upload_file(file.path)
        puts "CanvasChannel.save_image - uploaded to #{obj.public_url}"
        url = obj.public_url
      end
    ensure
      file.close
      file.unlink
    end

    return url
  end
end
