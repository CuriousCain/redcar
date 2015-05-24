class ViewShortcutsCommand < Redcar::Command
  def execute
    controller = Redcar::Help::ViewController.new
    tab = win.new_tab(Redcar::Help::HelpTab)
    tab.html_view.controller = controller
    tab.focus
  end
end