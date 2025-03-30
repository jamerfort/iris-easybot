Class easybot.bots.NamespaceAgent Extends easybot.core.Agent
{

/// Display: Namespaces Menu
/// Keywords: namespaces, namespaces menu, namespaces group
Method NamespacesGroup(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.EnterGroup("Namespaces")
  do response.Respond("How can I help you with namespaces?")
}

/// Display: List Namespaces
/// Keywords: list namespaces, show namespaces
Method ListNamespaces(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the namespaces I found:")
  do response.Respond("")
  do response.ListItem("Namespace1")
  do response.ListItem("Namespace2")
  do response.ListItem("Namespace3")
}

/// Display: Filter Namespaces
/// Keywords: filter namespaces, select namespaces, filtered list of namespaces
Method FilterNamespaces(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the filtered namespaces:")
  do response.Respond("")
  do response.ListItem("FilteredNS1")
  do response.ListItem("FilteredNS3")
}

}
