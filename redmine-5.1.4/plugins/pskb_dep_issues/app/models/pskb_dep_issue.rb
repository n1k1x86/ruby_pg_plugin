class PskbDepIssue < ActiveRecord::Base
  belongs_to :users, class_name: "User", foreign_key: "user_id"
  belongs_to :departments, foreign_key: "dep_id"
end

class Department < ActiveRecord::Base
  self.table_name = 'departments'

  attribute :name, :string
end
