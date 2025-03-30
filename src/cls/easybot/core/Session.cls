Class easybot.core.Session Extends %RegisteredObject
{

/// Which "classname:methodname" should be called with the user prompt?
/// 
/// Method signature:
/// ClassMethod methodname(prompt As Prompt, ByRef status As %Status)
/// 
/// See easybot.core.PromptTransformer class.
Property PromptTransformerSpec As %String;

Property DebugLevel As %Numeric;

Property Choices As list Of Choice;

Property CurrentGroup As %String;

Property Embedder As Embedder;

Method Init() As %String
{
  set ..DebugLevel = 0
  set ..Choices = ##class(%ListOfObjects).%New()
  set ..CurrentGroup = ""

  set ..Embedder = ##class(Embedder).%New()
  return ..Embedder.InitModel()
}

Method Welcome() As %String
{
  return "How can I help you?"
}

/// Store any state from the response needed for the
/// next interaction.
/// 
/// For example, choices.
Method StoreState(ByRef response As ShellResponse) As ShellResponse
{
  set ..Choices = response.choices
  set ..CurrentGroup = response.currentGroup
  return response
}

Method Chat(userPrompt As %String) As ShellResponse
{
  set topN = 5
  set baseThreshold = 0.6
  set diffThreshold = 0.08

  // Init response object ***********************************************************
  set response = ##class(ShellResponse).%New()
  set response.error = $$$OK
  set response.DebugLevel = ..DebugLevel

  // Build and transform the prompt *************************************************
  do response.DEBUG(1, "Original Prompt", userPrompt)

  set prompt = ##class(Prompt).FromString(userPrompt)
  set status = ##class(PromptTransformer).Handle(..PromptTransformerSpec, .prompt, .response)
  set ..PromptTransformerSpec = ""

  do response.DEBUG(1, "Transformed Prompt", prompt.Value)

  if $$$ISERR(status) {
    // Don't respond here.  Allow the PromptTransformer
    // to respond to the user as needed.
    set response.error = status

    return ..StoreState(.response)
  }

  // Embed/Vectorize the Prompt ******************************************************
  do response.DEBUG(1, "Embedding Prompt")
  set prompt.Vector = ..Embedder.EmbedDoc(prompt.Value)

  // Handle Choices **********************************************************************
  if ..Choices.Count() > 0 {
    do response.DEBUG(1, "Selecting Choice from "_..Choices.Count()_" Choices", prompt.Value)

    // Valid choice
    if $ISVALIDNUM(prompt.Value, 0, 1, ..Choices.Count()) {
      set choice = ..Choices.GetAt(prompt.Value)
      set response = ..CallTarget(choice.TargetSpec, .prompt, .response)
      return ..StoreState(.response)
    }

    // Invalid choice
    do response.Respond("Try again.")
    do response.Respond("Choose one of these options...")
    for i=1:1:..Choices.Count() {
      set choice = ..Choices.GetAt(i)
      do response.Choice(choice.Display, choice.TargetSpec, choice.Value)
    }
    return ..StoreState(.response)

  }

  // Find all target Actions or Groups ***************************************************
  set allTargets = ##class(%ListOfObjects).%New()

  if ..CurrentGroup = "" {
    do response.DEBUG(1, "Finding Matches")
    set status = ##class(TargetStore).Query(prompt.Vector, .allTargets, topN)
  } else {
    do response.DEBUG(1, "Finding Matches for Group: "_..CurrentGroup)
    set status = ##class(TargetStore).QueryByType(prompt.Vector, ..CurrentGroup, .allTargets, topN)
  }

  for i=1:1:allTargets.Count() {
    set target = allTargets.GetAt(i)
    do response.DEBUG(2, "Matching Target", i_". "_target.Spec_" ("_$DECIMAL(target.Score,2)_")")
  }

  if $$$ISERR(status) {
    set response.error = status
    do response.Respond("Unable to help with that.")
    do response.Respond("Try again...")

    return ..StoreState(.response)
  }

  // Reduce Targets by Score *********************************************************
  set targets = ..ReduceTargets(.allTargets, baseThreshold, diffThreshold, .status) 

  // Choose or Call Target ***********************************************************
  // No matches
  if targets.Count() = 0 {
    do response.Respond("I couldn't find anything related to that.")
    do response.Respond("Try again...")

    return ..StoreState(.response)
  }

  // Single match...yeah!
  if targets.Count() = 1 {
    set target = targets.GetAt(1)
    set response = ..CallTarget(target.Spec, .prompt, .response)

    return ..StoreState(.response)
  }

  // Multiple possibilities
  do response.Respond("Choose one of these options...")
  for i=1:1:targets.Count() {
    set target = targets.GetAt(i)
    set score = $DECIMAL(target.Score, 2)

    set line = target.Display_" ("_score_")"
    do response.Choice(line, target.Spec, i)
  }

  // Return response *****************************************************************
  return ..StoreState(.response)
}

Method ReduceTargets(ByRef targets As %ListOfObjects, baseThreshold As %Numeric = 0.6, diffThreshold As %Numeric = 0.1, ByRef status As %Status) As %ListOfObjects
{
  set status = $$$OK
  set results = ##class(%ListOfObjects).%New()

  if targets.Count() = 0 {
    // Nothing to do
    return results
  }

  set top = targets.GetAt(1)
  if top.Score <= baseThreshold {
    return results
  }

  do results.Insert(top)

  if targets.Count() = 1 {
    // Nothing else to do
    return results
  }

  set thresh = top.Score - diffThreshold
  if baseThreshold > thresh {
    set thresh = baseThreshold
  }

  for i=2:1:targets.Count() {
    set target = targets.GetAt(i)

    if target.Score > thresh {
      do results.Insert(target)
    } else {
      // doesn't match threshold, bail out early
      return results
    }
  }

  return results
}

Method CallTarget(spec As %String, ByRef prompt As Prompt, ByRef response As ShellResponse) As ShellResponse
{
  set className = $PIECE(spec, ":", 1)
  set methodName = $PIECE(spec, ":", 2)

  set inst = $CLASSMETHOD(className, "%New")
  do $METHOD(inst, methodName, .prompt, .response)
  return response
}

}
