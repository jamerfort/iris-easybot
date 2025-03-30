Class easybot.core.Shell Extends %RegisteredObject
{

Property UserPS1 As %String;

Property ResponsePS1 As %String;

Property ListItemPS1 As %String;

Property NumberedItemPS1 As %String;

Property ErrorPS1 As %String;

Property DebugPS1 As %String;

Property ChoicePS1 As %String;

ClassMethod Run()
{
  set shell = ##class(Shell).%New()
  set shell.UserPS1         = ">>> "
  set shell.ResponsePS1     = "    | "
  set shell.ListItemPS1     = "    | - "
  set shell.NumberedItemPS1 = "    | # "
  set shell.ErrorPS1        = "!!! "
  set shell.DebugPS1        = "##### "
  set shell.ChoicePS1       = "      #. "

  do shell.Start()
}

Method Start()
{
  //set builtins = ##class(%SYS.Python).Import("builtins")
  //set None = ##class(%SYS.Python).None()
  //set easybotpy = ##class(%SYS.Python).Import("easybotpy")
  set session = ##class(Session).%New()
  set status = session.Init()
  set choices = 0
  // set choices(#) = $LB("CHOICE", display, targetSpec, value)

  if $$$ISERR(status) {
    do ..HandleError(status)
  }

  // Print a welcome message
  w session.Welcome(),!

  // Turn off terminal history
  use 0:(:"-R")

  // START REPL Loop #########################################################################
  while 1 {
    if session.CurrentGroup '= "" {
      write "Current Menu: "_session.CurrentGroup,!
    }
    write ..UserPS1
    read prompt,!

    // Ignore blank lines
    if (prompt = "") {
      continue
    }

    // Handle exits
    if (prompt = "exit") || (prompt = "quit") || (prompt = "halt") || (prompt = "h") || (prompt = "q") {
      // Quit out of the while loop, not the function
      quit
    }

    // Handle clear screen
    if (prompt = "clear") {
      write #
      continue
    }

    // Handle debugging
    if (prompt = "debug") {
      set session.DebugLevel = session.DebugLevel + 1
      w "Increasing debugging to ",session.DebugLevel,!
      continue
    }

    // Handle debugging
    if (prompt = "nodebug") {
      w "Turning off debugging",!
      set session.DebugLevel = 0
      continue
    }

    // Handle reset
    if (prompt = "reset") {
      w "Resetting chat",!
      do session.Init()
      continue
    }

    // Handle load
    if (prompt = "load") {
      w "Reloading",!
      do ##class(easybot.core.Loader).Load()
      continue
    }

    // Process Prompt ##################
    set response = session.Chat(prompt)
    do ..PrintLines(response.lines)

    if $$$ISERR(response.error) {
      do ..HandleError(response.error)
    }
    // #################################
  }
  // END REPL Loop ###########################################################################

  // Turn on terminal history
  use 0:(:"+R")
}

Method PrintLines(ByRef lines As %String, lineDelay As %Numeric = "0.03")
{
  set count = lines.Count()
  set choices = 0
  set numitems = 0

  for i=1:1:count {
    set line = lines.GetAt(i)

    set type = $LISTGET(line, 1)
    set value = $LISTGET(line, 2)

    if type = "LINE" {
      write value,!

    } elseif type = "RESPONSE" {
      write ..ResponsePS1_value,!

    } elseif type = "LISTITEM" {
      write ..ListItemPS1_value,!

    } elseif type = "NUMBEREDITEM" {
      set numitems = numitems + 1
      set ps1 = $REPLACE(..NumberedItemPS1, "#", numitems)
      write ps1_value,!

    } elseif type = "DEBUG" {
      set rightSide = $LISTGET(line,3)
      set level = $LISTGET(line,4)

      set fullvalue = ..toColumnString(value, rightSide, 40)
      write ..DebugPS1_fullvalue,!

    } elseif type = "CHOICE" {
      set choices = choices + 1

      set choice = $LISTGET(line, 3)

      set ps1 = $REPLACE(..ChoicePS1, "#", choices)
      write ps1_value,!

    }

    // Sleep to simulate typing
    if lineDelay > 0 {
      hang lineDelay
    }
  }
}

ClassMethod toColumnString(col1, col2 As %String, col1Width As %Numeric = 40) As %String
{
  if col2 = "" {
    return col1
  }

  set len = $LENGTH(col1)

  set spaces = " "

  if len >= col1Width {
    return col1_spaces_col2
  }

  for i=1:1:col1Width-len {
    set spaces = spaces_" "
  }

  return col1_spaces_col2
}

Method HandleError(error As %Status)
{
  set lines = ##class(%ListOfDataTypes).%New()

  do lines.Insert($LB("ERROR", "==================================================================================="))
  do lines.Insert($LB("ERROR", $SYSTEM.Status.GetErrorText(error)))
  do lines.Insert($LB("ERROR", ""))
  do lines.Insert($LB("ERROR", "==================================================================================="))

  do ..PrintLines(.lines)
}

}
