class AddPatientToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :patient, :string
  end
end
