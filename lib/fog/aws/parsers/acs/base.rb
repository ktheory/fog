module Fog
  module Parsers
    module AWS
      module ACS

        require 'fog/aws/parsers/acs/base'

        # Base parser for ResponseMetadata, RequestId
        class Base < Fog::Parsers::Base

          def reset
            super
            @response = { 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            else
              super
            end
          end

        end

      end
    end
  end
end


