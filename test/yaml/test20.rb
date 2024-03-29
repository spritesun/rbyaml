require 'date'

module YAMLTestCase20
  INPUT = <<-EDN
canonical: 2001-12-15T02:59:43.1Z
iso8601: 2001-12-14t21:59:43.10-05:00
spaced: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
EDN
  EXPECTED = {"canonical"=>Time.utc(2001,12,15,02,59,43,100000), "date"=>Date.new(2002,12,14), "spaced"=>(Time.utc(2001,12,14,21,59,43,100000)-(-5*3600)), "iso8601"=>(Time.utc(2001,12,14,21,59,43,100000)-(-5*3600))}
end
