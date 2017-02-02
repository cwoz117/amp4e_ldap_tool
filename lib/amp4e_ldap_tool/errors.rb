module Amp4eLdapTool
  class AMPConfigError < StandardError
    def initialize(msg: "The AMP section of the configuration file is not formatted properly" )
      super
    end
  end

  class LDAPConfigError < StandardError
    def initialize(msg: "The LDAP Section of the configuration file is not formatted properly")
      super
    end
  end
end
