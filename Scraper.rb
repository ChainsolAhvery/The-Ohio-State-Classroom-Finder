# Scraper.rb contains mechanize and nokogiri functions used to scrape and manipulate information.

# Created 2/10/2020 by Tze Hei Tam
# Edited 2/10/2020 by Nick Harvey - implemented get_buildings; Ruby style cleanup
# Edited 2/12/2020 by Nina Yao - updated code to use Room class
# Edited 2/13/2020 by Nina Yao - modified get_room_features for cleaner output
# Edited 2/13/2020 by Alli Hornyak - modified get_selected_rooms looping
# Edited 2/14/2020 by Nick Harvey - added Mechanize alias; repair room array;
#									attempt to fix server 500 error
# Edited 2/15/2020 by Tze Hei Tam - Moved creation of room to room url hash to constructor
# Edited 2/16/2020 by Emily Niehaus - moodified get_room_features to include room type
# Edited 2/18/2020 by Nick Harvey - added sleep to feature scraping to avoid server 500 error
# Edited 2/19/2020 by Emily Niehaus - adjust sleep times
# Edited 2/20/2020 by Alli Hornyak - code cleanup based on Proj 2
# Edited 2/20/2020 by Nick Harvey - code style cleanup
# Edited 2/20/2020 by Tze Hei Tam - cleanup of Scraper class

require 'mechanize'
require 'nokogiri'
require_relative "./Room"

# Created 2/10/2020 by Tze Hei Tam
# Edited 2/15/2020 by Tze Hei Tam - Changed constructor, removed get_room
# Edited 2/20/2020 by Tze Hei Tam - Added method header for initialize, shortened get_page_contents
class Scraper

	URL_HEAD = 'https://odee.osu.edu'

	# Created 2/10/2020 by Tze Hei Tam
	# Edited 2/14/2020 by Nick Harvey - added mechanize alias
	# Edited 2/15/2020 by Tze Hei Tam - added @all_rooms
=begin
	Initializes Scraper. Initializes mechanize agent and creates hash with rooms as keys and 
	the room url as the value.

	@updates @agent, @all_rooms
=end
	def initialize
		@agent = Mechanize.new
		@agent.user_agent_alias = 'Mac Mozilla'
	
		# Build hash of all rooms and their urls
		parser = self.get_page_contents 'https://odee.osu.edu/classroom-browse'
		
		room_list = parser.css 'div.views-field.views-field-title a'
		
		@all_rooms = Hash.new
		room_list.each { |room|	@all_rooms[room.text.intern] = URL_HEAD + room['href'] }
	end

	# Created 2/10/2020 by Tze Hei Tam
	# Edited 2/20/2020 by Tze Hei Tam - Shortened method body
=begin
	Returns Nokogiri::HTML object with contents of site at url

	@requires - valid url (string)

	@returns - Nokogiri::HTML object with contents of url
=end
	def get_page_contents url
		page_contents = @agent.get(url).body
		parser = Nokogiri::HTML page_contents
	end

	# Created 2/11/2020 by Emily Niehaus
	# Edited 2/13/2020 by Alli Hornyak - fixed each loop for the hash and if statement for the key
	# Edited 2/14/2020 by Nick Harvey - repaired room array; added sleep for 500 error
	# Edited 2/15/2020 by Tze Hei Tam - modified for @all_rooms
	# Edited 2/26/2020 by Emily Niehaus - bug fix (returning empty hash)
=begin
	Returns hash with room name (format: BuildingName Room#) as key and url as value

	@ requires - list of valid buildings
	
	@ returns - hash {symbol, string}
=end
	def get_selected_rooms selected_buildings
		puts '[ Scraping room data . . . ]'
		puts '[ There is a sleep between each room scrape ]'
		room_hash = Hash.new
		@all_rooms.each do |room_id, url|
			# All room names contain their building names followed by a room #
			# Must convert room_id symbol to string
			selected_buildings.each do |bldg_id|
				if room_id.to_s.include?(bldg_id)
					room_hash[room_id] = url
					sleep 1 # Used to prevent server 500 error
				end
			end
		end
		puts '[ Scraping complete ]'
		room_hash
	end

	# Created 2/10/2020 by Tze Hei Tam
	# Edited 2/10/2020 by Nick Harvey - implemented the method
	# Edited 2/11/2020 by Emily Niehaus - removed extra white space from names
	# Function to scrape building names
=begin
	Returns array with all building names as strings

	@requires - valid url to room list

	@returns - Array [string] with names
=end
	def get_buildings
		parser = self.get_page_contents 'https://odee.osu.edu/classroom-browse'
		buildings = parser.css('h3')
		names = Array.new
		buildings.each { |name| names << name.text.strip }
		names
	end

	# Functions for scraping individual room pages
	
	# Created 2/10/2020 by Tze Hei Tam
	# Edited 2/12/2020 by Nina Yao - updated code to use Room class
	# Edited 2/13/2020 by Nina Yao - added code to remove empty space in room.attributes
	# Edited 2/16/2020 by Emily Niehaus - added room type
	# Edited 2/18/2020 by Nick Harvey - added 4-second sleep between feature set scrapes
=begin
	Returns array with all room features as strings

	@requires - valid url [String] to room

	@returns - Array [string]  with features
=end
	def get_room_features room_url, room
		parser = self.get_page_contents room_url

		# Get room type
		item = parser.css 'div.group-space-details.field-group-div div.field__item.even'
		room.type = item.text

		item_list = parser.css 'div.group-physical-attributes.field-group-div div.field__item.even'
		item_list += parser.css 'div.group-physical-attributes.field-group-div div.field__item.odd'
		item_list += parser.css 'div.group-amenity-features.field-group-div div.field__item.even a'
		item_list += parser.css 'div.group-amenity-features.field-group-div div.field__item.odd a'
		sleep 1 # To prevent repetetive pings to the server / 500 error

		room.comp_type = item_list[0].text
		item_list.shift
		room.seats = item_list[0].text
		item_list.shift
		item_list.each { |feature| room.attributes << feature.text}
		room.attributes.reject! {|feature| feature.empty?}
	end
end

