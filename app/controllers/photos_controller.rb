require 'digest/sha1'
class PhotosController < ApplicationController

  def index
    @photos = Photo.where(user_id:current_user.id).order("created_at desc").to_a
  end

  def new
    @photo = Photo.new(:title => "My photo \##{1 + (Photo.maximum(:id) || 0)}")
      @unsigned = true
      @preset_name = "sample_" + Digest::SHA1.hexdigest(Cloudinary.config.api_key + Cloudinary.config.api_secret)
      begin
        preset = Cloudinary::Api.upload_preset(@preset_name)
        if !preset["settings"]["return_delete_token"]
          Cloudinary::Api.update_upload_preset(@preset_name, :return_delete_token=>true)
        end
      rescue
        Cloudinary::Api.create_upload_preset(:name => @preset_name, :unsigned => true, :folder => "preset_folder", :return_delete_token=>true)
      end
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user_id = current_user.id
    if !@photo.save
      @error = @photo.errors.full_messages.join('. ')
      return
    end
      @photo.update_attributes(:bytes => @photo.image.metadata['bytes'])
      @upload = @photo.image.metadata
      
      redirect_to action: :index
  end

  protected 
  def photo_params
    params.require(:photo).permit(:title, :bytes, :image, :image_cache)
  end
  
  def slideshow
    
  end
  
 end