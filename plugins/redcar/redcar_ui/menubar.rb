java_import java.lang.Runnable

java_import javafx.scene.control.Tab

module FX_UI
  module Menubar
    def options_action
      Redcar::Tools::Options::OptionsCommand.new.execute
    end

    def about_action
      Redcar::Help::AboutCommand.new.execute
    end

    def online_help_action
      Redcar::Help::OnlineHelpCommand.new.execute
    end

    def submit_bug_action
      Redcar::Help::SubmitABugCommand.new.execute
    end

    def new_file_action
      test_tab = Tab.new
      test_tab.set_text 'New File'
      @editorTabPane.get_tabs.add test_tab

      #Redcar::FileMenu::NewFileCommand.new.execute
    end
  end
end
