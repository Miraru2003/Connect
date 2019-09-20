class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :user
      t.string :title
      t.datetime :beforestarting
      t.datetime :deadline
      t.datetime :voting
      t.datetime :result
      t.timestamps null: false
    end
  end
end
