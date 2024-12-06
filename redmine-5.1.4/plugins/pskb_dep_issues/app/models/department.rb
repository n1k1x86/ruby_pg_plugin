class Department < ActiveRecord::Base
  self.table_name = 'departments'

  has_many :issues
  attribute :name, :string
end