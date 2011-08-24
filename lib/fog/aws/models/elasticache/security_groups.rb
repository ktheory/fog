require 'fog/core/collection'
require 'fog/aws/models/elasticache/security_group'

module Fog
  module AWS
    class ElastiCache

      class SecurityGroups < Fog::Collection
        model Fog::AWS::ElastiCache::SecurityGroup

        def all
          data = connection.describe_cache_security_groups.body['CacheSecurityGroups']
          load(data)
        end

        def get(identity)
          data = connection.describe_cache_security_groups('CacheSecurityGroupName' => identity).body['CacheSecurityGroups'].first
          new(data)
        rescue Fog::AWS::ElastiCache::NotFound
          nil
        end
      end

    end
  end
end

