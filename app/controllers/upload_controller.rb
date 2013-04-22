require 'rubygems'
require 'mini_magick'

class UploadController < ApplicationController
  MAX_IMAGE_WIDTH = 440
  MAX_IMAGE_HEIGHT = 440

  def upload_image
    user = auth(params) or return

    image = params[:image].read

    filename = params[:user_id] + '_' + Time.now.to_i.to_s + 
      File.extname(params[:image].original_filename)

    path = "#{Rails.root}/public/uploads/#{params[:upload_path]}/#{filename}"

    mini_magick_img = MiniMagick::Image.read(image)

    width = mini_magick_img[:width]
    height = mini_magick_img[:height]

    if width > MAX_IMAGE_WIDTH or height > MAX_IMAGE_HEIGHT
      width_ratio = width.to_f / MAX_IMAGE_WIDTH
      height_ratio = height.to_f / MAX_IMAGE_HEIGHT

      if width_ratio > height_ratio # wide
        factor = height_ratio
      else # tall
        factor = width_ratio
      end

      mini_magick_img.resize (width / factor).to_s + 'x' + (height / factor).to_s
    end

    mini_magick_img.write(path)

    File.chmod(0644, path)

    render_ok :filename => filename
  end
end
