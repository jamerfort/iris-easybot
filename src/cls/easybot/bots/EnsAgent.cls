Class easybot.bots.EnsAgent Extends easybot.core.Agent
{

/// Display: List Interfaces
/// Keywords: list interfaces, list components, show components, show interfaces
Method ListInterfaces(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the interfaces I found:")
  do response.Respond("")
  do response.ListItem("Interface1")
  do response.ListItem("Interface2")
  do response.ListItem("Interface3")
  do response.ListItem("Interface1")
  do response.ListItem("Interface2")
  do response.ListItem("Interface1")
  do response.ListItem("Interface1")
  do response.ListItem("Interface2")
  do response.ListItem("Interface1")
  do response.ListItem("Interface1")
  do response.ListItem("Interface1")
  do response.ListItem("Interface2")
  do response.ListItem("Interface3")
  do response.ListItem("Interface2")
  do response.ListItem("Interface3")
  do response.ListItem("Interface2")
  do response.ListItem("Interface3")
  do response.ListItem("Interface3")
  do response.ListItem("Interface2")
  do response.ListItem("Interface3")
  do response.ListItem("Interface3")
}

/// Display: Stop Interface
/// Keywords: stop interface, disable interface
Method StopInterface(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Which interface would you like to stop?")
}

/// Display: Start Interface
/// Keywords: start interface, enable interface
Method StartInterface(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Which interface would you like to start?")
}

/// Display: Stop Production
/// Keywords: stop production, disable production
Method StopProduction(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Which production would you like to stop?")
}

/// Display: Start Production
/// Keywords: start production, enable production
Method StartProduction(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Which production would you like to start?")
}

}
