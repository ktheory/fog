module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_security_groups'

        # Describe all or specified db snapshots
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_DescribeDBSecurityGroups.html
        # ==== Parameters
        # * DBSecurityGroupName <~String> - The name of the DB Security Group to return details for.
        # * Marker               <~String> - An optional marker provided in the previous DescribeDBInstances request
        # * MaxRecords           <~Integer> - Max number of records to return (between 20 and 100)
        # Only one of DBInstanceIdentifier or DBSnapshotIdentifier can be specified
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_security_groups(opts={})
          opts = {'DBSecurityGroupName' => opts} if opts.is_a?(String)

          request({
            'Action'  => 'DescribeDBSecurityGroups',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBSecurityGroups.new
          }.merge(opts))
        end

      end

      class Mock

        def describe_db_security_group(opts={})
          security_group = opts.is_a?(String) ? opts : opts['DBSecurityGroupName']

          security_group_results = self.data[:db_security_groups].values
          if security_group
            if data[:db_security_groups].key?(security_group)
              security_group_results = [data[:db_security_groups][security_group]]
            else
              raise Fog::Service::NotFound.new("DBSecurityGroup #{security_group} not found")
            end
          end

          response = Excon::Response.new

          response.status = 200
          response.body = {
            'requestId' => Fog::AWS::Mock.request_id,
            'DescribeDBSecurityGroupsResult' => {"DBSecurityGroups" => security_group_info}
          }
          response

        end

      end
    end
  end
end

