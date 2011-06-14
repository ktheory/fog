require 'sax-machine'

class IPRange
  include SAXMachine
  element 'cidrIp', :as => :cidr_ip
end

class IPRangeCollection
  include SAXMachine
  elements :item, :as => :items, :class => IPRange
end

class Group
  include SAXMachine
end

class GroupCollection
  include SAXMachine
  elements :item, :as => :groups, :class => Group

end

class SecurityGroupItem
  include SAXMachine
  element 'ipRanges', :class => IPRangeCollection
  element 'groups', :class => GroupCollection
  element 'ipProtocol', :as => :protocol
  element 'fromPort', :as => :from_port
  element 'toPort', :as => :to_port
end

class DescribeSecurityGroupResponse
  include SAXMachine
  element 'requestId', :as => :request_id
  elements 'item', :as => :security_groups, :class => SecurityGroupItem
end
