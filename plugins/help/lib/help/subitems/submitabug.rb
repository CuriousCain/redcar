class SubmitABugCommand < Redcar::Command
  def execute
    Redcar::HtmlView::DisplayWebContent.new(
        "Submit a Bug",
        "https://redcar.lighthouseapp.com/projects/25090-redcar/tickets/new",
        true,
        Redcar::Help::HelpTab
    ).run
  end
end