Class easybot.core.Loader Extends %RegisteredObject
{

ClassMethod Load() As %Status
{

  // Recreate the Target table
  set status = ##class(TargetStore).RecreateTable()
  if $$$ISERR(status) {
    return status
  }

  // Create an embedder
  set embedder = ##class(Embedder).%New()
  do embedder.InitModel()

  set classes = ..ListSubclasses("easybot.core.Agent")
  for i=1:1:classes.Count() {
    set cls = classes.GetAt(i)

    set status = ..LoadClass(cls, .embedder)
  }
}

ClassMethod ListSubclasses(baseClass As %String, ByRef status As %Status) As %ListOfDataTypes
{
  set status = $$$OK
  set rslts = ##class(%ListOfDataTypes).%New()

  set statement = ##class(%SQL.Statement).%New()
  set status = statement.%PrepareClassQuery("%Dictionary.ClassDefinition", "SubclassOf")

  if $$$ISERR(status) {
    return rslts
  }

  set rset = statement.%Execute(baseClass)

  while rset.%Next() {
    do rslts.Insert(rset.%Get("Name"))
  }

  return rslts
}

ClassMethod LoadClass(className As %String, ByRef embedder As Embedder) As %Status
{
  w "Loading "_className,!

  set cls = ##class(%Dictionary.ClassDefinition).%OpenId(className)

  for i=1:1:cls.Methods.Count() {
    set method = cls.Methods.GetAt(i)
    set spec = className_":"_method.Name

    set target = ##class(Target).%New()
    set target.ID = spec
    set target.Spec = spec
    set target.Display = spec
    set target.Type = "Agent"

    set keywords = ""

    set NEWLINE = $CHAR(13)_$CHAR(10)
    set lines = $LISTFROMSTRING(method.Description, NEWLINE)

    for n=1:1:$LISTLENGTH(lines) {
      set line = $LISTGET(lines, n)

      // Does the line contain a ":"
      if '(line [ ":") {
        // Nope, skip to next line
        continue
      }

      // Extract: label: Value
      set label = $PIECE(line, ":", 1)
      set value = $PIECE(line, ":", 2,*)

      // Remove leading/trailing whitespace
      set label = $ZSTRIP(label, "<>W")
      set value = $ZSTRIP(value, "<>W")

      // uppercase the label
      set label = $ZCONVERT(label, "U")

      // skip blank values
      if value = "" {
        continue
      }

      if label = "ID" {
        set target.ID = value
        continue
      }

      if label = "DISPLAY" {
        set target.Display = value
        continue
      }

      if (label = "TYPE") || (label = "GROUP") {
        set target.Type = value
        continue
      }

      if label = "KEYWORDS" {
        set $LIST(keywords, *+1) = value
        continue
      }
    }

    if $LISTLENGTH(keywords) > 0 {
      set fullkeywords = $LISTTOSTRING(keywords, "; ")
      set vec = embedder.EmbedDoc(fullkeywords)
      write " - "_target.Display,!
      set status = ##class(TargetStore).Insert(target.ID, target.Type, target.Spec, target.Display, fullkeywords, vec)
    }
  }

  write !

  return $$$OK
}

}
