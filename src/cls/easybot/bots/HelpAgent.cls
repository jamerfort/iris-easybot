Class easybot.bots.HelpAgent Extends easybot.core.Agent
{

/// Display: List Bots, Agents, and Commands
/// Keywords: help bots, help agents, list bots, list agents, show bots, show agents
Method ListAgents(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the Agents currently loaded:")
  do response.Respond("")

  do response.ListItem("Agent1")
  do response.ListItem("Agent2")
  do response.ListItem("Agent3")
}

/// Display: Explain...
/// Keywords: I don't understand, I'm confused
Method Help(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Let me help explain.")
  do response.Respond("I'm an Agent here to help you accomplish tasks and discover information.")
  do response.Respond("I'm easily extensible with ObjectScript.")
  do response.Respond("")

  do ..ListAgents(.prompt, .response)
}

}
