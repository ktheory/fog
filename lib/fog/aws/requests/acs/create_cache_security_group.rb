module Fog
  module AWS
    class ACS
      class Real

        require 'fog/aws/parsers/acs/single_security_group'

        # creates a cache security group
        #
        # === Parameters
        # * name <~String> - The name for the Cache Security Group
        # * description <~String> - The description for the Cache Security Group
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def create_cache_security_group(name, description = name)
          request({
            'Action' => 'CreateCacheSecurityGroup',
            'CacheSecurityGroupName' => name,
            'CacheSecurityGroupDescription' => description,
            :parser => Fog::Parsers::AWS::ACS::SingleSecurityGroup.new
          })
        end
      end

      class Mock
        def create_cache_security_group(name, desciption=name)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
