class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,  limit: 50,   null: false
      t.string :email, limit: 100,  null: false
      t.string :role,  limit: 20,   null: false

      t.string :encrypted_password, null: false
      t.string :salt, null: false

      t.timestamps null: false
    end
  end
end
