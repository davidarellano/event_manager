require 'csv'
require 'sunlight'
require 'erb'

Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phonenumbers(number)
  number = number.scan(/\d+/).join
  if number.length > 10
    if number[0] == 1
      number[1..-1]
    else
    number = ""
    end
  elsif number.length < 10
    number = ""
  end
  return number
  end

def legislators_for_zipcode(zipcode)
  Sunlight::Legislator.all_in_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def hourtarget(string)
    #date = DateTime.strf(string)
  date = Date._strptime(string, "%m/%d/%y %H:%M")
  date[:hour]
end

def counthours(hour)
  times = Hash.new
  times << hour => hour
  times.to_a.sort
  times
end
puts "EventManager initialized."

contents = CSV.open '../event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "../form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phonenumbers(row[:homephone])
  date = row[:regdate]
  legislators = legislators_for_zipcode(zipcode)

  #form_letter = erb_template.result(binding)

  #save_thank_you_letters(id,form_letter)
end

