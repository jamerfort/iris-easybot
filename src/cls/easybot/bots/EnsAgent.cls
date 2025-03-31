Class easybot.bots.EnsAgent Extends easybot.core.Agent
{

/// Display: List Interfaces
/// Keywords: list interfaces, list components, show components, show interfaces
Method ListInterfaces(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here are the interfaces I found:")
  do response.Respond("")

  do response.DisplayClassQuery($NAMESPACE, "Ens.Config.Production", "EnumerateConfigItemNames", "ConfigName,Enabled")
}

/// Display: Stop Interface
/// Keywords: stop interface, disable interface
Method StopInterface(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Warning("I can't do this yet, but let's pretend...")
  do response.Println("")

  do response.Respond("Stopping Interface XYZ...")
}

/// Display: Start Interface
/// Keywords: start interface, enable interface
Method StartInterface(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Warning("I can't do this yet, but let's pretend...")
  do response.Println("")

  do response.Respond("Starting Interface XYZ...")
}

/// Display: Stop Production
/// Keywords: stop production, disable production
Method StopProduction(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Warning("I can't do this yet, but let's pretend...")
  do response.Println("")

  do response.Respond("Stopping Production XYZ...")
}

/// Display: Start Production
/// Keywords: start production, enable production
Method StartProduction(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Warning("I can't do this yet, but let's pretend...")
  do response.Println("")

  do response.Respond("Starting Production XYZ...")
}

}
