class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :user
      t.references :task
      t.string :title_movie
      t.string :detail_movie
      t.timestamps null: false
    end
  end
end
