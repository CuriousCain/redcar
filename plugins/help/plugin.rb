
Plugin.define do
  name    "help"
  version "2.1"
  file    "lib", "help"
  object  "Redcar::Help"
  dependencies "FXML_Root_Files", ">0"
end