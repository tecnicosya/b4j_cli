B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
End Sub

Public Sub ValidateFieldDefinition(fieldDef As Map) As Boolean
    If fieldDef = Null Then Return False
    If fieldDef.ContainsKey("name") = False Then Return False
    If fieldDef.ContainsKey("type") = False Then Return False
    Dim name As String = fieldDef.Get("name")
    Dim fieldType As String = fieldDef.Get("type")
    If name.Length = 0 Or fieldType.Length = 0 Then Return False
    Return True
End Sub

Public Sub IsValidIdentifier(text As String) As Boolean
    If text = Null Or text.Length = 0 Then Return False
    Dim i As Int
    For i = 0 To text.Length - 1
        Dim ch As String = text.CharAt(i)
        If i = 0 Then
            If IsLetter(ch) = False And ch <> "_" Then Return False
        Else
            If IsLetter(ch) = False And IsDigit(ch) = False And ch <> "_" Then Return False
        End If
    Next
    Return True
End Sub

Public Sub SanitizeFileName(fileName As String) As String
    If fileName = Null Then Return ""
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To fileName.Length - 1
        Dim ch As String = fileName.CharAt(i)
        If IsLetter(ch) Or IsDigit(ch) Or ch = "_" Or ch = "-" Or ch = "." Then
            builder.Append(ch)
        End If
    Next
    Return builder.ToString
End Sub

Public Sub GetCurrentTimestamp As Long
    Return DateTime.Now
End Sub

Public Sub FormatDate(timestamp As Long) As String
    Return DateTime.GetDate(timestamp)
End Sub

Public Sub FormatDateTime(timestamp As Long) As String
    Dim datePart As String = DateTime.GetDate(timestamp)
    Dim timePart As String = DateTime.GetTime(timestamp)
    Return datePart & " " & timePart
End Sub

Public Sub StringToList(text As String, delimiter As String) As List
    Dim list As List
    list.Initialize
    If text = Null Then Return list
    Dim parts() As String = text.Split(delimiter)
    Dim i As Int
    For i = 0 To parts.Length - 1
        list.Add(parts(i))
    Next
    Return list
End Sub

Public Sub ListToString(items As List, delimiter As String) As String
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To items.Size - 1
        If i > 0 Then builder.Append(delimiter)
        builder.Append(items.Get(i))
    Next
    Return builder.ToString
End Sub

Public Sub TrimQuotes(text As String) As String
    If text = Null Then Return ""
    If text.StartsWith(""") And text.EndsWith(""") Then
        Return text.SubString2(1, text.Length - 1)
    End If
    Return text
End Sub

Private Sub IsLetter(ch As String) As Boolean
    Return (ch >= "a" And ch <= "z") Or (ch >= "A" And ch <= "Z")
End Sub

Private Sub IsDigit(ch As String) As Boolean
    Return ch >= "0" And ch <= "9"
End Sub

Sub Utils_Initialize
End Sub
