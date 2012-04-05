maintainer       "Webfilings.com"
maintainer_email "ryan.heimbuch@webfilings.com"
license          "All rights reserved"
description      "Installs/Configures xbrlserver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "zeromq"
depends "mongrel2"
depends "python"
depends "apt"

recipe "xbrlserver::default", "Configures an Xbrl Server"
