class AddKindsToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :kinds, :integer
  end
end
