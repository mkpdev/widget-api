module UsersHelper
	def dob(date_of_birth)
		DateTime.strptime(date_of_birth.to_s, '%s').strftime('%Y-%m-%d')
	end
end
