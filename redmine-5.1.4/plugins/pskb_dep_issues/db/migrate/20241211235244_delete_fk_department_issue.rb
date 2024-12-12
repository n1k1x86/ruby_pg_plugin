class DeleteFkDepartmentIssue < ActiveRecord::Migration[6.1]
  def change
    remove_column :issues, :department_id

    add_column :issues, :department_id, :integer, null: true
    add_foreign_key :issues, :pskb_dep_issues, column: :department_id
  end
end
