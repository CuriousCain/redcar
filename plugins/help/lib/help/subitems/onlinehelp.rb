class OnlineHelpCommand < Redcar::Command
  def execute
    Redcar::HtmlView::DisplayWebContent.new(
        "Online Help",
        "http://github.com/redcar/redcar/wiki/Users-Guide",
        true,
        Redcar::Help::HelpTab
    ).run
  end
end