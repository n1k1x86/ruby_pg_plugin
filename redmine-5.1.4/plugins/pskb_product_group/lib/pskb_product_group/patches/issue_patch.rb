module PskbProductGroup
  module Patches
    module IssuePatch
      def self.included(base)
        base.class_eval do
          has_many :pskb_product_groups_issues, foreign_key: :issue_id, dependent: :destroy
        end
      end
    end
  end
end