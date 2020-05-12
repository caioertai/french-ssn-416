# Require Date and YAML libraries for use later
require "date"
require "yaml"

# Read the text on the french departments yml file
yaml_string = File.open("data/french_departments.yml").read

# Parse the yml text into a hash of departments
DEPARMENTS = YAML.load(yaml_string)

# Our SSN regex built on Rubular at the start of the challenge
SSN_PATTERN = /^(?<gender>[12])\s?(?<yob>\d{2})\s?(?<mob>0[1-9]|1[0-2])\s?(?<dob>\d{2})\s?\d{3}\s?\d{3}\s?(?<key>\d{2})/

# A small dictionary to convert string 1 and 2 into their gender names
GENDERS = { "1" => "man", "2" => "woman" }

# A method for validating SSN keys
# (follows the rule set by the livecode description)
def valid_key?(ssn)
  key = ssn[-2..-1].to_i
  ssn_no_key = ssn[0..-3].delete(" ").to_i

  (97 - ssn_no_key) % 97 == key
end

# Extract info from SSN number
def french_ssn_info(ssn)
  # Use String#match with our REGEX to get a MatchData object with the keys
  # we set as capture groups in our REGEX.
  data = ssn.match(SSN_PATTERN)

  # Check wether the SSN didn't match the pattern or has an invalid key
  if data.nil? || !valid_key?(ssn)
    "The number is invalid"
  else
    # The next 3 lines are converting the numbers in the SSN into text
    gender_name = GENDERS[data[:gender]] # "1" => "man"
    month_name = Date::MONTHNAMES[data[:mob].to_i] # "12" => "December"
    department_name = DEPARMENTS[data[:dob]] # "76" => "Seine-Maritime"

    # Return the full data interpolated
    "a #{gender_name}, born in #{month_name}, 19#{data[:yob]} in #{department_name}."
  end
end
