module Puppet::Parser::Functions
  newfunction(:bdsm, :type => :rvalue) do |args|
    !lookupvar(args[0]).nil? ? output=lookupvar(args[0]) : output=args[1]
    return output
  end
end
