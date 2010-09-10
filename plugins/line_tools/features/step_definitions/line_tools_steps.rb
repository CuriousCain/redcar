When /^I kill the line$/ do
  Redcar::LineTools::KillLineCommand.new.run
end

When /^I trim the line$/ do
  Redcar::LineTools::TrimLineAfterCursorCommand.new.run
end

When /^I lower the text$/ do
  Redcar::LineTools::LowerTextCommand.new.run
end

When /^I raise the text$/ do
  Redcar::LineTools::RaiseTextCommand.new.run
end

When /^I replace the line$/ do
  Redcar::LineTools::ReplaceLineCommand.new.run
end


When /^I clear the line$/ do
  Redcar::LineTools::ClearLineCommand.new.run
end
