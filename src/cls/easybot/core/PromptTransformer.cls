Class easybot.core.PromptTransformer Extends %RegisteredObject
{

ClassMethod Handle(spec As %String, ByRef prompt As Prompt, ByRef response As ShellResponse) As %Status
{
  do response.DEBUG(2, "PromptTransformer:Handle()", "spec="_spec)
  set status = $$$OK

  // Do nothing
  if spec = "" {
    return status
  }

  // Handle className:methodName specs
  set className = $PIECE(spec, ":", 1)
  set methodName = $PIECE(spec, ":", 2)

  try {
    do response.DEBUG(2, "PromptTransformer:Calling", "##class("_className_")."_methodName)
    do $CLASSMETHOD(className, methodName, prompt, .status, .response)
  } catch err {
    set status = $$$ERROR($$$GeneralError, "Error calling PromptTransformer spec: "_spec)
    return $$$ADDSC(status, $$$ERROR($$$GeneralError, err.DisplayString()))
  }

  return status
}

ClassMethod NoOp(prompt As Prompt, ByRef status As %Status, ByRef response As ShellResponse)
{
  set status = $$$OK

  // Do something to prompt.Value.
  // Do NOT modify prompt.UserValue.
  //set prompt.Value = $ZCONVERT(prompt.Value, "U")
}

ClassMethod Uppercase(prompt As Prompt, ByRef status As %Status, ByRef response As ShellResponse)
{
  set status = $$$OK

  set prompt.Value = $ZCONVERT(prompt.Value, "U")
}

ClassMethod Lowercase(prompt As Prompt, ByRef status As %Status, ByRef response As ShellResponse)
{
  set status = $$$OK

  set prompt.Value = $ZCONVERT(prompt.Value, "L")
}

ClassMethod Choose(prompt As Prompt, ByRef status As %Status, ByRef response As ShellResponse)
{
  set status = $$$OK

  set prompt.Value = $ZCONVERT(prompt.Value, "L")
}

}
