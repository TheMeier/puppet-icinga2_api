node default {

  icinga2api_host {'testhost':
    ensure     => 'present',
    #zone       => 'localhost.localdomain',
    zone       => 'aaa',
    templates  => [ 'generic-host'],
    address    => '2.8.8.7',
    address6   => 'ae80::fcd4:233:b2ce:a3fc',
    vars       => {
                    os => {
                    name    => $facts['os']['name'],
                    version => $facts['os']['release']['full'],
                    },
                  test => 'testvar',
                }

  }
}
