class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string   :title
      t.string   :image
      t.integer  :bytes
      t.integer  :user_id
      
      t.timestamps
    end
  end
end
