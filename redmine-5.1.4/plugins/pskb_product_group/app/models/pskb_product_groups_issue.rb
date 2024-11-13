class PskbProductGroupsIssue < ActiveRecord::Base
  belongs_to :issue 
  belongs_to :pskb_product_groups

  validates :percentage, presence: true
end
