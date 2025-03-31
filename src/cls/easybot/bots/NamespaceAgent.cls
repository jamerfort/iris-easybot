Class easybot.bots.NamespaceAgent Extends easybot.core.Agent
{

/// Display: List Namespaces
/// Keywords: list namespaces, show namespaces
Method ListNamespaces(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the namespaces I found:")
  do response.Respond("")

  do response.DisplayClassQuery("%SYS", "Config.Namespaces", "List", "Namespace,Globals,Routines")
}

}
