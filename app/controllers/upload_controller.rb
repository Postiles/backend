# require 'RMagick'

class UploadController < ApplicationController

  def upload_image
    user = auth(params) or return

    image = params[:image]

=begin
    img = Magick::Image::read(image).first
    logger.info img.rows
=end

    path = params[:upload_path]

    filename = params[:user_id] + '_' + Time.now.to_i.to_s
    
    path = "#{Rails.root}/public/uploads/#{path}/#{filename}"

    File.open(path, 'wb') do |f|
      f.write(image.read)
    end

    render_ok :filename => filename
  end
end
