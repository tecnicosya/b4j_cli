B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
    Private isInitialized As Boolean
End Sub

Public Sub Initialize
    If isInitialized Then Return
    isInitialized = True
End Sub

Public Sub InitTemplateEngine
    Initialize
    Log("TemplateEngine initialized")
End Sub

Public Sub EvaluateTemplate(template As String, context As Map) As String
    If template = Null Then Return ""
    Dim result As String = template
    Try
        Dim iterator As Iterator = context.Keys.Iterator
        While iterator.HasNext
            Dim key As String = iterator.Next
            Dim value As String = context.Get(key)
            result = ReplaceToken(result, key, value)
        Wend
        Return result
    Catch
        LogError("Error evaluating template", LastException)
        Return template
    End Try
End Sub

Public Sub ConvertToCamelCase(text As String) As String
    If text = Null Then Return ""
    Dim parts() As String = text.ToLowerCase.Split("_")
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To parts.Length - 1
        Dim part As String = parts(i)
        If part.Length = 0 Then Continue
        If i = 0 Then
            builder.Append(part)
        Else
            builder.Append(part.SubString2(0, 1).ToUpperCase).Append(part.SubString(1))
        End If
    Next
    Return builder.ToString
End Sub

Public Sub ConvertToSnakeCase(text As String) As String
    If text = Null Then Return ""
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To text.Length - 1
        Dim ch As String = text.CharAt(i)
        If ch = ch.ToUpperCase And ch <> ch.ToLowerCase And i > 0 Then
            builder.Append("_").Append(ch.ToLowerCase)
        Else
            builder.Append(ch.ToLowerCase)
        End If
    Next
    Return builder.ToString
End Sub

Public Sub ExpandFieldsTemplate(fields As List) As String
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        Dim fieldType As String = field.Get("type")
        builder.Append("    Dim ").Append(fieldName).Append(" As ").Append(fieldType).Append(CRLF)
    Next
    Return builder.ToString
End Sub

Public Sub GenerateFieldProperties(fields As List) As String
    Dim builder As StringBuilder
    builder.Initialize
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        Dim fieldType As String = field.Get("type")
        Dim capitalizedName As String = fieldName.SubString2(0, 1).ToUpperCase & fieldName.SubString(1)
        builder.Append("Sub Get").Append(capitalizedName).Append(" As ").Append(fieldType).Append(CRLF)
        builder.Append("    Return ").Append(fieldName).Append(CRLF)
        builder.Append("End Sub").Append(CRLF).Append(CRLF)
        builder.Append("Sub Set").Append(capitalizedName).Append("(value As ").Append(fieldType).Append(")").Append(CRLF)
        builder.Append("    ").Append(fieldName).Append(" = value").Append(CRLF)
        builder.Append("End Sub").Append(CRLF).Append(CRLF)
    Next
    Return builder.ToString
End Sub

Private Sub ReplaceToken(content As String, key As String, value As String) As String
    Dim snakeKey As String = ConvertToSnakeCase(key)
    Dim camelKey As String = ConvertToCamelCase(key)
    Dim result As String = content.Replace("{{" & key & "}}", value)
    result = result.Replace("{{" & camelKey & "}}", value)
    result = result.Replace("{{" & snakeKey & "}}", ConvertToSnakeCase(value))
    Return result
End Sub

Sub TemplateEngine_Initialize
End Sub
