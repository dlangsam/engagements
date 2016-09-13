class HomeController < ApplicationController
	def index
		if current_user
			@friends = current_user.get_friends
		end
	end
end
