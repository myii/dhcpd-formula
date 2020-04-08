# Default values
config_filename = '/etc/dhcp/dhcpd.conf'
rootgroup = 'root'
# Overide by platform
case platform[:family]
when 'debian'
  service_config_filename = '/etc/default/isc-dhcp-server'
  service_config_file_contents = <<~SERVICE_CONFIG_FILE.chomp
    # SaltStack-generated demon configuration file for ISC dhcpd

    # Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
    #DHCPD_CONF=/etc/dhcp/dhcpd.conf

    # Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
    #DHCPD_PID=/var/run/dhcpd.pid

    # Additional options to start dhcpd with.
    #       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
    #OPTIONS=""

    # On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
    #       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
    INTERFACES="em1 em2"
  SERVICE_CONFIG_FILE
when 'redhat', 'fedora'
  service_config_filename = '/etc/systemd/system/dhcpd.service.d/override.conf'
  service_config_file_contents = <<~SERVICE_CONFIG_FILE.chomp
    [Service]
    ExecStart=
    ExecStart=/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid em1 em2
  SERVICE_CONFIG_FILE
when 'suse'
  config_filename = '/etc/dhcpd.conf'
when 'freebsd'
  config_filename = '/usr/local/etc/dhcpd.conf'
  rootgroup = 'wheel'
  service_config_filename = '/etc/rc.conf.d/dhcpd'
  service_config_file_contents = <<~SERVICE_CONFIG_FILE.chomp
    # SaltStack-generated demon configuration file for ISC dhcpd

    dhcpd_ifaces="em1 em2"
  SERVICE_CONFIG_FILE
when 'linux'
  case platform[:name]
  when 'arch'
    config_filename = '/etc/dhcpd.conf'
  end
end

control 'DHCPD configuration' do
  title 'should be generated properly'

  describe file(config_filename) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into rootgroup }
    its('mode') { should cmp '0644' }
    its('content') do
      should include <<~CONFIG_FILE.chomp
        # dhcpd.conf
        #
        # SaltStack-generated configuration file for ISC dhcpd
        #

        # Customized dhcp options

        # option definitions common to all supported networks...

        #use-host-decl-names off;

        # Use this to enble / disable dynamic dns updates globally.
        #ddns-update-style none;
        #update-static-leases off;

        # If this DHCP server is the official DHCP server for the local
        # network, the authoritative directive should be uncommented.
        #authoritative;

        # Use this to send dhcp log messages to a different log file (you also
        # have to hack syslog.conf to complete the redirection).
      CONFIG_FILE
    end
  end
end

control 'DHCPD service configuration' do
  title 'should be generated properly'

  only_if(
    'the service configuration file is only available on the Debian, RedHat, ' \
    'Fedora & FreeBSD platform families'
  ) do
    ['debian', 'redhat', 'fedora', 'freebsd'].include?(platform[:family])
  end

  describe file(service_config_filename) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into rootgroup }
    its('mode') { should cmp '0644' }
    its('content') { should include service_config_file_contents }
  end
end
