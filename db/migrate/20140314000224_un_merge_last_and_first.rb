class UnMergeLastAndFirst < ActiveRecord::Migration
  def change
    rename_column :users, :name, :f_name
    add_column :users, :l_name, :string
  end
end
