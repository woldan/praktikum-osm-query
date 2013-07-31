require './osmdump.rb'

# Read command line arguments:
require 'optparse'
require 'ostruct'
$options = OpenStruct.new
$options[:file] = nil
$options[:lat_min] = 48.10
$options[:lat_max] = 48.11
$options[:lon_min] = 11.44
$options[:lon_max] = 11.48

OptionParser.new do |opts|
  opts.on("-f", "--file FILE", "Read XML data from file instead of a HTTP request") do |filename|
    $options[:file] = filename
  end
end.parse!

if $options.file
  $dump = OsmDump.new(File.open($options.file).read)
else
  require 'net/http'
  box_string = "#{$options[:lon_min]},#{$options[:lat_min]},#{$options[:lon_max]},#{$options[:lat_max]}"
  answer = Net::HTTP::get("api.openstreetmaps.org",
                          "/api/0.6/map?bbox=#{box_string}")
  $dump = OsmDump.new(answer)
end

def flip_lat(coordinate)
  $options[:lat_max].to_f - coordinate.to_f + $options[:lat_min].to_f
end

# Process XML dump:
require 'nokogiri'
graphics = Nokogiri::XML::Builder.new do |doc|
  box_string = "#{$options[:lon_min]},#{$options[:lat_min]},#{$options[:lon_max] - $options[:lon_min]},#{$options[:lat_max] - $options[:lat_min]}"
  doc.svg xmlns:"http://www.w3.org/2000/svg", viewBox:"#{box_string}" do

    $dump.ways.each do |way|
      way_tag = way.at_xpath("./tag[@k='name']")
      way_name = way_tag['v'] if way_tag
      puts "Way '#{way_name}'"

      line_coordinates = ""
      way.xpath("./nd").each do |node_ref|
        way_node = $dump.node(node_ref["ref"])
        line_coordinates += " #{way_node["lon"]},#{flip_lat(way_node["lat"])}"
      end
      
      doc.polyline fill:"none", stroke:"black", :'stroke-width'=>"0.00001", points:line_coordinates
    end

    $dump.bus_stops.each do |stop|
      bus_stop_name = stop.at_xpath("./tag[@k='name']")['v']
      bus_stop_latitude = stop['lat']
      bus_stop_longitude = stop['lon']
      puts "Bushaltestelle '#{bus_stop_name}' @[#{bus_stop_longitude},#{bus_stop_latitude}]"

      doc.circle fill:"#f00", r:0.0001, cx:bus_stop_longitude, cy:flip_lat(bus_stop_latitude)
    end

  end
end

File.open("out.svg", "w").write(graphics.to_xml)
