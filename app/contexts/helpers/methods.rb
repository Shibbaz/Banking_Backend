module Contexts
  module Helpers
    class Methods
      def make_negative(num)
        num <= 0 ? num : num * -1
      end
    end
  end
end
