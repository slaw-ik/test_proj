class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :latitude
      t.float :longitude
      t.string :description
      t.string :address
      t.boolean :gmaps

      t.timestamps
    end
  end
end
