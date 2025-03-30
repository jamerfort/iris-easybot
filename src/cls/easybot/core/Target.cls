Class easybot.core.Target Extends %RegisteredObject
{

Property ID As %Library.String(MAXLEN = 255) [ SqlColumnNumber = 2 ];

Property Type As %Library.String(MAXLEN = 255) [ SqlColumnNumber = 3 ];

Property Spec As %Library.String(MAXLEN = 255) [ SqlColumnNumber = 4 ];

Property Display As %Library.String(MAXLEN = 255) [ SqlColumnNumber = 5 ];

Property Keywords As %Stream.GlobalCharacter [ SqlColumnNumber = 6 ];

Property Score As %Numeric;

}
