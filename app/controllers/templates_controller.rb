class TemplatesController < ApplicationController
  include FileUploadHelper

  def create
    if not params[:template] or
        not params[:template][:width] or 
        not params[:template][:height] or
        not params[:template][:data]
      return head :bad_request
    end

    user = User.find(params[:id])
    if user
      permitted = params.require(:template).permit(:width, :height, :data)
      url = upload_image(permitted[:data], path: 'templates/')
      if url
        template = Template.new(url: url, user: user, width: permitted[:width], height: permitted[:height])
        if template.save
          head :ok
        else
          head :bad_request
        end
      else
        head :bad_request
      end
    else 
      head :not_found
    end
  end

  def show
  end

  def index
    user = User.find(params[:id])
    default_templates = Template.select('templates.id, templates.url, templates.private, templates.width, templates.height, templates.created_at, templates.updated_at').where(user_id: nil)
    public_templates = Template.select('templates.id, templates.url, users.name as user_name, templates.private, templates.width, templates.height, templates.created_at, templates.updated_at')
      .joins(:user).where('templates.private = ? OR templates.user_id = ?', false, user.id)

    render status: :ok,
      json: { default_templates: default_templates, user_templates: public_templates }
  end


end
