require 'rexml/document'
require 'nokogiri'

class OsmDump
  def initialize(data)
    @data = Nokogiri::XML(data)
    @nodes = {}
    @crossings = Hash.new([])
    
    parse_nodes
  end

  def parse_nodes
    @data.xpath("/osm/node").each do |node|
      @nodes[node["id"].to_s] = node
      @crossings[node["id"].to_s].push node["id"]
    end
  end

  def bus_stops
    @data.xpath("/osm/node/tag[@k='highway'][@v='bus_stop']/..")
  end

  def ways
    @data.xpath("/osm/way/tag[@k='highway']/..")
  end

  def node(id)
    @nodes[id.to_s]
  end
end
