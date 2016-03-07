# What: Turn a multi-column CSV file into the nested "flare.json" structure required by D3 for a collapsible tree diagram like this: https://bl.ocks.org/mbostock/4339083
# I couldn't find a generic way to do this so I wrote this script. Help & comments welcome!
# How: Nested hashes group the data. Then a recurive function builds a new hash with the correct format for the JSON.
# Caveats: Currently supports up to 4 levels/columns of depth
# TODO: make it generically support n-levels
# Who: Peter Kappus (http://kapp.us)
# CSV Format:
#   Create a CSV called "data.csv" with any headers you like. It might look like this:
# group_name, team_name, person_name
# Group1,team1,person1
# Group1,team1,person2
# Group1,team2,person3

# Usage:
#   $ ruby csv_to_flare.rb > data.json

require 'CSV'
require 'json'

# formatted hash for final output. Rename the top level node as desired.
my_json = {:name=>"GDS"}

# manually initialise new array
my_json['children'] = []

# a simpler nested hash to throw data in for now
root = {}

CSV.foreach("data.csv",headers:true) do |row|
  # skip empty lines
  next if row[0].to_s.empty?
  #only show operations for now...
  #next if row[0].to_s != "Operations"

  # TODO: DRY this up and generically support n-levels

  # initialise empty hashes as needed
  root[row[0]] = {} unless root[row[0]]
  root[row[0]][row[1]] = {} unless root[row[0]][row[1]]

  # last level is just an array. Initialise it.
  root[row[0]][row[1]][row[2]] = [] unless root[row[0]][row[1]][row[2]]

  # populate the last level array
  root[row[0]][row[1]][row[2]] << row[3]
end

# recursion to the rescue!
def get_kids(obj)
  # if it's a hash, then there are more layers
  if(obj.class.to_s == "Hash")
    # drill down and keep getting kids
    obj.keys.map{|name| {:name=>name, :children=> get_kids(obj[name])}}
  else
    # Otherwise, we're at the edge. Just build an array of "name" hashes.
    obj.map{|name| {:name=>name}}
  end
end

# recursively build a new hash in the desired format
my_json['children'] = get_kids(root)

# now output the json...
# concise
puts my_json.to_json

# pretty (e.g. for debugging)
#puts JSON.pretty_generate(my_json)
