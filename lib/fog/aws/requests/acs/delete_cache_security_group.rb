module Fog
  module AWS
    class ACS
      class Real

        require 'fog/aws/parsers/acs/base'

        # deletes a cache security group
        #
        # === Parameters
        # * name <~String> - The name for the Cache Security Group
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def delete_cache_security_group(name)
          request({
            'Action' => 'DeleteCacheSecurityGroup',
            'CacheSecurityGroupName' => name,
            :parser => Fog::Parsers::AWS::ACS::Base.new
          })
        end
      end

      class Mock
        def delete_cache_security_group(name)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
