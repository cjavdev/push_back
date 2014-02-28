class AddGoalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_goal, :integer
  end
end
