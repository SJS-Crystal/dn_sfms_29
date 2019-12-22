class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :avatar
      t.string :full_name
      t.boolean :gender
      t.string :phone
      t.integer :role, default: 2
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, :uid, unique: true
  end
end
