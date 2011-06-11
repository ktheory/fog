Shindo.tests('AWS::RDS | security group requests', ['aws', 'rds']) do
  tests('success') do

    @name, @desc = 'fog-test', 'Fog Test'
    tests("#create_db_security_group").formats(AWS::RDS::Formats::CREATE_DB_SECURITY_GROUP) do
      body = AWS[:rds].create_db_security_group(@name, @desc).body
      returns(@name) { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['DBSecurityGroupName'] }
      returns(@desc) { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['DBSecurityGroupDescription'] }
      body
    end

    tests("#describe_db_security_group()").formats(AWS::RDS::Formats::DESCRIBE_DB_SECURITY_GROUP) do
      AWS[:rds].describe_db_security_groups.body
    end

    tests("#describe_db_security_group(#{@name})").formats(AWS::RDS::Formats::DESCRIBE_DB_SECURITY_GROUP) do
      body = AWS[:rds].describe_db_security_groups(@name).body
      returns(@name) { body['DescribeDBSecurityGroupsResult']['DBSecurityGroups'].first['DBSecurityGroupName'] }
      body
    end

    @cidr = '1.2.3.4/32'
    tests("authorize_db_security_group_ingress with CIDRIP").formats(AWS::RDS::Formats::AUTHORIZE_DB_SECURITY_GROUP_INGRESS) do
      body = AWS[:rds].authorize_db_security_group_ingress(@name, 'CIDRIP' => @cidr).body
      ip_ranges = body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['IPRanges']
      returns(@cidr) { ip_ranges.first['CIDRIP'] }
      returns('authorizing') { ip_ranges.first['Status'] }
      body
    end

    @ec2_security_group = AWS[:compute].security_groups.get('default')
    tests("authorize_db_security_group_ingress with EC2 Security Group").formats(AWS::RDS::Formats::AUTHORIZE_DB_SECURITY_GROUP_INGRESS) do
      body = AWS[:rds].authorize_db_security_group_ingress(@name, 'EC2SecurityGroupName' => @ec2_security_group.name, 'EC2SecurityGroupOwnerId' => @ec2_security_group.owner_id).body
      ec2_groups = body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups']
      returns(@ec2_security_group.name) { ec2_groups.first['EC2SecurityGroupName'] }
      returns(@ec2_security_group.owner_id) { ec2_groups.first['EC2SecurityGroupOwnerId'] }
      returns('authorizing') { ec2_groups.first['Status'] }
      body
    end

    # Wait for all ingresses to be authorized
    Fog.wait_for do
       group = AWS[:rds].describe_db_security_groups(@name).body['DescribeDBSecurityGroupsResult']['DBSecurityGroups'].first
      (group['IPRanges'] + group['EC2SecurityGroups']).all? {|ingress| ingress['Status'] == 'authorized'}
    end


    tests("revoke_db_security_group_ingress with CIDRIP").formats(AWS::RDS::Formats::REVOKE_DB_SECURITY_GROUP_INGRESS) do
      body = AWS[:rds].revoke_db_security_group_ingress(@name, 'CIDRIP' => @cidr).body
      ip_ranges = body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['IPRanges']
      returns(@cidr) { ip_ranges.first['CIDRIP'] }
      returns('revoking') { ip_ranges.first['Status'] }
      body
    end

    tests("revoke_db_security_group_ingress with EC2 Security Group").formats(AWS::RDS::Formats::REVOKE_DB_SECURITY_GROUP_INGRESS) do
      body = AWS[:rds].revoke_db_security_group_ingress(@name, 'EC2SecurityGroupName' => @ec2_security_group.name, 'EC2SecurityGroupOwnerId' => @ec2_security_group.owner_id).body
      ec2_groups = body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups']
      returns(@ec2_security_group.name) { ec2_groups.first['EC2SecurityGroupName'] }
      returns(@ec2_security_group.owner_id) { ec2_groups.first['EC2SecurityGroupOwnerId'] }
      returns('revoking') { ec2_groups.first['Status'] }
      body
    end



    tests("#delete_db_security_group(#{@name})").formats(AWS::RDS::Formats::BASIC) do
      AWS[:rds].delete_db_security_group(@name).body
    end


  end
end
