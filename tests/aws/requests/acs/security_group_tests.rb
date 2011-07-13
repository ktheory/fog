Shindo.tests('AWS::ACS | security group requests', ['aws', 'acs']) do

  @security_group_name = 'fog-test'
  @security_group_description = 'Fog Test Group'
  tests('success') do
    pending if Fog.mocking?

    tests('#create_cache_security_group').formats(AWS::ACS::Formats::CREATE_SECURITY_GROUP) do
      body = AWS[:acs].create_cache_security_group(@security_group_name, @security_group_description).body
      returns(@security_group_name)        { body['CacheSecurityGroup']['CacheSecurityGroupName'] }
      returns(@security_group_description) { body['CacheSecurityGroup']['CacheSecurityGroupDescription'] }
      body
    end

    tests('#delete_cache_security_group').formats(AWS::ACS::Formats::BASIC) do
      body = AWS[:acs].delete_cache_security_group(@security_group_name).body
    end
  end

  tests('failure') do
    # TODO:
    # Create a duplicate security group
    # List a missing security group
    # Delete a missing security group
  end
end
