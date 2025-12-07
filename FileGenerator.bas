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

Public Sub InitFileGenerator
    EnsureInitialized
    Log("FileGenerator initialized")
End Sub

Public Sub CreateDirectoryIdempotent(folderPath As String) As Boolean
    EnsureInitialized
    Try
        EnsureRelativeDirectory(folderPath)
        Return True
    Catch
        LogError("Error creating directory: " & folderPath, LastException)
        Return False
    End Try
End Sub

Public Sub CreateFile(folderPath As String, fileName As String, content As String) As Boolean
    EnsureInitialized
    Try
        If fileName.Length = 0 Then Return False
        Dim targetDir As String = EnsureRelativeDirectory(folderPath)
        File.WriteString(targetDir, fileName, NormalizeContent(content))
        Log("Created file: " & targetDir & "/" & fileName)
        Return True
    Catch
        LogError("Error creating file: " & fileName, LastException)
        Return False
    End Try
End Sub

Public Sub CreateMultipleFiles(basePath As String, files As Map) As Int
    EnsureInitialized
    Dim successCount As Int = 0
    Dim iterator As Iterator = files.Keys.Iterator
    While iterator.HasNext
        Dim fileName As String = iterator.Next
        Dim content As String = files.Get(fileName)
        If CreateFile(basePath, fileName, content) Then
            successCount = successCount + 1
        End If
    Wend
    Return successCount
End Sub

Public Sub WriteToFile(filePath As String, content As String) As Boolean
    EnsureInitialized
    Try
        Dim pathInfo As Map = SplitPath(filePath)
        Dim targetDir As String = EnsureRelativeDirectory(pathInfo.Get("directory"))
        Dim fileName As String = pathInfo.Get("file")
        If fileName.Length = 0 Then Return False
        File.WriteString(targetDir, fileName, NormalizeContent(content))
        Log("Wrote to file: " & targetDir & "/" & fileName)
        Return True
    Catch
        LogError("Error writing to file: " & filePath, LastException)
        Return False
    End Try
End Sub

Public Sub ReadFromFile(filePath As String) As String
    EnsureInitialized
    Try
        Dim pathInfo As Map = SplitPath(filePath)
        Dim dir As String = BuildAbsolutePath(pathInfo.Get("directory"))
        Dim fileName As String = pathInfo.Get("file")
        If fileName.Length = 0 Then Return ""
        If File.Exists(dir, fileName) = False Then Return ""
        Dim reader As TextReader
        reader.Initialize(File.OpenInput(dir, fileName))
        Dim builder As StringBuilder
        builder.Initialize
        Dim line As String
        Do While True
            line = reader.ReadLine
            If line = Null Then Exit
            builder.Append(line).Append(Chr(13) & Chr(10))
        Loop
        reader.Close
        Return builder.ToString
    Catch
        LogError("Error reading file: " & filePath, LastException)
        Return ""
    End Try
End Sub

Private Sub EnsureInitialized
    If isInitialized = False Then Initialize
End Sub

Private Sub EnsureRelativeDirectory(folderPath As String) As String
    Dim normalized As String = NormalizePath(folderPath)
    Dim currentDir As String = File.DirApp
    If normalized.Length = 0 Then Return currentDir
    Dim parts() As String = normalized.Split("/")
    Dim i As Int
    For i = 0 To parts.Length - 1
        Dim part As String = parts(i)
        If part.Length = 0 Then Continue
        If File.Exists(currentDir, part) = False Then
            File.MakeDir(currentDir, part)
        End If
        currentDir = currentDir & "/" & part
    Next
    Return currentDir
End Sub

Private Sub BuildAbsolutePath(folderPath As String) As String
    Dim normalized As String = NormalizePath(folderPath)
    If normalized.Length = 0 Then Return File.DirApp
    Return File.DirApp & "/" & normalized
End Sub

Private Sub SplitPath(filePath As String) As Map
    Dim normalized As String = NormalizePath(filePath)
    Dim result As Map
    result.Initialize
    If normalized.Length = 0 Then
        result.Put("directory", "")
        result.Put("file", "")
        Return result
    End If
    Dim lastSlash As Int = normalized.LastIndexOf("/")
    If lastSlash = -1 Then
        result.Put("directory", "")
        result.Put("file", normalized)
    Else
        result.Put("directory", normalized.SubString2(0, lastSlash))
        result.Put("file", normalized.SubString(lastSlash + 1))
    End If
    Return result
End Sub

Private Sub NormalizePath(path As String) As String
    If path = Null Then Return ""
    Dim normalized As String = path.Replace("\\", "/")
    normalized = normalized.Trim
    If normalized.StartsWith("/") Then normalized = normalized.SubString(1)
    If normalized.EndsWith("/") And normalized.Length > 1 Then normalized = normalized.SubString2(0, normalized.Length - 1)
    Return normalized
End Sub

Private Sub NormalizeContent(content As String) As String
    If content = Null Then Return ""
    Dim normalized As String = content.Replace(Chr(13), "")
    normalized = normalized.Replace(Chr(10), Chr(13) & Chr(10))
    Return normalized
End Sub

Sub FileGenerator_Initialize
End Sub
