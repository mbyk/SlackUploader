class SlackChannel
	attr_accessor :id, :name

	include ActiveModel::Model

	def initialize(json)
		@id = json['id']
		@name = json['name']
	end

end
