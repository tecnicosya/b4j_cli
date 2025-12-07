B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
    Private configValues As Map
    Private hasInitialized As Boolean
End Sub

Public Sub Initialize
    If hasInitialized Then Return
    configValues = CreateDefaultConfig
    hasInitialized = True
End Sub

Public Sub InitConfig
    EnsureInitialized
    Log("Config system initialized")
End Sub

Public Sub GetConfig As Map
    EnsureInitialized
    Return configValues
End Sub

Public Sub GetModelPath As String
    EnsureInitialized
    Return configValues.Get("modelPath")
End Sub

Public Sub GetControllerPath As String
    EnsureInitialized
    Return configValues.Get("controllerPath")
End Sub

Public Sub GetSQLPath As String
    EnsureInitialized
    Return configValues.Get("sqlPath")
End Sub

Public Sub GetDBPath As String
    EnsureInitialized
    Return configValues.Get("dbPath")
End Sub

Public Sub GetTemplatePath As String
    EnsureInitialized
    Return configValues.Get("templatePath")
End Sub

Public Sub GetPlatformPath As String
    EnsureInitialized
    Return configValues.Get("platformPath")
End Sub

Public Sub GetRDC2ServerURL As String
    EnsureInitialized
    Return configValues.Get("rdc2ServerUrl")
End Sub

Public Sub GetRDC2ServiceName As String
    EnsureInitialized
    Return configValues.Get("rdc2ServiceName")
End Sub

Public Sub GetCRLF As String
    Return Chr(13) & Chr(10)
End Sub

Private Sub EnsureInitialized
    If hasInitialized = False Then Initialize
End Sub

Private Sub CreateDefaultConfig As Map
    Dim defaults As Map
    defaults.Initialize
    defaults.Put("modelPath", "models")
    defaults.Put("controllerPath", "controllers")
    defaults.Put("sqlPath", "sql")
    defaults.Put("dbPath", "db")
    defaults.Put("templatePath", "templates")
    defaults.Put("platformPath", "platforms")
    defaults.Put("dbHost", "localhost")
    defaults.Put("dbPort", 3306)
    defaults.Put("dbUser", "root")
    defaults.Put("dbPassword", "")
    defaults.Put("dbName", "scaffolder_db")
    defaults.Put("rdc2ServerUrl", "http://localhost:8080")
    defaults.Put("rdc2ServiceName", "ScaffolderRDC")
    defaults.Put("crlf", Chr(13) & Chr(10))
    Return defaults
End Sub

Sub Config_Initialize
End Sub
