# Include some utility functions we might need

# Return a string date from in_date obj
def nice_date(in_date)
	# Remove everything after T (time bit)
	return in_date.to_s.gsub(/T.+$/,'')
end

# Return a string time from in_date obj
def nice_time(in_date)
	# Remove everything before T (date bit)
	# FIXME: Need a better time function
	return in_date.to_s.gsub(/.+T/,'').gsub(/:\d\d\+.+$/,'')
end
