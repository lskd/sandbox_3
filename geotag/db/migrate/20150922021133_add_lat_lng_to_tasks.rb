class AddLatLngToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :lat, :string
    add_column :tasks, :lng, :string
  end
end
