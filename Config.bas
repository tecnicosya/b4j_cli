B4J=true@Version=9.90@End=
Sub Process_Globals
End Sub

Sub InitConfig
    Config.Initialize
    Log("Config system initialized" & CRLF)
End Sub

Sub GetConfig As Map
    Dim configMap As Map
    configMap.Initialize
    configMap.Put("modelPath", "models")
    configMap.Put("controllerPath", "controllers")
    configMap.Put("sqlPath", "sql")
    configMap.Put("dbPath", "db")
    configMap.Put("templatePath", "templates")
    configMap.Put("platformPath", "platforms")
    configMap.Put("dbHost", "localhost")
    configMap.Put("dbPort", 3306)
    configMap.Put("dbUser", "root")
    configMap.Put("dbPassword", "")
    configMap.Put("dbName", "scaffolder_db")
    configMap.Put("CRLF", Chr(13) & Chr(10))
    Return configMap
End Sub

Sub GetModelPath As String
    Return "models"
End Sub

Sub GetControllerPath As String
    Return "controllers"
End Sub

Sub GetSQLPath As String
    Return "sql"
End Sub

Sub GetDBPath As String
    Return "db"
End Sub

Sub GetTemplatePath As String
    Return "templates"
End Sub

Sub GetPlatformPath As String
    Return "platforms"
End Sub

Sub GetRDC2ServerURL As String
    Return "http://localhost:8080"
End Sub

Sub GetRDC2ServiceName As String
    Return "ScaffolderRDC"
End Sub

Sub GetCRLF As String
    Return Chr(13) & Chr(10)
End Sub

Sub Config_Initialize
End Sub