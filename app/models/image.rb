class Image < ActiveRecord::Base
  attr_accessible(:src, 
                  :post_id, 
                  :src_height, 
                  :src_width, 
                  :thumbnail_height, 
                  :thumbnail_width) 
  belongs_to :post
  
  # Carrierwave magic
  mount_uploader :src, ImageUploader
end
