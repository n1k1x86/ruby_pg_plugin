module PskbProductGroup
  module Patches
    module MailerPatch
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def send_msg_to_pg_owners(user, subject, message)
          mail(
            to: user.mail,
            subject: subject,
            body: message,
            content_type: "text/plain"
          )
        end
      end
    end
  end
end
