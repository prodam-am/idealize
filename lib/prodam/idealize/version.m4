# encoding: utf-8

module Prodam
  module Idealize
    VERSION   = '_VERSION'
    RELEASE   = '_RELEASE'
    TIMESTAMP = '2016-01-13 09:19:08 -0400'

    def self.info
      "#{Prodam.constants.first} v#{VERSION} (#{RELEASE})"
    end

    def self.to_h
      { :name      => name,
        :version   => VERSION,
        :semver    => VERSION.to_semver_h,
        :release   => RELEASE,
        :timestamp => TIMESTAMP }
    end
  end
end
