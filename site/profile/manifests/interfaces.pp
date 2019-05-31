class profile::interfaces {
  panos_arbitrary_commands {
    'devices/entry/network/profiles/interface-management-profile':
      ensure  => 'present',
      xml     => '<interface-management-profile>
                  <entry name="ping">
                    <ping>yes</ping>
                  </entry>
                </interface-management-profile>';
  }

  panos_arbitrary_commands {
    'devices/entry/network/interface/ethernet':
      ensure  => 'present',
      xml     => '<ethernet>
                    <entry name="ethernet1/1">
                      <layer3>
                        <ipv6>
                          <neighbor-discovery>
                            <router-advertisement>
                              <enable>no</enable>
                            </router-advertisement>
                          </neighbor-discovery>
                        </ipv6>
                        <ndp-proxy>
                          <enabled>no</enabled>
                        </ndp-proxy>
                        <lldp>
                          <enable>no</enable>
                        </lldp>
                        <interface-management-profile>ping</interface-management-profile>
                        <dhcp-client/>
                      </layer3>
                    </entry>
                    <entry name="ethernet1/2">
                      <layer3>
                        <ipv6>
                          <neighbor-discovery>
                            <router-advertisement>
                              <enable>no</enable>
                            </router-advertisement>
                          </neighbor-discovery>
                        </ipv6>
                        <ndp-proxy>
                          <enabled>no</enabled>
                        </ndp-proxy>
                        <ip>
                          <entry name="192.168.0.1/24"/>
                        </ip>
                        <lldp>
                          <enable>no</enable>
                        </lldp>
                        <interface-management-profile>ping</interface-management-profile>
                      </layer3>
                    </entry>
                  </ethernet>',
      require => Panos_arbitrary_commands['devices/entry/network/profiles/interface-management-profile']
  }

  panos_virtual_router { 'default': 
    ensure => 'present',
    interfaces => ['ethernet1/1', 'ethernet1/2'],
    ad_static => '10',
    ad_static_ipv6 => '10',
    ad_ospf_int => '30',
    ad_ospf_ext => '110',
    ad_ospfv3_int => '30',
    ad_ospfv3_ext => '110',
    ad_ibgp => '200',
    ad_ebgp => '20',
    ad_rip => '120',
    require => Panos_arbitrary_commands['devices/entry/network/interface/ethernet']
  }
}