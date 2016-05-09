class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :body

      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :articles, :user_id
  end
end
