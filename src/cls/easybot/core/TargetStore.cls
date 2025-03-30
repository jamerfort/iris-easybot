Class easybot.core.TargetStore Extends %RegisteredObject
{

ClassMethod CreateTable() As %Status
{
  set vecLength = ##class(Embedder).EmbedLength()

  set query = ""
    _"CREATE TABLE easybot_store.Targets ("
    _"  ID              VARCHAR(255),"
    _"  Type            VARCHAR(255),"
    _"  Spec            VARCHAR(255),"
    _"  Display         VARCHAR(255),"
    _" "
    _"  Keywords        TEXT,"
    _"  Embedding       VECTOR(DOUBLE, "_vecLength_")"
    _")"
  
  set statement = ##class(%SQL.Statement).%New()
  set sc = statement.%Prepare(query)

  if $$$ISERR(sc) {
    return sc
  }

  return statement.%Execute()
}

ClassMethod DropTable() As %Status
{
  set query = "DROP TABLE easybot_store.Targets"
  
  set statement = ##class(%SQL.Statement).%New()
  set sc = statement.%Prepare(query)

  if $$$ISERR(sc) {
    return sc
  }

  return statement.%Execute()
}

ClassMethod RecreateTable() As %Status
{
  set sc = ..DropTable()
  if $$$ISERR(sc) {
    return sc
  }

  return ..CreateTable()
}

ClassMethod Insert(id, type, spec, display, keywords, vec) As %Status
{
  set query = ""
    _"INSERT INTO easybot_store.Targets ("
    _"  ID, Type, Spec, Display, Keywords, Embedding"
    _") VALUES ( ?, ?, ?, ?, ?, TO_VECTOR(?, DOUBLE))"
  
  set statement = ##class(%SQL.Statement).%New()
  set sc = statement.%Prepare(query)

  if $$$ISERR(sc) {
    return sc
  }

  return statement.%Execute(id, type, spec, display, keywords, vec)
}

ClassMethod QueryByType(vec As %String, targetType As %String, ByRef results As %ListOfObjects, topN As %Numeric = 5) As %Status
{
  set query = ""
    _"SELECT TOP ?"
    _"  ID, Type, Spec, Display, Keywords, VECTOR_DOT_PRODUCT(Embedding, TO_VECTOR(?, DOUBLE)) as Score"
    _" FROM easybot_store.Targets"
    _" WHERE Type = ?"
    _" ORDER BY Score DESC"
  
  set statement = ##class(%SQL.Statement).%New()
  set sc = statement.%Prepare(query)

  if $$$ISERR(sc) {
    return sc
  }

  set rset = statement.%Execute(topN, vec, targetType)

  return ..handleQueryResults(.rset, .results)
}

ClassMethod Query(vec As %String, ByRef results As %ListOfObjects, topN As %Numeric = 5) As %Status
{
  set query = ""
    _"SELECT TOP ?"
    _"  ID, Type, Spec, Display, Keywords, VECTOR_DOT_PRODUCT(Embedding, TO_VECTOR(?, DOUBLE)) as Score"
    _" FROM easybot_store.Targets"
    _" WHERE Type in ('GROUP', 'AGENT')"
    _" ORDER BY Score DESC"
  
  set statement = ##class(%SQL.Statement).%New()
  set sc = statement.%Prepare(query)

  if $$$ISERR(sc) {
    return sc
  }

  set rset = statement.%Execute(topN, vec)

  return ..handleQueryResults(.rset, .results)
}

ClassMethod handleQueryResults(ByRef rset As %SQL.StatementResult, ByRef results As %ListOfObjects) As %Status
{
  if rset.%SQLCODE < 0 {
    set err = $System.Error.FromSQLCode(rset.%SQLCODE, "Error querying easybot_store.Targets") 
    return err.Status
  }

  while rset.%Next() {
    set target = ##class(easybot.core.Target).%New()
    set target.ID       = rset.%Get("ID")
    set target.Type     = rset.%Get("Type")
    set target.Spec     = rset.%Get("Spec")
    set target.Display  = rset.%Get("Display")
    set target.Keywords = rset.%Get("Keywords")
    set target.Score    = rset.%Get("Score")

    do results.Insert(target)
  }

  return $$$OK
}

}
