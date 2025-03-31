Class easybot.bots.DatabaseAgent Extends easybot.core.Agent
{

/// Display: List Databases
/// Keywords: list databases, show databases
Method ListDatabases(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the databases I found:")
  do response.Respond("")

  do response.DisplayClassQuery("%SYS", "Config.Databases", "List", "Name,Directory")
}

}
