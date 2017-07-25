module Etherlite
  module Account
    class Anonymous < Base
      def initialize(_connection)
        super(_connection, nil)
      end
    end
  end
end
