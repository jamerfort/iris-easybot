Class easybot.bots.CustomAgent Extends easybot.core.Agent
{

/// Display: List the days of the week
/// Keywords: days of the week, weekend, weekday, holiday
Method DaysOfTheWeekAgent(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  // Resond with initial information about what you'll be doing...
  do response.Respond("Here is information I have on the days of the week...")

  // gather information on days of the week
  // ...somehow...
  set days = $LB("Sun","Mon","Tue","Wed","Thu","Fri","Sat")

  // Print each day 
  for i=1:1:$LISTLENGTH(days) {
    set day = $LISTGET(days, i)
    do response.ListItem(day)
  }
}

}
