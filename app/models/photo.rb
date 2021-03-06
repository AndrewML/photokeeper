class Photo < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  validates_presence_of :title, :image
  belongs_to :user
end
