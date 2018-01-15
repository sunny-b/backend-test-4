class RemoveDirectionFromCalls < ActiveRecord::Migration[5.1]
  def change
    remove_column :calls, :direction
  end
end
