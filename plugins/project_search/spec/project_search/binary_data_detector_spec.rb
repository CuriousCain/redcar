
require "spec_helper"

describe ProjectSearch::BinaryDataDetector do
  
  it "should detect plain text files" do
    txt1 = File.read(project_search_fixture_dir + "/foo.txt")
    txt2 = File.read(project_search_fixture_dir + "/qux.rb")
    
    ProjectSearch::BinaryDataDetector.textual?(txt1).should be true
    ProjectSearch::BinaryDataDetector.textual?(txt2).should be true
    
    ProjectSearch::BinaryDataDetector.binary?(txt1).should be false
    ProjectSearch::BinaryDataDetector.binary?(txt2).should be false
  end
  
  it "should detect binary files" do
    bin = File.read(project_search_fixture_dir + "/binary_file.bin")
    
    ProjectSearch::BinaryDataDetector.textual?(bin).should be false
    
    ProjectSearch::BinaryDataDetector.binary?(bin).should be true
  end
end