#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
require 'arbdrone/nav_data.rb'
require 'pcap'

include ARbDrone::NavData
include Pcap

# TODO: Allow configuring a live network capture by specifying an interface
cap = Capture.open_offline ARGV[0]

# Dummy values
setup 0, 0

cap.each do |p|
  if p.udp?
    if p.ip_src.to_s == '192.168.1.1' && p.udp_sport == 5554
      receive_data p.udp_data
    end
    if p.ip_dst.to_s == '192.168.1.1' && p.udp_dport == 5556
      puts p.udp_data.gsub(/\r/, "\n") unless p.udp_data =~ /^AT\*REF=\d+,\d+\r$/
    end
  end
end
