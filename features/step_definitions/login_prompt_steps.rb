Given(/^I have no cached login credentials$/) do
end

Given(/^the config directory is set$/) do
  Rust::ConfigFile.any_instance.stub(:default_directory).and_return('./.rust/')
  puts Rust::ConfigFile.new.filename
end

When /^I close the input stream$/ do
  @interactive.stdin.close
end
