B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
    Private typeDefinitions As Map
    Private hasInitialized As Boolean
End Sub

Public Sub Initialize(definitions As Map)
    typeDefinitions = definitions
    hasInitialized = True
End Sub

Public Sub InitTypeMapping
    If hasInitialized = False Then Initialize(CreateDefaultDefinitions)
    Log("TypeMapping initialized with " & typeDefinitions.Size & " entries")
End Sub

Public Sub GetSQLType(fieldType As String) As String
    EnsureInitialized
    Dim mapping As Map = GetDefinition(fieldType)
    Return mapping.Get("sql")
End Sub

Public Sub GetB4XType(fieldType As String) As String
    EnsureInitialized
    Dim mapping As Map = GetDefinition(fieldType)
    Return mapping.Get("b4x")
End Sub

Private Sub EnsureInitialized
    If hasInitialized = False Then Initialize(CreateDefaultDefinitions)
End Sub

Private Sub GetDefinition(fieldType As String) As Map
    Dim key As String = fieldType.ToLowerCase
    If typeDefinitions.ContainsKey(key) Then
        Return typeDefinitions.Get(key)
    End If
    Return CreateMap("sql": "VARCHAR(255)", "b4x": "String")
End Sub

Private Sub CreateDefaultDefinitions As Map
    Return CreateMap( _
        "string": CreateMap("sql": "VARCHAR(255)", "b4x": "String"), _
        "int": CreateMap("sql": "INTEGER", "b4x": "Int"), _
        "long": CreateMap("sql": "BIGINT", "b4x": "Long"), _
        "double": CreateMap("sql": "DOUBLE", "b4x": "Double"), _
        "float": CreateMap("sql": "FLOAT", "b4x": "Float"), _
        "boolean": CreateMap("sql": "BOOLEAN", "b4x": "Boolean"), _
        "date": CreateMap("sql": "TIMESTAMP", "b4x": "Long"), _
        "text": CreateMap("sql": "TEXT", "b4x": "String"), _
        "decimal": CreateMap("sql": "DECIMAL(10,2)", "b4x": "Double"), _
        "uuid": CreateMap("sql": "VARCHAR(36)", "b4x": "String"))
End Sub

Sub TypeMapping_Initialize
End Sub
