require 'amp4e_ldap_tool/cli'
require 'amp4e_ldap_tool'

describe Amp4eLdapTool::CLI do
  let(:subject)   { Amp4eLdapTool::CLI.new }
  let(:dn)      { ["CN=computer1,CN=Computers,DC=Host", 
                   "CN=computer2,CN=Computers,DC=Host"] }
  let(:name)    { ["computer1.Computers.Host",
                   "computer2.Computers.Host"] }
  let(:entries) { [Net::LDAP::Entry.new(dn[0]),
                   Net::LDAP::Entry.new(dn[1])]}
  let(:groups)  { ["Host", "Computers.Host"] }
  let(:ldap)    { double("LdapScrape", entries: entries, groups: groups) }
  
  context '#make_changes' do
    let(:output)  { get_output {subject.make_changes} }
    let(:amp)     { double("CiscoAMP") }

    before(:each) do
      entries[0]["dnshostname"] = name[0]
      entries[1]["dnshostname"] = name[1]
      allow(Amp4eLdapTool::CiscoAMP).to receive(:new).and_return(amp)
      allow(Amp4eLdapTool::LDAPScrape).to receive(:new).and_return(ldap)
    end

    xit 'displays a list of changes with no flags' do
      expect(output).to eq("something")
    end

    xit 'asks to execute changes with -a' do

    end
  end

  context 'amp' do
    let(:amp)       { double("CiscoAMP") }
    let(:output)    { get_output {subject.amp} }
    let(:computers) { [double("AMP::Computer", name: "computer_1"), 
                       double("AMP::Computer", name: "computer_2")] }
    let(:groups)    { [double("AMP::Group", name: "group_1"), 
                       double("AMP::Group", name: "group_2")] }
    let(:policies)  { [double("AMP::Policy", name: "policy_1"), 
                       double("AMP::Policy", name: "policy_2")] }

    before(:each) do
      allow(Amp4eLdapTool::CiscoAMP).to receive(:new).and_return(amp)
    end
    
    it 'gets a list of computers with -c' do
      allow(amp).to receive(:get).with(:computers).and_return(computers)
      subject.options = {computers: true}
      expect(output).to eq("#{computers[0].name}\n#{computers[1].name}\n")
    end

    it 'gets a list of groups with -g' do
      allow(amp).to receive(:get).with(:groups).and_return(groups)
      subject.options = {groups: true}
      expect(output).to eq("#{groups[0].name}\n#{groups[1].name}\n")
    end

    it 'gets a list of policies with -p' do
      allow(amp).to receive(:get).with(:policies).and_return(policies) 
      subject.options = {policies: true}
      expect(output).to eq("#{policies[0].name}\n#{policies[1].name}\n")
    end

    it 'gets a list of computers and groups with -cg' do
      allow(amp).to receive(:get).with(:groups).and_return(groups)
      allow(amp).to receive(:get).with(:computers).and_return(computers)
      subject.options = {groups: true, computers: true}
      results = "#{groups[0].name}\n#{groups[1].name}\n"
      results << "#{computers[0].name}\n#{computers[1].name}\n"
      expect(output).to eq(results)
    end
  end

  context 'ldap' do
    let(:output)  { get_output {subject.ldap} }
    
    before(:each) do
      entries[0]["dnshostname"] = name[0]
      entries[1]["dnshostname"] = name[1]
      allow(Amp4eLdapTool::LDAPScrape).to receive(:new).and_return(ldap)
    end

    it 'gets a list of distinguished names with -d' do
      subject.options = {distinguished: true}
      expect(output).to eq(entries.inject {|x,y| "#{x.dn}\n#{y.dn}"} + "\n")
    end

    it 'gets a list of computer names with -c' do
      subject.options = {computers: true}
      expect(entries[0]).to receive(:dnshostname).and_return(name[0])
      expect(entries[1]).to receive(:dnshostname).and_return(name[1])
      expect(output).to eq(name.inject {|x,y| "#{x}\n#{y}"+ "\n"})
    end

    it 'gets a list of group names with -g' do
      subject.options = {groups: true}
      allow(ldap).to receive(:groups).with(dn[0]).and_return(groups)
      allow(ldap).to receive(:groups).with(dn[1]).and_return([])
      expect(output).to eq(groups.inject {|x,y| "#{x}\n#{y}"} + "\n" )
    end
  end
end
