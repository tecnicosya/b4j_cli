B4J=true@Version=9.90@End=Sub Process_GlobalsEnd Sub

Sub AppStart (Args() As String)
    If Args.Length = 0 Then
        PrintUsage
        Return
    End If
    
    InitLogging
    InitConfig
    InitScaffolder
    InitPlatformGenerator
    
    Dim command As String = Args(0).ToLowerCase
    
    Select command
        Case "scaffold"
            If Args.Length < 3 Then
                PrintError("Usage: b4x-cli scaffold <modelName> <fields>")
                Return
            End If
            Dim modelName As String = Args(1)
            Dim fields As String = Args(2)
            Dim success As Boolean = Scaffolder.ScaffoldProject(modelName, fields)
            If success Then
                Log("Project scaffolded successfully")
            Else
                LogError("Project scaffolding failed", Null)
            End If
            
        Case "scaffold-platforms"
            If Args.Length < 4 Then
                PrintError("Usage: b4x-cli scaffold-platforms <modelName> <fields> <platform1,platform2,...>")
                Return
            End If
            Dim modelName As String = Args(1)
            Dim fields As String = Args(2)
            Dim platformsStr As String = Args(3)
            Dim platformList As List = ParsePlatforms(platformsStr)
            Dim success As Boolean = Scaffolder.ScaffoldProjectForPlatforms(modelName, fields, platformList)
            If success Then
                Log("Multi-platform project scaffolded successfully")
            Else
                LogError("Multi-platform project scaffolding failed", Null)
            End If
            
        Case Else
            PrintError("Unknown command: " & command)
            PrintUsage
    End Select
    
End Sub

Sub ParsePlatforms(platformsStr As String) As List
    Dim platforms As List
    platforms.Initialize
    Dim parts() As String
    parts = platformsStr.Split(",")
    Dim i As Int
    For i = 0 To parts.Length - 1
        platforms.Add(parts(i).Trim)
    Next
    Return platforms
End Sub

Sub PrintUsage
    Print("B4X CLI - Scaffolding Engine")
    Print("")
    Print("Usage:")
    Print("  scaffold <modelName> <fields>")
    Print("    Generate project with default platforms (B4A, B4I)")
    Print("")
    Print("  scaffold-platforms <modelName> <fields> <platforms>")
    Print("    Generate project for specific platforms (comma-separated)")
    Print("")
    Print("Supported platforms: B4A, B4I, B4J, web, hybrid, all")
    Print("")
    Print("Field format: fieldName,fieldType[,required]")
    Print("Example: username,string,true email,string,true age,int,false")
End Sub

Sub PrintError(message As String)
    Print("ERROR: " & message)
    LogError(message, Null)
End Sub
