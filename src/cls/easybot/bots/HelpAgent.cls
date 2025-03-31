Class easybot.bots.HelpAgent Extends easybot.core.Agent
{

/// Display: List Bots/Agents
/// Keywords: list bots, list agents
Method ListAgents(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the Agents currently loaded:")
  do response.Respond("")

  set status = ##class(easybot.core.TargetStore).ListAgents(.agents)

  if $$$ISERR(status) {
    do response.Error("Sorry. Unable to find the information", status)
    do response.Error("Try again...")
    return
  }

  for i=1:1:agents.Count() {
    do response.ListItem(agents.GetAt(i))
  }
}

/// Display: List Bots/Agents, and Menus
/// Keywords: menus, bot menus, agent menus
Method ListAgentDetails(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the Agents currently loaded:")
  do response.Respond("")

  set status = ##class(easybot.core.TargetStore).ListAgents(.agents)

  if $$$ISERR(status) {
    do response.Error("Sorry. Unable to find the information", status)
    do response.Error("Try again...")
    return
  }

  for i=1:1:agents.Count() {
    set agent = agents.GetAt(i)
    do response.Respond(agent)

    set status = ##class(easybot.core.TargetStore).ListItemsByAgent(agent, .menus)
    if $$$ISERR(status) {
      do response.Error("Unable to find information for "_agent, status)
      continue
    }

    for m=1:1:menus.Count() {
      do response.ListItem(menus.GetAt(m))
    }

    do response.Respond("")
  }
}

/// Display: EasyBot Help
/// Keywords: help
Method Help(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Let me help explain.")
  do response.Respond("I'm an Agent here to help you accomplish tasks and discover information.")
  do response.Respond("I'm easily extensible with ObjectScript.")
  do response.Respond("")

  do response.LineBreak()
  do ..ListAgentDetails(.prompt, .response)

  do response.LineBreak()
  do response.Respond("")
  do ..ShellCommands(.prompt, .response)
}

Method ShellCommands(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are some EasyBot shell commands:")
  do response.Respond("")

  do response.ListItem("clear")
  do response.Respond("")

  do response.ListItem("exit")
  do response.ListItem("halt")
  do response.ListItem("h")
  do response.ListItem("q")
  do response.ListItem("quit")
  do response.Respond("")

  do response.ListItem("load")
  do response.ListItem("reset")
  do response.Respond("")

  do response.ListItem("debug")
  do response.ListItem("nodebug")
}

}
