Class easybot.core.Prompt Extends %RegisteredObject
{

Property UserValue As %String;

Property Value As %String;

Property Vector As %String;

ClassMethod FromString(userPrompt As %String) As Prompt
{
  set prompt = ##class(Prompt).%New()
  set prompt.UserValue = userPrompt
  set prompt.Value = userPrompt

  return prompt
}

}
