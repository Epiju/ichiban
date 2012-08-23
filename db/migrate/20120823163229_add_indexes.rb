class AddIndexes < ActiveRecord::Migration
  def change
    add_index :boards, :directory, unique: true
    add_index :operators, :email
    
    add_index :posts, :parent_id
    add_index :posts, :directory
    add_index :posts, :image_id

    add_index :images, :post_id
  end
end
