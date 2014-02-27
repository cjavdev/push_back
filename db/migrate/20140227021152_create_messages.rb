class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.integer :author_id
      t.integer :recipient_id
      t.string :message_type

      t.timestamps
    end

    add_index :messages, :author_id
    add_index :messages, :recipient_id
  end
end
