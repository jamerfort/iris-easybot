Class easybot.bots.DatabaseAgent Extends easybot.core.Agent
{

/// Display: Databases Menu
/// Keywords: databases, databases menu, databases group
Method DatabasesGroup(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.EnterGroup("Databases")
  do response.Respond("How can I help you with databases?")
}

/// Display: Database Help
/// Keywords: help databases, explain databases
/// Group: Databases
Method HelpDatabases(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("I can help you perform the following database tasks:")
  do response.Respond("")
  do response.ListItem("List Databases")
  do response.ListItem("Filter Databases")
}

/// Display: List Databases
/// Keywords: list databases, show databases
/// Group: Databases
Method ListDatabases(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the databases I found:")
  do response.Respond("")
  do response.ListItem("DB1")
  do response.ListItem("DB2")
  do response.ListItem("DB3")
}

/// Display: Filter Databases
/// Keywords: filter databases, select databases, filtered list of databases, show start with, show ends with, show contains, show matches
/// Group: Databases
Method FilterDatabases(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the filtered databases:")
  do response.Respond("")
  do response.ListItem("FilteredDB1")
  do response.ListItem("FilteredDB3")
}

}
