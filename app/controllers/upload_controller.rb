require 'rubygems'
require 'mini_magick'

class UploadController < ApplicationController

  def upload_image
    user = auth(params) or return

    image = params[:image].read

    filename = params[:user_id] + '_' + Time.now.to_i.to_s + 
      File.extname(params[:image].original_filename)

    path = "#{Rails.root}/public/uploads/#{params[:upload_path]}/#{filename}"

    mini_magick_img = MiniMagick::Image.read(image)
    mini_magick_img.resize '440x440'
    mini_magick_img.write(path)

    render_ok :filename => filename
  end
end
