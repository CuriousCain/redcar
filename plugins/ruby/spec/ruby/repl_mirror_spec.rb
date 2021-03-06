require 'spec_helper'

class Redcar::Ruby
  describe REPLMirror do
    before do
      @mirror = REPLMirror.new
      @changed_event = false
      @mirror.add_listener(:change) { @changed_event = true }
    end

    def commit_test_text1
      text = <<-RUBY
# Ruby REPL
# type 'help' for help

>> $internal_repl_test = 707
RUBY
      @mirror.commit(text.chomp)
    end

    def result_test_text1
      (<<-RUBY).chomp
# Ruby REPL
# type 'help' for help

>> $internal_repl_test = 707
=> 707
>> 
RUBY
    end

    def commit_test_text2
      text = <<-RUBY
# Ruby REPL
# type 'help' for help

>> $internal_repl_test = 707
=> 707
>> $internal_repl_test = 909
RUBY
      @mirror.commit(text.chomp)
      text.chomp
    end

    def result_test_text2
      (<<-RUBY).chomp
# Ruby REPL
# type 'help' for help

>> $internal_repl_test = 707
=> 707
>> $internal_repl_test = 909
=> 909
>> 
RUBY
    end


    def commit_no_input
      text = <<-RUBY
# Ruby REPL
# type 'help' for help

>> 
RUBY
      @mirror.commit(text)
    end

    def prompt
      "# Ruby REPL\n\n"
    end

    describe "with no history" do
      it "should exist" do
        @mirror.should be_exist
      end

      it "should have a message and a prompt" do
        @mirror.read.should == (<<-RUBY).chomp
# Ruby REPL
# type 'help' for help

>> 
RUBY
      end

      it "should have a title" do
        @mirror.title.should == "Ruby REPL"
      end

      it "should not be changed" do
        @mirror.should_not be_changed
      end

      describe "when executing" do
        it "should execute committed text" do
          commit_test_text1
          $internal_repl_test.should == 707
        end

        it "should allow committing nothing as the first command" do
          commit_no_input
          @mirror.read.should == "# Ruby REPL\n# type 'help' for help\n\n>> \n=> nil\n>> "
        end

        it "should allow committing nothing as an xth command" do
          committed = commit_test_text2
          @mirror.commit committed + "\n>> "
          @mirror.read.should == "# Ruby REPL\n# type 'help' for help\n\n>> $internal_repl_test = 909\n=> 909\n>> \n=> nil\n>> "
        end

        it "should emit changed event when text is executed" do
          commit_test_text1
          @changed_event.should be true
        end

        it "should now have the command and the result at the end" do
          commit_test_text1
          @mirror.read.should == result_test_text1
        end

        it "should display errors" do
          @mirror.commit(prompt + ">> nil.foo")
          @mirror.read.should be_include(<<-RUBY)
# Ruby REPL
# type 'help' for help

>> nil.foo
x> NoMethodError: undefined method `foo' for nil:NilClass
        (repl):1
RUBY
        # ` RUBY
        end
      end
    end

    describe "with a history" do
      before do
        commit_test_text1
      end

      it "should not have changed" do
        @mirror.changed?.should be false
      end

      it "should display the history and prompt correctly" do
        @mirror.read.should == result_test_text1
      end

      describe "when executing" do
        it "should execute committed text" do
          commit_test_text2
          $internal_repl_test.should == 909
        end

        it "should show the correct history" do
          commit_test_text2
          @mirror.read.should == result_test_text2
        end

        it "should allow the history to be cleared" do
          @mirror.clear_history
          @mirror.read.should == ">> "
        end

      end
    end

    describe "when executing" do
      it "should execute inside a main object" do
        @mirror.commit(prompt + ">> self")
        @mirror.read.should == (<<-RUBY).chomp
# Ruby REPL
# type 'help' for help

>> self
=> main
>> 
RUBY
      end

      it "should persist local variables" do
        sent = prompt + ">> a = 13"
        @mirror.commit(sent)
        @mirror.commit(sent + "\n>> a")
        @mirror.read.should == (<<-RUBY).chomp
# Ruby REPL
# type 'help' for help

>> a = 13
=> 13
>> a
=> 13
>> 
RUBY
      end
    end
  end
end



