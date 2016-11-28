# icinga2api

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with icinga2api](#setup)
    * [What icinga2api affects](#what-icinga2api-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with icinga2api](#beginning-with-icinga2api)
1. [Usage - Configuration options and additional functionality](#usage)

## Description

A provider module to manage Icinga2 configuration objects via the Icinga2 Rest API

The intended usage szenario is to create a host object on a puppet agent node by using the
Icinga2 API locally on the agent i.e. localhost.

TODO: Find a way to configure API-Url and credential information

## Setup

### Setup Requirements 
requires ruby gems json and rest-client, confined by Puppet.feature restclient

### Beginning with icinga2api

## Usage

```
  icinga2api_host {'testhost':
    ensure    => 'present',
    zone      => 'localhost.localdomain',
    templates => [ 'generic-host'],
    address   => '2.8.8.7',
    address6  => 'fe80::fcd4:233:b2ce:a3fc',
    vars      => {
                  os => { 
                    name => $facts['os']['name'],
                    version => $facts['os']['release']['full'],
                    },
                  test => 'testvar',
                 }
                   
  } 
```

