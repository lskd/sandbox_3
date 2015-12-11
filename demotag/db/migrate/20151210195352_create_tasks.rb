class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :owner
      t.string :date
      t.string :price
      t.text :detail
      t.text :location

      t.timestamps null: false
    end
  end
end
