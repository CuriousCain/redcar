
require "spec_helper"

describe ProjectSearch::WordSearch do
  before(:all) do
    test_file = File.expand_path(project_search_fixture_dir + "/jscar.txt")

    File.open(test_file, "w") do |fout|
      fout.write "aa testword bb"
    end
  end

  after(:all) do
    test_file = File.expand_path(project_search_fixture_dir + "/jscar.txt")
    if File.exists? test_file
      FileUtils.rm(test_file)
    end

    FileUtils.rm_rf(project_search_fixture_dir + "/.redcar")
    ProjectSearch.indexes.clear
  end
  
  describe "options of the search" do
    it "should have a query_string method" do
      make_search("testset").query_string.should == "testset"
    end
    
    it "should construct a regex to match the query string" do
      make_search("asdf", false).regex.should == /asdf/i
      make_search("asdf", true).regex.should == /asdf/
    end
    
    it "should respond whether matching case or not" do
      make_search("asdf", nil).match_case?.should == false
      make_search("asdf", 123).match_case?.should == true
    end
  end
  
  def fixture_project
    @fixture_project ||= Redcar::Project.new(project_search_fixture_dir)
  end
  
  def make_search(query, match_case=true, context=0)
    ProjectSearch::WordSearch.new(fixture_project, query, match_case, context)
  end
  
  describe "finding hits" do
    it "should find one occurrence" do
      results = make_search("Foo").results
      results.length.should == 1
      result = results.first
      result.should be_an_instance_of(ProjectSearch::Hit)
      File.expand_path(result.file).should == File.expand_path(project_search_fixture_dir + "/foo.txt")
      result.line_num.should == 0
      result.line("<b>", "</b>").should == "<b>Foo</b> Bar Baz"
    end
    
    it "should ignore binary files" do
      results = make_search("HoHo").results
      results.length.should == 0
    end
    
    it "should find every occurrence" do
      results = make_search("xxx").results
      expect(results.length).to eq(7)
      expect(results.map {|r| r.line_num}).to eq([16, 17, 19, 22, 26, 31, 37])
    end
    
    it "should ignore case if asked" do
      results = make_search("Foo", false).results
      results.length.should == 2
      results.map {|r| r.line_num}.should == [0, 1]
      results[0].file.should =~ /foo.txt$/
      results[1].file.should =~ /foo.txt$/
    end
  end
    
  describe "hits" do
    it "should enwrap every occurrence" do
      results = make_search("Corge").results
      results.length.should == 1
      result = results.first
      result.should be_an_instance_of(ProjectSearch::Hit)
      File.expand_path(result.file).should == File.expand_path(project_search_fixture_dir + "/foo.txt")
      result.line_num.should == 2
      result.line("<b>", "</b>").should == "<b>Corge</b> <b>Corge</b> <b>Corge</b>"
    end
  end
  
  describe "pre context" do
    it "should return pre context" do
      results = make_search("333", true, 2).results
      results.length.should == 1
      result = results.first
      result.pre_context.should == ["111", "222"]
    end
    
    it "should return no pre context for first line" do
      results = make_search("Foo", true, 2).results
      results.length.should == 1
      result = results.first
      result.pre_context.should == []
    end
    
    it "should return short pre context for second line" do
      results = make_search("foo", true, 2).results
      results.length.should == 1
      result = results.first
      result.pre_context.should == ["Foo Bar Baz"]
    end
    
    it "should return pre context for hits right after one another" do
      results = make_search("xxx", true, 2).results
      results[0].pre_context.should == [",,,", "aaa"]
      results[1].pre_context.should == ["aaa", "bbb xxx"]
    end
  end
  
  describe "post context" do
    it "should return post context" do
      results = make_search("333", true, 2).results
      results.length.should == 1
      result = results.first
      result.post_context.should == ["444", "555"]
    end
    
    it "should return post context for hits right after one another" do
      results = make_search("xxx", true, 2).results
      expect(results[0].post_context).to eq(["ccc xxx", "ddd"])
      expect(results[1].post_context).to eq(["ddd", "eee xxx"])
    end
  end
  
  describe "when there are changes to the file system" do
    it "should not return results for deleted files" do
      test_file = File.expand_path(project_search_fixture_dir + "/jscar.txt")

      # indexing should have happened by now
      search = make_search("testword")
      expect(search.results.map {|r| File.expand_path(r.file)}).to include(test_file)

      FileUtils.rm(test_file)
      
      # should still work but should not include the result
      search = make_search("testword")
      expect(search.results.map {|r| File.expand_path(r.file)}).not_to include(test_file)
    end
  end
  
  describe "streaming search results" do
    it "should stream by file" do
      search = make_search("Christmas")
      results_by_file = []
      search.on_file_results do |file_hits|
        results_by_file << file_hits
      end
      search.results
      results_by_file.length.should == 2
      results_by_file.map {|r| r.first.file.split("/").last}.sort.should == ["foo.txt", "qux.rb"].sort
    end
  end
end
  
  



