class AddFieldUserIdToPoints < ActiveRecord::Migration
  def change
    add_column :points, :user_id, :integer
  end
end
