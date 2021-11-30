# Created 2/17/2020 by Tze Hei Tam

require_relative '../OutputHelper.rb'

describe OutputHelper do
	let!(:output_helper) { OutputHelper.new }

	# Test cases for check_building_input
	valid_buildings = ['Arps Hall', 'Pomerene Hall', '209 West Eighteenth Avenue', 'Ramseyer Hall']

	context "when given a valid list of buildings" do
		max_bldgs = 3
		
		context 'names separated with ,\s' do
			it "returns array with one building when given one building" do
				input = 'Arps Hall'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall'] 
			end
			
			it "returns array with one building when given two buildings" do
				input = 'Arps Hall, 209 West Eighteenth Avenue'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', '209 West Eighteenth Avenue'] 
			end
			
			it "returns array with one building when given three buildings" do
				input = 'Arps Hall, Ramseyer Hall, Pomerene Hall'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', 'Ramseyer Hall', 'Pomerene Hall'] 
			end
		end
		
		context 'names separated with ,' do
			it "returns array with one building when given one building" do
				input = 'Arps Hall'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall'] 
			end

			it "returns array with one building when given two buildings" do
				input = 'Arps Hall,209 West Eighteenth Avenue'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', '209 West Eighteenth Avenue'] 
			end
			
			it "returns array with one building when given three buildings" do
				input = 'Arps Hall,Ramseyer Hall,Pomerene Hall'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', 'Ramseyer Hall', 'Pomerene Hall'] 
			end
		end
		
		context 'names separated with , with variable number of spaces' do
			it "returns array with one building when given one building" do
				input = 'Arps Hall     '

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall'] 
			end
			
			it "returns array with one building when given two buildings" do
				input = 'Arps Hall   ,        209 West Eighteenth Avenue'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', '209 West Eighteenth Avenue'] 
			end
			
			it "returns array with one building when given three buildings" do
				input = 'Arps Hall,     Ramseyer Hall     ,          Pomerene Hall'

				matches = output_helper.check_building_input input, max_bldgs, valid_buildings
				expect(matches).to match_array ['Arps Hall', 'Ramseyer Hall', 'Pomerene Hall'] 
			end
		end
	end

	context "when given too many buildings" do
		it "returns -1 when given buildings with limit of 0" do
			max_bldgs = 0

			input = 'Arps Hall'

			matches = output_helper.check_building_input input, max_bldgs, valid_buildings
			expect(matches).to eq -1
		end

		it "returns -1 when given more buildings than limit" do 
			max_bldgs = 3

			input = 'Arps Hall, Ramseyer Hall, Pomerene Hall, 209 West Eighteenth Avenue'

			matches = output_helper.check_building_input input, max_bldgs, valid_buildings
			expect(matches).to eq -1
		end
	end

	context "when given invalid building names" do 
		max_bldgs = 3
		it "returns -1 when given names not in building list" do 
			input = 'Arps Hall, Ramseyer Hall, Dreese Labs'

			matches = output_helper.check_building_input input, max_bldgs, valid_buildings
			expect(matches).to eq -1
		end

		it "returns -1 when given trailing characters" do
			input = 'Arps Hall,,' 

			matches = output_helper.check_building_input input, max_bldgs, valid_buildings
			expect(matches).to eq -1
		end
	end
end

