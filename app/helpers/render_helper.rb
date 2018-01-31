module RenderHelper
  def render_bad_request(errors)
    render status: :bad_request,
      json: { errors: errors }.to_json
  end
end
