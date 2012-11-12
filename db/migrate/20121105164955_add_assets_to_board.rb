class AddAssetsToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :file_size_limit, :float
    add_column :boards, :max_reports_per_IP, :integer
    add_column :boards, :save_IPs, :boolean
  end
end
