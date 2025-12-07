B4J=true
Version=9.90
@EndOfDesignText@
#Region  Module Attributes 
    #ModuleVisibility: Public
#End Region

Sub Process_Globals
End Sub

Public Sub Initialize
    Log("Scaffolder module initialized")
End Sub

Sub InitScaffolder
    Scaffolder.Initialize
    InitTypeMapping
    InitFileGenerator
    InitTemplateEngine
    Log("Scaffolder initialized with all engines")
End Sub

Sub ParseFieldDefinitions(fieldsString As String) As List
    Dim fields As List
    fields.Initialize
    Dim lines() As String
    lines = fieldsString.Split(CRLF)
    Dim i As Int
    For i = 0 To lines.Length - 1
        Dim line As String = lines(i).Trim
        If line.Length > 0 And line.StartsWith("'") = False Then
            Dim parts() As String
            parts = line.Split(",")
            If parts.Length >= 2 Then
                Dim field As Map
                field.Initialize
                field.Put("name", parts(0).Trim)
                field.Put("type", parts(1).Trim)
                If parts.Length > 2 Then
                    field.Put("required", parts(2).Trim = "true")
                Else
                    field.Put("required", False)
                End If
                fields.Add(field)
            End If
        End If
    Next
    Return fields
End Sub

Sub GenerateModel(modelName As String, fields As List) As Boolean
    Try
        Log("Generating model: " & modelName)
        Dim context As Map
        context.Initialize
        context.Put("ModelName", modelName)
        context.Put("model_name", ConvertToSnakeCase(modelName))
        context.Put("modelName", modelName)
        Dim modelContent As String
        modelContent = GenerateModelClass(modelName, fields)
        Dim fileName As String = modelName & ".bas"
        Dim folderPath As String = "models"
        Return FileGenerator.CreateFile(folderPath, fileName, modelContent)
    Catch
        LogError("Error generating model: " & modelName, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateController(modelName As String, fields As List) As Boolean
    Try
        Log("Generating controller: " & modelName)
        Dim controllerName As String = modelName & "Controller"
        Dim controllerContent As String
        controllerContent = GenerateControllerClass(controllerName, modelName, fields)
        Dim fileName As String = controllerName & ".bas"
        Dim folderPath As String = "controllers"
        Return FileGenerator.CreateFile(folderPath, fileName, controllerContent)
    Catch
        LogError("Error generating controller: " & modelName, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateSQLSchema(modelName As String, fields As List) As Boolean
    Try
        Log("Generating SQL schema: " & modelName)
        Dim tableName As String = ConvertToSnakeCase(modelName)
        Dim schemaContent As String
        schemaContent = GenerateSQLCreateTable(tableName, fields)
        Dim fileName As String = tableName & ".sql"
        Dim folderPath As String = "sql"
        Return FileGenerator.CreateFile(folderPath, fileName, schemaContent)
    Catch
        LogError("Error generating SQL schema: " & modelName, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateDatabase(modelName As String, fields As List) As Boolean
    Try
        Log("Generating database initialization: " & modelName)
        Dim dbContent As String
        dbContent = GenerateDBInitCode(modelName, fields)
        Dim fileName As String = modelName & "DB.bas"
        Dim folderPath As String = "db"
        Return FileGenerator.CreateFile(folderPath, fileName, dbContent)
    Catch
        LogError("Error generating database code: " & modelName, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateTemplate(templateName As String, templateContent As String) As Boolean
    Try
        Log("Generating template: " & templateName)
        Dim fileName As String = templateName & ".html"
        Dim folderPath As String = "templates"
        Return FileGenerator.CreateFile(folderPath, fileName, templateContent)
    Catch
        LogError("Error generating template: " & templateName, LastException)
        Return False
    End TryCatch
End Sub

Sub GeneratePlatformSpecific(platformName As String, modelName As String, fields As List) As Boolean
    Try
        Log("Generating platform-specific code for: " & platformName & " model: " & modelName)
        Return PlatformGenerator.GeneratePlatformStructure(platformName, modelName, fields)
    Catch
        LogError("Error generating platform-specific code: " & platformName, LastException)
        Return False
    End TryCatch
End Sub

Sub ScaffoldProject(projectName As String, fieldsString As String) As Boolean
    Try
        Log("Starting project scaffolding: " & projectName)
        Dim fields As List = ParseFieldDefinitions(fieldsString)
        If fields.Size = 0 Then
            LogError("No fields parsed", Null)
            Return False
        End If
        Log("Parsed " & fields.Size & " fields")
        Dim success As Boolean = True
        success = success And GenerateModel(projectName, fields)
        success = success And GenerateController(projectName, fields)
        success = success And GenerateSQLSchema(projectName, fields)
        success = success And GenerateDatabase(projectName, fields)
        success = success And GenerateTemplate(projectName & "_list", "<table><!-- " & projectName & " table --></table>")
        
        'Generate for default platforms (B4A, B4I)
        Dim platforms As List
        platforms.Initialize
        platforms.Add("B4A")
        platforms.Add("B4I")
        success = success And PlatformGenerator.GenerateForMultiplePlatforms(platforms, projectName, fields)
        
        If success Then
            Log("Project scaffolding completed successfully")
        Else
            Log("Project scaffolding completed with errors")
        End If
        Return success
    Catch
        LogError("Error scaffolding project: " & projectName, LastException)
        Return False
    End TryCatch
End Sub

Sub ScaffoldProjectForPlatforms(projectName As String, fieldsString As String, platforms As List) As Boolean
    Try
        Log("Starting multi-platform project scaffolding: " & projectName)
        Dim fields As List = ParseFieldDefinitions(fieldsString)
        If fields.Size = 0 Then
            LogError("No fields parsed", Null)
            Return False
        End If
        Log("Parsed " & fields.Size & " fields for platforms: " & platforms.Size & " total")
        
        Dim success As Boolean = True
        success = success And GenerateModel(projectName, fields)
        success = success And GenerateController(projectName, fields)
        success = success And GenerateSQLSchema(projectName, fields)
        success = success And GenerateDatabase(projectName, fields)
        success = success And GenerateTemplate(projectName & "_list", "<table><!-- " & projectName & " table --></table>")
        
        'Generate for each specified platform
        success = success And PlatformGenerator.GenerateForMultiplePlatforms(platforms, projectName, fields)
        
        If success Then
            Log("Multi-platform project scaffolding completed successfully")
        Else
            Log("Multi-platform project scaffolding completed with errors")
        End If
        Return success
    Catch
        LogError("Error scaffolding multi-platform project: " & projectName, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateModelClass(modelName As String, fields As List) As String
    Dim code As String
    code = "'Model class for " & modelName & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "    Dim id As Long" & CRLF
    code = code & "    Dim createdAt As Long" & CRLF
    code = code & "    Dim updatedAt As Long" & CRLF
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        Dim fieldType As String = field.Get("type")
        Dim b4xType As String = GetB4XType(fieldType)
        code = code & "    Dim " & fieldName & " As " & b4xType & CRLF
    Next
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize" & CRLF
    code = code & "    createdAt = DateTime.Now" & CRLF
    code = code & "    updatedAt = DateTime.Now" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & TemplateEngine.GenerateFieldProperties(fields)
    Return code
End Sub

Sub GenerateControllerClass(controllerName As String, modelName As String, fields As List) As String
    Dim code As String
    code = "'Controller class for " & modelName & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "    Dim models As List" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize" & CRLF
    code = code & "    models.Initialize" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub GetAll As List" & CRLF
    code = code & "    Return models" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub GetById(id As Long) As Object" & CRLF
    code = code & "    Dim i As Int" & CRLF
    code = code & "    For i = 0 To models.Size - 1" & CRLF
    code = code & "        'Compare and return model" & CRLF
    code = code & "    Next" & CRLF
    code = code & "    Return Null" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Create(model As Object) As Boolean" & CRLF
    code = code & "    models.Add(model)" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Update(id As Long, model As Object) As Boolean" & CRLF
    code = code & "    'Update logic" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Delete(id As Long) As Boolean" & CRLF
    code = code & "    'Delete logic" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF
    Return code
End Sub

Sub GenerateSQLCreateTable(tableName As String, fields As List) As String
    Dim sql As String
    sql = "CREATE TABLE IF NOT EXISTS " & tableName & " (" & CRLF
    sql = sql & "    id BIGINT PRIMARY KEY AUTO_INCREMENT," & CRLF
    sql = sql & "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," & CRLF
    sql = sql & "    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," & CRLF
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = ConvertToSnakeCase(field.Get("name"))
        Dim fieldType As String = field.Get("type")
        Dim sqlType As String = GetSQLType(fieldType)
        Dim required As Boolean = field.Get("required")
        sql = sql & "    " & fieldName & " " & sqlType
        If required Then
            sql = sql & " NOT NULL"
        End If
        If i < fields.Size - 1 Then
            sql = sql & "," & CRLF
        Else
            sql = sql & CRLF
        End If
    Next
    sql = sql & ");" & CRLF
    Return sql
End Sub

Sub GenerateDBInitCode(modelName As String, fields As List) As String
    Dim code As String
    code = "'Database initialization for " & modelName & CRLF & CRLF
    code = code & "'Commented jRDC2 connection example:" & CRLF
    code = code & "'Dim rdc As RDCConnector" & CRLF
    code = code & "'rdc.Initialize2(Me, ""http://localhost:8080"", ""MyRDC"")" & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "    Dim sql As SQL" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize" & CRLF
    code = code & "    'Initialize database" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub CreateTable" & CRLF
    code = code & "    'Execute CREATE TABLE statement" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Query(queryString As String) As List" & CRLF
    code = code & "    'Execute query and return results" & CRLF
    code = code & "    Return Null" & CRLF
    code = code & "End Sub" & CRLF
    Return code
End Sub

Sub GenerateB4XCode(modelName As String, fields As List) As String
    Dim code As String
    code = "'B4X platform-specific code for " & modelName & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize" & CRLF
    code = code & "    'B4X initialization logic" & CRLF
    code = code & "End Sub" & CRLF
    Return code
End Sub

Sub GenerateB4ACode(modelName As String, fields As List) As String
    Dim code As String
    code = "'B4A platform-specific code for " & modelName & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "    Dim context As Context" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize(ctx As Context)" & CRLF
    code = code & "    context = ctx" & CRLF
    code = code & "    'B4A-specific initialization" & CRLF
    code = code & "End Sub" & CRLF
    Return code
End Sub

Sub GenerateB4ICode(modelName As String, fields As List) As String
    Dim code As String
    code = "'B4I platform-specific code for " & modelName & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    code = code & "Sub Initialize" & CRLF
    code = code & "    'B4I-specific initialization" & CRLF
    code = code & "End Sub" & CRLF
    Return code
End Sub

Sub ConvertToSnakeCase(text As String) As String
    Return TemplateEngine.ConvertToSnakeCase(text)
End Sub

Sub GetB4XType(fieldType As String) As String
    Return TypeMapping.GetB4XType(fieldType)
End Sub

Sub GetSQLType(fieldType As String) As String
    Return TypeMapping.GetSQLType(fieldType)
End Sub

Sub Scaffolder_Initialize
End Sub
