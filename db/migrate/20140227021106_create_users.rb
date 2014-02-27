class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :f_name
      t.string :l_name
      t.string :email

      t.timestamps
    end

    add_index :users, :email, :unique => true
  end
end
