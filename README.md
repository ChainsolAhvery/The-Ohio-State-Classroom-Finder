# Project 3
### Web Scraping

## General info
Command-line tool to browse the classrooms listed at https://odee.osu.edu/classroom-browse and allows the user to filter both the rooms outputted and the features outputted.

## Features
* Animated and colored prompts (tty)
* Writing output to a user specified file
* Ability to search multiple buildings
* Ability to display only select room features
* Ability to filter results by room features

## Technologies
Project is created with:
* Ruby version 2.6.3p62

## How to Run
To clone and run this application, you'll need Git installed on your computer. From the command line:

```
# Clone this repository
$ git clone git@github.com:cse3901-osu-2020sp/Project-3-THE-Internet-Explorers.git

# Go into the repository
$ cd Project-3-THE-Internet-Explorers

# Install the following gem
$ gem install tty-prompt
$ gem install rspec
$ gem install nokogiri
$ gem install mechanize

# Run the application
$ ruby main.rb

# Files generated during runtime will be saved in Project-3-THE-Internet-Explorers

# Or run the test cases
$ rspec spec/OutputHelper_spec.rb 

# Integration test plan can be found by opening
$ testing/integrationTestPlan.txt
```

## How to Use
After running the application, you will be prompted with 3 options:
* Option 1 will output a list of all buildings on Ohio State University’s campus.
  - Then the user will be prompted with the same 3 options again.

* Option 2 will let the user pick up to 3 buildings to gather information on.
  - The user will need to type in the building names separated by commas.
  - Then the user will be asked for a text file to save all of the information to. The user will need to enter a string followed by the “.txt” suffix. 
  - Next the user will be asked if they want to filter what features get displayed for each room. For example, if they only wanted Windows, Chalkboards, and DVD to be printed to the file for each room in Arps Hall, only list these 3 features will be listed in the text file. If a room does not have a particular feature that you have chosen, then it will simply be omitted from the file. If selected Yes, the user will be able to choose features from a list. They can maneuver between the choices with your keyboard arrows and hit the spacebar if they want to select an option. Once the user is done selecting their options, they should hit enter to continue. 
  - Next they will have the option to perform an advanced search. If Yes is selected, a similar option selecting interface as before will be presented. Advanced search lets the user filter rooms by features. For example, if the user chose chalkboards from the list, only rooms with chalkboards will be printed to the file from their selected list of buildings. 
  - Once the data has been successfully written to the file that the user specified, the program will prompt them with the 3 initial options from the beginning of the program.

* Option 3 is to exit the program. 

## Run-time Warnings
If there are delays during scraping, that is normal!  There are built in delays to help prevent encountering a 500 error.  While we were able to prevent 500 errors using delays, they still tend to pop up from time to time.  The assumption is that the server is getting pinged too many times and is throwing a 500 error back.  If you receive a 500 error at any point, restart the program, and try:
* Searching a different building
* Searching fewer buildings at a time

## Roles
* Overall Project Manager:  Nina Yao
* Coding Manager:  Emily Niehaus
* Testing Manager:  Nick Harvey
* Documentation:  Tze Hei Tam

## Contributions
* Alli Hornyak
  - Added second filter (Advanced Search) feature to main.rb
    - Allowed user to filter what rooms were outputted based on selected filters
    - Incorporated tty with Advanced Search feature
    - Edited looping found in main.rb
  - Created/ Edited OutputHelper
    - Created prompts
    - Edited write_to_output
    - Created get_input_match
  - Edited Scraper class
    - Edited get_selected_rooms
  - Created some method contracts
  - Completed System tests for filtering functionality

* Emily Niehaus
  - Edited main.rb
    - Created looping/ control flow of prompts
  - Edited OutputHelper.rb
    - Created/edited write_to_output to print data to an output file
    - Transformed old method into get_input_match to easily verify that input matches a given regex
    - Created put_line to create uniform line breaks
  - Edited Scraper.rb
    - Bug fixing get_selected_rooms
    - Edited get_buildings to remove extra white space
    - Edited get_room_features to scrape room type
  - Edited Room.rb
    - Added @type instance variable
  - Created outline of systems tests
    - Completed system tests for writing to output file

* Nick Harvey
  - Edited the Scraper class
    - Wrote get_buildings scraper method
  - Edited the main.rb file
    - Incorporated tty-prompt into the existing prompt method and streamlined the input loop
  - Edited the OutputHelpers class
    - Wrote first iteration of get_building_names
    - Removed redundant/unused functions after tty-prompt integrated
    - Repaired get_selected_rooms to return proper array 
  - Alleviate server 500 error instances with strategic sleep
  - Mechanize profiling

* Nina Yao
  - Created Room class in Room.rb file
    - Object to store information about each room
    - Edited get_room_features method from Scraper.rb file to use Room class
  - Added first filter feature to main.rb file
    - Allowed user to be able to filter which attributes of a room get printed to the file
    - Edited write_to_output method from OutputHelper.rb file to use filter feature
    - Incorporated TTY prompt to use for filter feature
  - Edited method contracts and documentation
  - Completed system tests for filter method
  
* Tze Hei Tam
  - Created Scraper class
    - Wrote initialize, get_page_contents, get_selected_rooms, get_room_features and the corresponding method contract
  - Edited OutputHelper class
    - Wrote get_building_names, check_building_input  and the corresponding method contract
      - Added functionality to allow multiple buildings to be input in same line
  - Created OutputHelper_spec.rb
    - Added test cases for check_building_input
  - Completed System tests for listing and building select functionality
