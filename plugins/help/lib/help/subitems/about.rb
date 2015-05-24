class AboutCommand < Redcar::Command
  def execute
    new_tab = Redcar::Top::OpenNewEditTabCommand.new.run
    new_tab.document.text = <<-TXT
About: Redcar
Version: #{Redcar::VERSION}
Ruby Version: #{RUBY_VERSION}
Jruby version: #{JRUBY_VERSION}
Redcar.environment: #{Redcar.environment}
    TXT

    puts 'RUNNING FROM SUBITEMS FOLDER'

    new_tab.edit_view.reset_undo
    new_tab.document.set_modified(false)
    new_tab.title = 'About'
  end
end