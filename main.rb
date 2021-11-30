# main.rb uses the other .rb files to prompt the user and assemble output. Main program loop.

# Created 2/10/2020 by Tze Hei Tam
# Edited 2/10/2020 by Nick Harvey - Ruby style cleanup; add get_buildings method
# Edited 2/11/2020 by Emily Niehaus - move and develop prompts to this file from prompt1.rb
# Edited 2/11/2020 by Alli Hornyak
# Edited 2/12/2020 by Nina Yao
# Edited 2/12/2020 by Alli Hornyak - moved methods around to clean up main
# Edited 2/12/2020 by Emily Niehaus - added looping / control flow
# Edited 2/13/2020 by Alli Hornyak - fix looping for buildings and quitting
# Edited 2/15/2020 by Nick Harvey - integrated tty-prompt
# Edited 2/15/2020 by Tze Hei Tam - Modified body of main guard, fixed imports
# Edited 2/16/2020 by Nina Yao - changed code to use filters
# Edited 2/16/2020 by Alli Hornyak - added conditional filtering for features
# Edited 2/16/2020 by Nina Yao - added feature to filter what features are displayed for each room
# Edited 2/17/2020 by Alli Hornyak - fix displaying when rooms is not found
# Edited 2/17/2020 by Tze Hei Tam - Changed where file name is asked for
# Edited 2/18/2020 by Nick Harvey - made scraping process more descriptive
# Edited 2/18/2020 by Emily Niehaus - added progress messages
# Edited 2/19/2020 by Emily Niehaus - readiblity/cleanup, change call to get_line
# Edited 2/20/2020 by Alli Hornyak - code cleanup based on Proj 2 comments
# Edited 2/20/2020 by Nick Harvey - changed .rb requires to require_relative
# Edited 2/20/2020 by Tze Hei Tam - Made some changes to spacing for readability
# Edited 2/20/2020 by Emily Niehaus - minor updates from project 2 feedback

require_relative "./Scraper"
require_relative "./Room"
require_relative "./OutputHelper"
require "tty-prompt"

# Created 2/10/2020 by Tze Hei Tam
# Edited 2/10/2020 by Nick Harvey - Ruby style cleanup; add get_buildings method
# Edited 2/11/2020 by Emily Niehaus - move and develop prompts to this file from prompt1.rb
# Edited 2/12/2020 by Alli Hornyak - moved methods around to clean up main
# Edited 2/12/2020 by Emily Niehaus - added looping / control flow
# Edited 2/13/2020 by Alli Hornyak - fix looping for buildings and quitting
# Edited 2/15/2020 by Nick Harvey - integrated tty-prompt
# Edited 2/15/2020 by Tze Hei Tam - Modified to accommadate changes to output_helpers and scraper
# Edited 2/16/2020 by Alli Hornyak - added conditional filtering for features
# Edited 2/16/2020 by Nina Yao - added feature to filter what features are displayed for each room
# Edited 2/17/2020 by Alli Hornyak - fix displaying when rooms is not found
# Edited 2/17/2020 by Tze Hei Tam - Changed where file name is asked for
# Edited 2/18/2020 by Nick Harvey - made scraping process more descriptive
# Edited 2/18/2020 by Emily Niehaus - added progress messages
# Edited 2/19/2020 by Emily Niehaus - readiblity/cleanup, change call to get_line
# Edited 2/20/2020 by Alli Hornyak - code cleanup based on Proj 2 comments
# Edited 2/20/2020 by Emily Niehaus - change .length == 0 to .empty?

MAX_NUM_BLDGS = 3

if __FILE__ == $PROGRAM_NAME
	# Initialize TTY prompt
	prompt = TTY::Prompt.new

	# Do initial scraping
	puts '[ Scraping data . . . ]'
	scraper = Scraper.new
	buildings = scraper.get_buildings
	puts '[ Scraping complete ]'

	output_helper = OutputHelper.new

	# Output welcome message
	puts 'Welcome to the Ohio State Classroom Finder!'
	
	is_finished = false
	until is_finished
		# Prompt user for a command
		choice = prompt.enum_select('Please select a command.') do |menu|
			menu.choice 'Output list of buildings.', 1
			menu.choice "Choose a building (up to #{MAX_NUM_BLDGS}).", 2
			menu.choice 'Quit.', 3
		end

		# Handle user's command
		# Output list of buildings
		if choice == 1
			puts output_helper.get_line
			puts buildings
			puts output_helper.get_line
		# Choose a building
		elsif choice == 2
			# Prompt for building name
			user_buildings = output_helper.get_building_names prompt, buildings, MAX_NUM_BLDGS

			all_features = Array.new
			selected_rooms = scraper.get_selected_rooms user_buildings
			puts '[ Scraping feature data . . . ]'
			puts '[ There is a sleep between each feature set scrape ]'
			selected_rooms.each do |room_name, url|
				room = Room.new(room_name)
				room_features = Array.new
				room_features = scraper.get_room_features url, room
				room_features.each {|feat| all_features << feat}	
			end
			puts '[ Scraping complete . . . ]'
			all_features.uniq!

			# Ask user for an output file
			regex = /[\w\-. ]+\.txt/
			error_msg = 'Please enter a valid file name (must include .txt).'
			file_name = output_helper.get_input_match 'Where would you like the information saved (.txt file)?', regex, error_msg

			choice_feat1 = prompt.enum_select('Do you want to choose which features get displayed for each room?') do |menu|
				menu.choice 'Yes', 1
				menu.choice 'No', 2
			end

			filters = []
			if choice_feat1 == 1
				i = 0
				choice_feat1 = prompt.multi_select('Please select a feature(s):') do |menu|
					all_features.each do |feature|
					menu.choice feature, i
					i+=1
					end
				end
				choice_feat1.each {|selected| filters << all_features[selected]}
			else 
				filters = all_features
			end

			# Create and output file
			out = File.open file_name, 'w'
		
			choice_cond = prompt.enum_select('Please select a command.') do |menu|
				menu.choice 'Output all Rooms', 1
				menu.choice 'Advanced Search', 2
			end	

			if choice_cond == 2 
			# Conditional Filtering	
				roomFound = false
				i = 0
				choice_feat2 = prompt.multi_select('Please select a feature(s).') do |menu|
					all_features.each do |feature|
						menu.choice feature, i
						i+=1
					end
				end
				selected_features = Array.new
				choice_feat2.each {|selected| selected_features << all_features[selected]}
				puts '[ Writing to file . . . ]'
				selected_rooms.each do |room_name, url|
					room = Room.new(room_name)
					all_room_feats = scraper.get_room_features url, room
						if (selected_features - all_room_feats).empty?
							output_helper.write_to_output out, room, filters
							roomFound = true
						end
				end
				if !roomFound
					puts 'There are no rooms with your selected features.'
				end
					
			else
				puts '[ Writing to file . . . ]'
				selected_rooms.each do |room_name, url|
				room = Room.new(room_name)
				scraper.get_room_features url, room	
				output_helper.write_to_output out, room, filters
				end
			end
			puts '[ Written to file successfully ]'
			puts output_helper.get_line
			out.close
		# Quit
		elsif choice == 3
			is_finished = true
		end
	end
end
