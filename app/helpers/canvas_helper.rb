module CanvasHelper
  def get_s3_path(url)
    root = "https://#{S3_BUCKET.name}.s3.#{ENV['AWS_REGION']}.amazonaws.com/"
    m = url.match("^" + root + "(.*)$")
    if m
      m[1]
    end
  end

  def check_stroke(jstroke)
    if not jstroke['layer_uuid']
      return "layer_uuid missing"
    end
  end
end
