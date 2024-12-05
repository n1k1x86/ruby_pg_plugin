class AddDepartmentsToIssue < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :department_id, :integer
    add_foreign_key :issues, :departments
  end
end
