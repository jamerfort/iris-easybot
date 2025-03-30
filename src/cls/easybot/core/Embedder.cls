Class easybot.core.Embedder Extends %RegisteredObject
{

Property model As %ObjectHandle;

ClassMethod EmbedLength() As %Numeric
{
  // The vector length of the model defined in InitModel().
  return 384
}

Method InitModel() As %Status [ Language = python ]
{
  import fastembed
  self.model = fastembed.TextEmbedding()

  return 1
}

Method EmbedDocs(docs As %ListOfDataTypes) As %ListOfDataTypes [ Language = python ]
{
  import iris
  vecs = iris.cls('%ListOfDataTypes')._New()

  pydocs = []
  for i in range(docs.Count()):
    doc = docs.GetAt(i+1)
    pydocs.append(doc)

  for vec in self.model.embed(pydocs):
    vecstr = ','.join([str(i) for i in vec])
    vecs.Insert(vecstr)
  
  return vecs
}

Method EmbedDoc(doc As %String) As %String
{
  set docs = ##class(%ListOfDataTypes).%New()
  do docs.Insert(doc)

  set vecs = ..EmbedDocs(docs)

  return vecs.GetAt(1)
}

}
