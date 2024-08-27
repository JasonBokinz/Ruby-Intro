#!/usr/bin/env ruby
# args = ARGF.argv
args = ARGV
modes = []
modeCounter = 0
combInvalid = false

# store the filename and pattern from ARGV
fileName = ARGV[0]
pattern = ARGV[-1]

# pattern is missing
if (ARGV.length < 2)
  puts "Missing required arguments"
  exit(1)
end
# checks each agrv argument for the modes entered
ARGV.each do |arg|
  case arg
  when "-w", "-p", "-v", "-c", "-m"
    modes << arg[1]  # Extract the mode without the "-"
    modeCounter += 1
  end
end
# mode -p is added to the array because it is the default mode
if (modeCounter == 0)
  modes << "p"
  modeCounter+=1
end
singleCorM = false
# check for invalid combinations based on previous if statements based on documentation
if (modeCounter > 2)
    combInvalid = true
else
  # -c with a mode it can't be used in conjunction with
  if (modes.include?("c"))
    if (modes.none? { |i| ["w", "p", "v"].include?(i) })
      combInvalid = true
      if (modeCounter == 1)
        singleCorM = true
      end
    end
  # -m with a mode it can't be used in conjunction with
  elsif (modes.include?("m"))
    if (modes.none? { |i| ["w", "p"].include?(i) })
      combInvalid = true
      if (modeCounter == 1)
        singleCorM = true
      end
    end
  elsif (modeCounter > 1)
    combInvalid = true
  end
end

# if an invalid -{letter} is used
isInvalid = ARGV.find { |arg| arg.start_with?("-") && !%w(-w -p -v -c -m).include?(arg) && arg.length == 2 }
if (isInvalid || singleCorM)
    puts "Invalid option"
    exit(1)
end
# if an invalid combination is used
if (combInvalid)
  puts "Invalid combination of options"
  exit(1)
end

# Read the file
begin
  file_contents = File.read(fileName)
rescue StandardError
  puts "Missing required argument"
  exit(1)
end

# Using pattern and mode use format appropriately

if (modes.include?("w"))
  # Search for a word in the file and store the whole line
  matched_lines = file_contents.scan(/.*\b#{pattern}\b.*/)
elsif (modes.include?("p"))
  # Search using a regular expression and store the whole line
  matched_lines = file_contents.scan(/.*#{pattern}.*/)
elsif (modes.include?("v"))
  # Invert matching using a regular expression
  matched_lines = file_contents.scan(/^(?!.*#{pattern}).*$/)
end

# if one of the modes is -c or -m

if (modes.include?("c"))
  # Count matching lines
  puts matched_lines.size
elsif (modes.include?("m"))
  # Show matched part of lines
  if (modes.include?("w"))
    # Search for a word in the file
    matched_lines = file_contents.scan(/\b#{pattern}\b/)
  elsif (modes.include?("p"))
    # Search using a regular expression
    matched_lines = file_contents.scan(/#{pattern}/)
  end
end

# Display lines if -c was not one of the modes
if (modes.none?("c") && matched_lines)
  matched_lines.each { |line| puts line }
end