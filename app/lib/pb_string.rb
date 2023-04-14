module PbString
  module Name
    def string1
      "test_string1"
    end
  end

  module Description
    def string2
      "test_string2"
    end

    module Info
      def self.author
        "Tony"
      end
    end
  end
end