class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :owner
      t.string :date
      t.string :price
      t.text :descr
      t.string :location

      t.timestamps null: false
    end
  end
end
