require 'pp'
require "spec_helper"

FileList = Redcar::Project::FileList

describe FileList do
  before do
    ProjectFixtureHelper.create_project_fixtures
  end
  
  after do
    ProjectFixtureHelper.clear_project_fixtures
  end
  
  def fixture_path
    File.expand_path(File.join(File.dirname(__FILE__), *%w".. fixtures myproject"))
  end
  
  def relative_path(*path)
    File.join(fixture_path, *path)
  end
  
  before do
    @file_list = FileList.new(fixture_path)
    FileUtils.rm_f(relative_path(".redcar"))
  end
  
  it "should return an empty list initially" do
    @file_list.all_files.should be_empty
  end
  
  describe "file list" do
    before do
      @file_list.update
    end
    
    it "should return a list of files in the directory" do
      @file_list.all_files.include?(relative_path("README")).should be true
      @file_list.all_files.include?(relative_path("lib", "foo_lib.rb")).should be true
    end

    # I believe this may be platform-specific
    # A failure may occur when the symlink is not re-created when running the tests on another OS
    it "should return a list of files in a symlinked directory" do
      expect(@file_list.all_files.include?(relative_path("lib_symlink", "foo_lib.rb"))).to be true
    end
  end
  
  describe "update information" do
    before do
      @dirname = File.join(__dir__, "project_spec_testdir")
      @files = {"Carnegie"    => "steel", 
                "Rockefeller" => "oil",
                "subdir"      => {
                  "Ford" => "cars"
                }}
      write_dir_contents(@dirname, @files)
      @file_list = FileList.new(@dirname)
      @file_list.update
    end

    after do
      FileUtils.rm_r(@dirname)
    end
    
    describe "after files have been added" do
      before do
        @time = Time.now
        write_test_file(@dirname, "Branson", "balloons")
        @file_name = File.expand_path(File.join(@dirname, "Branson"))
      end
      
      describe "on general update" do
        it "should add the file to the list" do
          @file_list.update
          expect(@file_list.all_files.include?(@file_name)).to be true
        end
        
        it "should be changed_since" do
          @file_list.update
          @file_list.changed_since(@time).keys.include?(@file_name).should be true
        end
      end
      
      describe "on specific update" do
        it "should add the file to the list" do
          @file_list.update(@file_name)
          @file_list.all_files.include?(@file_name).should be true
        end
        
        it "should not add other new files to the list" do
          write_test_file(@dirname, "Kurzweil", "theories")
          file_name2 = File.expand_path(File.join(@dirname, "Kurzweil"))
          
          @file_list.update(@file_name)
          @file_list.all_files.include?(@file_name).should be true
          @file_list.all_files.include?(file_name2).should be false
        end
        
        it "should not remove files that are already there" do
          write_test_file(@dirname, "Kurzweil", "theories")
          file_name2 = File.expand_path(File.join(@dirname, "Kurzweil"))
          
          @file_list.update(file_name2)
          @file_list.all_files.include?(file_name2).should be true
          @file_list.all_files.include?(File.expand_path(File.join(@dirname, "Carnegie"))).should be true
        end
      end
    end
    
    describe "after files have been modified" do
      before do
        @time = Time.now
        sleep 1
        write_test_file(@dirname, "Carnegie", "peace")
        @file_name = File.expand_path(File.join(@dirname, "Carnegie"))
      end

      
      it "should still be in the file list" do
        @file_list.update
        @file_list.all_files.include?(@file_name).should be true
      end
      
      it "should be changed since" do
        @file_list.update
        @file_list.changed_since(@time).keys.include?(@file_name).should be true
      end
    end
    
    describe "after files have been deleted" do
      before do
        remove_file(@dirname, "Rockefeller")
        @file_name = File.expand_path(File.join(@dirname, "Rockefeller"))
      end
      
      it "should not be in the file list" do
        @file_list.update
        @file_list.all_files.include?(@file_name).should be false
      end
    end
  end
end










