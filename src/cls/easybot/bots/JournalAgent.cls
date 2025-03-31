Class easybot.bots.JournalAgent Extends easybot.core.Agent
{

/// Display: Show Journal Settings
/// Keywords: journal information, journal settings
Method ShowJournalInfo(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the Journal Settings for this instance...")
  do response.Respond("")

  set origNS = $NAMESPACE
  zn "%SYS"

  set status = ##class(Config.Journal).Get(.properties)

  zn origNS

  if $$$ISERR(status) {
    do response.Error("Sorry. Unable to find the information", status)
    do response.Error("Try again...")
    return
  }

  do response.TableHeader($LB("Setting", "Value"))

  set setting = ""
  set setting = $ORDER(properties(setting))

  while setting '= "" {
    set value = properties(setting)
    do response.TableRow($LB(setting, value))

    set setting = $ORDER(properties(setting))
  }
}

/// Display: List Journal Files
/// Keywords: list journals, show journals, journal files
Method ListJournals(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{

  set origNS = $NAMESPACE
  zn "%SYS"

  set status = ##class(Config.Journal).Get(.properties)

  zn origNS

  if $$$ISERR(status) {
    do response.Error("Sorry. Unable to find the information", status)
    do response.Error("Try again...")
    return
  }

  do response.Respond("Here are the Journals I found...")
  do response.Println("")
  do response.DisplayClassQuery($NAMESPACE, "%File", "FileSet", "Name,Size,DateModified", properties("CurrentDirectory"), "*")
  do response.Println("")

  if properties("CurrentDirectory") '= properties("AlternateDirectory") {
    do response.Respond("...and the Alternate Journals I found...")
    do response.Println("")
    do response.DisplayClassQuery($NAMESPACE, "%File", "FileSet", "Name,Size,DateModified", properties("AlternateDirectory"), "*")
  }
}

}
