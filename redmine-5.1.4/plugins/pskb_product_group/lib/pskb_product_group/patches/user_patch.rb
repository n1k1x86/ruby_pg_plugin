module PskbProductGroup
  module Patches
    module UserPatch
      def self.included(base)
        base.class_eval do
          has_many :product_groups, foreign_key: :owner_id, dependent: :destroy
        end
      end
    end
  end
end

unless User.included_modules.include?(PskbProductGroup::Patches::UserPatch)
  User.send(:include, PskbProductGroup::Patches::UserPatch)
end