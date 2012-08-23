class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :src
      t.integer :post_id
      t.integer :src_height
      t.integer :src_width
      
      t.integer :thumbnail_height
      t.integer :thumbnail_width

      t.timestamps
    end

    add_column :posts, :image_id, :integer
  end
end
