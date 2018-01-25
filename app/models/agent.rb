class Agent < ApplicationRecord
	def self.import(file)
	  spreadsheet = Roo::Spreadsheet.open(file.path)
	  header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			agent = Agent.new
			agent.agent_id = row['ID']
			agent.save
		end
	end
end
