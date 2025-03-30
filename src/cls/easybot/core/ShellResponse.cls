Class easybot.core.ShellResponse Extends %RegisteredObject
{

/// Buffer of lines for this response.
/// These will be displayed by the user interface once
/// it receives the response.
Property lines As list Of %String;

/// Which error/status to pass to user interface?
Property error As %Status;

/// Which choices have been given to the user
/// with this response?
Property choices As list Of Choice;

/// The current menu group we are limited to.
Property currentGroup As %String;

/// Which "classname:methodname" should be called with the user prompt?
/// 
/// Method signature:
/// ClassMethod methodname(prompt As Prompt, ByRef status As %Status)
/// 
/// See easybot.core.PromptTransformer class.
Property PromptTransformerSpec As %String;

/// What to prepend to response lines called with Respond(line)
Property PS1 As %String;

/// What DebugLevel is active?
Property DebugLevel As %Numeric;

/// What to prepend to debug lines
Property DebugPS1 As %String;

/// Add a regular line to the output lines.
/// Use this for result output.
/// Use Respond(line) for "conversing" with the user.
Method Println(line As %String, prefix As %String = "") As %Status
{
  return ..lines.Insert($LB("LINE", line))
}

/// Add a response line to the output.
/// Use this for "conversing" with the user.
/// Use Println(line) for result output.
Method Respond(line As %String) As %Status
{
  return ..lines.Insert($LB("RESPONSE", line))
}

/// Add a list item line to the output.
Method ListItem(line As %String) As %Status
{
  return ..lines.Insert($LB("LISTITEM", line))
}

/// Add a numbered list item line to the output.
Method NumberedItem(line As %String) As %Status
{
  return ..lines.Insert($LB("NUMBEREDITEM", line))
}

/// Add a choice line to the output.
/// Use this for "conversing" with the user.
/// Use Println(line) for result output.
Method Choice(line, targetSpec, value As %String) As %Status
{
  set choice = ##class(Choice).%New()
  set choice.Display = line
  set choice.TargetSpec = targetSpec
  set choice.Value = value

  do ..choices.Insert(choice)

  return ..lines.Insert($LB("CHOICE", choice.Display, choice))
}

/// Add a debug line if DebugLevel is high enough.
Method DEBUG(level As %Numeric, message As %String, rightSide As %String = "")
{
  if ..DebugLevel < level {
    return 
  }

  return ..lines.Insert($LB("DEBUG", message, rightSide, ..DebugLevel))
}

/// Which PromptTransformer function should be used
/// to process the user's next input?
/// 
/// See easybot.core.PromptTransformer for info on the
/// spec format.
Method NextPrompt(promptTransformerSpec As %String)
{
  set ..PromptTransformerSpec = promptTransformerSpec
}

Method EnterGroup(group As %String)
{
  set ..currentGroup = group
}

}
