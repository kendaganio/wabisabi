class AddListIdToTasks < ActiveRecord::Migration[5.1]
  def change
    add_reference :tasks, :list, index: true
  end
end
