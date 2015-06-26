Plugin.define do
  name "tools"
  version "0.1"
  file "lib", "tools"
  object "Redcar::Tools::ToolsMenu"
  dependencies "FXML_Root_Files", ">0"
end
