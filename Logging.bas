B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
    Private Const LOG_DIRECTORY As String = "logs"
    Private Const INFO_LOG As String = "scaffolder.log"
    Private Const ERROR_LOG As String = "scaffolder_errors.log"
    Private hasInitialized As Boolean
End Sub

Public Sub Initialize
    If hasInitialized Then Return
    EnsureLogDirectory
    hasInitialized = True
End Sub

Public Sub InitLogging
    Initialize
    Log("Logging system initialized")
End Sub

Public Sub Log(message As String)
    WriteEntry(INFO_LOG, "[INFO]", message)
End Sub

Public Sub LogWarning(message As String)
    WriteEntry(INFO_LOG, "[WARN]", message)
End Sub

Public Sub LogError(message As String, exception As Exception)
    Dim details As String = message
    If exception <> Null Then
        details = details & " - Exception: " & exception.Message
    End If
    WriteEntry(ERROR_LOG, "[ERROR]", details)
End Sub

Private Sub WriteEntry(fileName As String, level As String, message As String)
    Initialize
    Dim entry As String = BuildEntry(level, message)
    Try
        Dim stream As OutputStream = File.OpenOutput(GetLogDir, fileName, True)
        Dim writer As TextWriter
        writer.Initialize(stream)
        writer.WriteLine(entry)
        writer.Close
    Catch
        Print(entry)
    End Try
End Sub

Private Sub BuildEntry(level As String, message As String) As String
    Dim now As Long = DateTime.Now
    Dim datePart As String = DateTime.GetDate(now)
    Dim timePart As String = DateTime.GetTime(now)
    Return "[" & datePart & " " & timePart & "] " & level & " " & message
End Sub

Private Sub EnsureLogDirectory
    If File.Exists(File.DirApp, LOG_DIRECTORY) = False Then
        File.MakeDir(File.DirApp, LOG_DIRECTORY)
    End If
End Sub

Private Sub GetLogDir As String
    EnsureLogDirectory
    Return File.DirApp & "/" & LOG_DIRECTORY
End Sub

Sub Logging_Initialize
End Sub
