B4J=true@Version=9.90@End=Sub Process_GlobalsEnd Sub

Sub InitPlatformGenerator
    Log("PlatformGenerator initialized")
End Sub

Sub GenerateCRUDController(platform As String, modelName As String, fields As List) As String
    Dim code As String
    code = "'CRUD Controller for " & modelName & " - Platform: " & platform & CRLF & CRLF
    code = code & "Sub Class_Globals" & CRLF
    code = code & "    Dim db As Object" & CRLF
    code = code & "    Dim models As List" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub Initialize(database As Object)" & CRLF
    code = code & "    db = database" & CRLF
    code = code & "    models.Initialize" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub GetAll As List" & CRLF
    code = code & "    Return models" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub GetById(id As Long) As Object" & CRLF
    code = code & "    Dim i As Int" & CRLF
    code = code & "    For i = 0 To models.Size - 1" & CRLF
    code = code & "        'Implement record lookup" & CRLF
    code = code & "    Next" & CRLF
    code = code & "    Return Null" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub Create(model As Object) As Boolean" & CRLF
    code = code & "    'Implement create logic with database persistence" & CRLF
    code = code & "    models.Add(model)" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub Update(id As Long, model As Object) As Boolean" & CRLF
    code = code & "    'Implement update logic with database persistence" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF & CRLF
    
    code = code & "Sub Delete(id As Long) As Boolean" & CRLF
    code = code & "    'Implement delete logic with database persistence" & CRLF
    code = code & "    Return True" & CRLF
    code = code & "End Sub" & CRLF
    
    Return code
End Sub

Sub GenerateSQLSchema(modelName As String, fields As List) As String
    Dim tableName As String = ConvertToSnakeCase(modelName)
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

Sub GenerateJRDC2Config(modelName As String, serverURL As String, serviceName As String) As String
    Dim config As String
    config = "'jRDC2 Configuration for " & modelName & CRLF & CRLF
    config = config & "'--- Database Connection ---" & CRLF
    config = config & "'Driver=com.mysql.jdbc.Driver" & CRLF
    config = config & "'JdbcUrl=jdbc:mysql://localhost:3306/database_name" & CRLF
    config = config & "'User=root" & CRLF
    config = config & "'Password=" & CRLF & CRLF
    
    config = config & "'--- jRDC2 Server Configuration ---" & CRLF
    config = config & "'ServerURL: " & serverURL & CRLF
    config = config & "'ServiceName: " & serviceName & CRLF & CRLF
    
    config = config & "'--- Usage Example ---" & CRLF
    config = config & "'Dim rdc As RDCConnector" & CRLF
    config = config & "'rdc.Initialize2(Me, """ & serverURL & """, """ & serviceName & """)" & CRLF
    config = config & "'Dim result As List = rdc.ExecuteQuery(""SELECT * FROM " & ConvertToSnakeCase(modelName) & """)" & CRLF
    
    Return config
End Sub

Sub GenerateNativeLayoutBAL(modelName As String, fields As List) As String
    Dim layout As String
    layout = "<?xml version=""1.0"" encoding=""utf-8""?>" & CRLF
    layout = layout & "<LinearLayout xmlns:android=""http://schemas.android.com/apk/res/android""" & CRLF
    layout = layout & "    android:layout_width=""match_parent""" & CRLF
    layout = layout & "    android:layout_height=""match_parent""" & CRLF
    layout = layout & "    android:orientation=""vertical""" & CRLF
    layout = layout & "    android:padding=""16dp"">" & CRLF & CRLF
    
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        Dim fieldType As String = field.Get("type")
        
        layout = layout & "    <TextView" & CRLF
        layout = layout & "        android:id=""@+id/label_" & fieldName & """" & CRLF
        layout = layout & "        android:layout_width=""match_parent""" & CRLF
        layout = layout & "        android:layout_height=""wrap_content""" & CRLF
        layout = layout & "        android:text=""" & fieldName & """" & CRLF
        layout = layout & "        android:textStyle=""bold"" />" & CRLF & CRLF
        
        layout = layout & "    <EditText" & CRLF
        layout = layout & "        android:id=""@+id/edit_" & fieldName & """" & CRLF
        layout = layout & "        android:layout_width=""match_parent""" & CRLF
        layout = layout & "        android:layout_height=""wrap_content""" & CRLF
        layout = layout & "        android:layout_marginBottom=""8dp""" & CRLF
        
        Select fieldType
            Case "int", "long"
                layout = layout & "        android:inputType=""number"""
            Case "double", "float", "decimal"
                layout = layout & "        android:inputType=""numberDecimal"""
            Case "email"
                layout = layout & "        android:inputType=""textEmailAddress"""
            Case Else
                layout = layout & "        android:inputType=""text"""
        End Select
        layout = layout & " />" & CRLF & CRLF
    Next
    
    layout = layout & "    <Button" & CRLF
    layout = layout & "        android:id=""@+id/btn_save""" & CRLF
    layout = layout & "        android:layout_width=""match_parent""" & CRLF
    layout = layout & "        android:layout_height=""wrap_content""" & CRLF
    layout = layout & "        android:text=""Save"" />" & CRLF & CRLF
    
    layout = layout & "    <Button" & CRLF
    layout = layout & "        android:id=""@+id/btn_cancel""" & CRLF
    layout = layout & "        android:layout_width=""match_parent""" & CRLF
    layout = layout & "        android:layout_height=""wrap_content""" & CRLF
    layout = layout & "        android:text=""Cancel"" />" & CRLF & CRLF
    
    layout = layout & "</LinearLayout>" & CRLF
    
    Return layout
End Sub

Sub GenerateB4XPageLayout(modelName As String, fields As List) As String
    Dim layout As String
    layout = "'B4XPage layout for " & modelName & CRLF
    layout = layout & "'Add UI controls in the DesignerCreateView event" & CRLF & CRLF
    layout = layout & "Sub Class_Globals" & CRLF
    layout = layout & "    Dim Root As B4XView" & CRLF
    layout = layout & "    Dim xui As XUI" & CRLF
    
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        layout = layout & "    Dim " & fieldName & "_field As B4XView" & CRLF
    Next
    
    layout = layout & "End Sub" & CRLF & CRLF
    
    layout = layout & "Public Sub Initialize" & CRLF
    layout = layout & "    B4XPages.GetManager.LogEvents = True" & CRLF
    layout = layout & "End Sub" & CRLF & CRLF
    
    layout = layout & "Private Sub B4XPage_Created (Root1 As B4XView)" & CRLF
    layout = layout & "    Root = Root1" & CRLF
    layout = layout & "    Root.LoadLayout(""" & ConvertToSnakeCase(modelName) & """)" & CRLF
    layout = layout & "End Sub" & CRLF
    
    Return layout
End Sub

Sub GenerateWebJServerHandler(modelName As String, fields As List) As String
    Dim handler As String
    handler = "'Web jServer handler for " & modelName & CRLF & CRLF
    handler = handler & "Sub Class_Globals" & CRLF
    handler = handler & "    Dim server As HttpServer" & CRLF
    handler = handler & "    Dim controller As Object" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub Initialize(HttpServer As HttpServer, controller As Object)" & CRLF
    handler = handler & "    server = HttpServer" & CRLF
    handler = handler & "    controller = controller" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub Handle(req As HttpRequest) As Object" & CRLF
    handler = handler & "    Select req.Method" & CRLF
    handler = handler & "        Case ""GET""" & CRLF
    handler = handler & "            Return HandleGet(req)" & CRLF
    handler = handler & "        Case ""POST""" & CRLF
    handler = handler & "            Return HandlePost(req)" & CRLF
    handler = handler & "        Case ""PUT""" & CRLF
    handler = handler & "            Return HandlePut(req)" & CRLF
    handler = handler & "        Case ""DELETE""" & CRLF
    handler = handler & "            Return HandleDelete(req)" & CRLF
    handler = handler & "    End Select" & CRLF
    handler = handler & "    Return CreateResponse(400, ""Bad Request"")" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub HandleGet(req As HttpRequest) As Object" & CRLF
    handler = handler & "    'GET /api/" & ConvertToSnakeCase(modelName) & " - List all" & CRLF
    handler = handler & "    'GET /api/" & ConvertToSnakeCase(modelName) & "/:id - Get by ID" & CRLF
    handler = handler & "    Return CreateResponse(200, ""[]"")" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub HandlePost(req As HttpRequest) As Object" & CRLF
    handler = handler & "    'POST /api/" & ConvertToSnakeCase(modelName) & " - Create new" & CRLF
    handler = handler & "    Return CreateResponse(201, ""{}"")" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub HandlePut(req As HttpRequest) As Object" & CRLF
    handler = handler & "    'PUT /api/" & ConvertToSnakeCase(modelName) & "/:id - Update" & CRLF
    handler = handler & "    Return CreateResponse(200, ""{}"")" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub HandleDelete(req As HttpRequest) As Object" & CRLF
    handler = handler & "    'DELETE /api/" & ConvertToSnakeCase(modelName) & "/:id - Delete" & CRLF
    handler = handler & "    Return CreateResponse(204, """")" & CRLF
    handler = handler & "End Sub" & CRLF & CRLF
    
    handler = handler & "Sub CreateResponse(statusCode As Int, content As String) As HttpResponse" & CRLF
    handler = handler & "    Dim resp As HttpResponse" & CRLF
    handler = handler & "    resp.Initialize" & CRLF
    handler = handler & "    resp.Status = statusCode" & CRLF
    handler = handler & "    resp.ContentType = ""application/json""" & CRLF
    handler = handler & "    resp.Write(content)" & CRLF
    handler = handler & "    Return resp" & CRLF
    handler = handler & "End Sub" & CRLF
    
    Return handler
End Sub

Sub GenerateWebRouter(modelName As String) As String
    Dim router As String
    router = "'Web router for " & modelName & CRLF & CRLF
    router = router & "'Route mapping:" & CRLF
    router = router & "'GET    /api/" & ConvertToSnakeCase(modelName) & "          -> List all" & CRLF
    router = router & "'GET    /api/" & ConvertToSnakeCase(modelName) & "/:id      -> Get by ID" & CRLF
    router = router & "'POST   /api/" & ConvertToSnakeCase(modelName) & "          -> Create new" & CRLF
    router = router & "'PUT    /api/" & ConvertToSnakeCase(modelName) & "/:id      -> Update" & CRLF
    router = router & "'DELETE /api/" & ConvertToSnakeCase(modelName) & "/:id      -> Delete" & CRLF & CRLF
    
    router = router & "'Web UI routes:" & CRLF
    router = router & "'GET    /web/" & ConvertToSnakeCase(modelName) & "          -> List view" & CRLF
    router = router & "'GET    /web/" & ConvertToSnakeCase(modelName) & "/new      -> Create form" & CRLF
    router = router & "'GET    /web/" & ConvertToSnakeCase(modelName) & "/:id/edit -> Edit form" & CRLF & CRLF
    
    router = router & "Sub InitializeRoutes(server As HttpServer, controller As Object)" & CRLF
    router = router & "    'Register API routes" & CRLF
    router = router & "    server.AddHandler(""/api/" & ConvertToSnakeCase(modelName) & """, """ & modelName & "Handler"")" & CRLF
    router = router & "    'Register Web UI routes" & CRLF
    router = router & "    server.AddHandler(""/web/" & ConvertToSnakeCase(modelName) & """, """ & modelName & "WebHandler"")" & CRLF
    router = router & "End Sub" & CRLF
    
    Return router
End Sub

Sub GenerateWebHTMLForm(modelName As String, fields As List) As String
    Dim html As String
    html = "<!DOCTYPE html>" & CRLF
    html = html & "<html>" & CRLF
    html = html & "<head>" & CRLF
    html = html & "    <meta charset=""UTF-8"">" & CRLF
    html = html & "    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">" & CRLF
    html = html & "    <title>" & modelName & " Form</title>" & CRLF
    html = html & "    <link rel=""stylesheet"" href=""/assets/css/styles.css"">" & CRLF
    html = html & "</head>" & CRLF
    html = html & "<body>" & CRLF
    html = html & "    <div class=""container"">" & CRLF
    html = html & "        <h1>" & modelName & " Form</h1>" & CRLF
    html = html & "        <form id=""" & ConvertToSnakeCase(modelName) & "_form"" method=""POST"">" & CRLF
    
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        Dim fieldType As String = field.Get("type")
        Dim required As Boolean = field.Get("required")
        
        html = html & "            <div class=""form-group"">" & CRLF
        html = html & "                <label for=""" & fieldName & """>" & fieldName & ""
        If required Then
            html = html & " *"
        End If
        html = html & "</label>" & CRLF
        
        Select fieldType
            Case "text", "long"
                html = html & "                <textarea id=""" & fieldName & """ name=""" & fieldName & """"
            Case "int", "long", "double", "float", "decimal"
                html = html & "                <input type=""number"" id=""" & fieldName & """ name=""" & fieldName & """"
            Case Else
                html = html & "                <input type=""text"" id=""" & fieldName & """ name=""" & fieldName & """"
        End Select
        
        If required Then
            html = html & " required"
        End If
        
        If fieldType = "text" Then
            html = html & "></textarea>" & CRLF
        Else
            html = html & "></" & ">" & CRLF
        End If
        
        html = html & "            </div>" & CRLF & CRLF
    Next
    
    html = html & "            <div class=""form-actions"">" & CRLF
    html = html & "                <button type=""submit"" class=""btn btn-primary"">Save</button>" & CRLF
    html = html & "                <button type=""button"" class=""btn btn-secondary"" onclick=""history.back()"">Cancel</button>" & CRLF
    html = html & "            </div>" & CRLF
    html = html & "        </form>" & CRLF
    html = html & "    </div>" & CRLF
    html = html & "    <script src=""/assets/js/app.js""></script>" & CRLF
    html = html & "</body>" & CRLF
    html = html & "</html>" & CRLF
    
    Return html
End Sub

Sub GenerateWebHTMLList(modelName As String, fields As List) As String
    Dim html As String
    html = "<!DOCTYPE html>" & CRLF
    html = html & "<html>" & CRLF
    html = html & "<head>" & CRLF
    html = html & "    <meta charset=""UTF-8"">" & CRLF
    html = html & "    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">" & CRLF
    html = html & "    <title>" & modelName & " List</title>" & CRLF
    html = html & "    <link rel=""stylesheet"" href=""/assets/css/styles.css"">" & CRLF
    html = html & "</head>" & CRLF
    html = html & "<body>" & CRLF
    html = html & "    <div class=""container"">" & CRLF
    html = html & "        <h1>" & modelName & " List</h1>" & CRLF
    html = html & "        <a href=""/web/" & ConvertToSnakeCase(modelName) & "/new"" class=""btn btn-primary"">Add New</a>" & CRLF
    html = html & "        <table class=""table table-striped"">" & CRLF
    html = html & "            <thead>" & CRLF
    html = html & "                <tr>" & CRLF
    html = html & "                    <th>ID</th>" & CRLF
    
    Dim i As Int
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        html = html & "                    <th>" & fieldName & "</th>" & CRLF
    Next
    
    html = html & "                    <th>Actions</th>" & CRLF
    html = html & "                </tr>" & CRLF
    html = html & "            </thead>" & CRLF
    html = html & "            <tbody id=""table_body"">" & CRLF
    html = html & "                <!-- Rows will be populated by JavaScript -->" & CRLF
    html = html & "            </tbody>" & CRLF
    html = html & "        </table>" & CRLF
    html = html & "    </div>" & CRLF
    html = html & "    <script src=""/assets/js/app.js""></script>" & CRLF
    html = html & "    <script>" & CRLF
    html = html & "        document.addEventListener('DOMContentLoaded', function() {" & CRLF
    html = html & "            fetch('/api/" & ConvertToSnakeCase(modelName) & "')" & CRLF
    html = html & "                .then(response => response.json())" & CRLF
    html = html & "                .then(data => populateTable(data));" & CRLF
    html = html & "        });" & CRLF & CRLF
    html = html & "        function populateTable(items) {" & CRLF
    html = html & "            const tbody = document.getElementById('table_body');" & CRLF
    html = html & "            items.forEach(item => {" & CRLF
    html = html & "                const row = document.createElement('tr');" & CRLF
    html = html & "                row.innerHTML = `" & CRLF
    html = html & "                    <td>${item.id}</td>" & CRLF
    
    For i = 0 To fields.Size - 1
        Dim field As Map = fields.Get(i)
        Dim fieldName As String = field.Get("name")
        html = html & "                    <td>${item." & fieldName & "}</td>" & CRLF
    Next
    
    html = html & "                    <td>" & CRLF
    html = html & "                        <a href=""/web/" & ConvertToSnakeCase(modelName) & "/${item.id}/edit"">Edit</a>" & CRLF
    html = html & "                        <a href=""javascript:deleteItem(${item.id})"">Delete</a>" & CRLF
    html = html & "                    </td>" & CRLF
    html = html & "                `;" & CRLF
    html = html & "                tbody.appendChild(row);" & CRLF
    html = html & "            });" & CRLF
    html = html & "        }" & CRLF
    html = html & "    </script>" & CRLF
    html = html & "</body>" & CRLF
    html = html & "</html>" & CRLF
    
    Return html
End Sub

Sub GenerateWebCSS As String
    Dim css As String
    css = "/* Web styles for " & DateTime.GetDate(DateTime.Now) & " */" & CRLF & CRLF
    
    css = css & "* {" & CRLF
    css = css & "    margin: 0;" & CRLF
    css = css & "    padding: 0;" & CRLF
    css = css & "    box-sizing: border-box;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & "body {" & CRLF
    css = css & "    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;" & CRLF
    css = css & "    line-height: 1.6;" & CRLF
    css = css & "    color: #333;" & CRLF
    css = css & "    background-color: #f4f4f4;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".container {" & CRLF
    css = css & "    max-width: 1200px;" & CRLF
    css = css & "    margin: 0 auto;" & CRLF
    css = css & "    padding: 20px;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".btn {" & CRLF
    css = css & "    padding: 10px 20px;" & CRLF
    css = css & "    border: none;" & CRLF
    css = css & "    border-radius: 4px;" & CRLF
    css = css & "    cursor: pointer;" & CRLF
    css = css & "    text-decoration: none;" & CRLF
    css = css & "    display: inline-block;" & CRLF
    css = css & "    font-size: 14px;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".btn-primary {" & CRLF
    css = css & "    background-color: #007bff;" & CRLF
    css = css & "    color: white;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".btn-secondary {" & CRLF
    css = css & "    background-color: #6c757d;" & CRLF
    css = css & "    color: white;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".form-group {" & CRLF
    css = css & "    margin-bottom: 15px;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & "label {" & CRLF
    css = css & "    display: block;" & CRLF
    css = css & "    margin-bottom: 5px;" & CRLF
    css = css & "    font-weight: bold;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & "input, textarea {" & CRLF
    css = css & "    width: 100%;" & CRLF
    css = css & "    padding: 8px;" & CRLF
    css = css & "    border: 1px solid #ddd;" & CRLF
    css = css & "    border-radius: 4px;" & CRLF
    css = css & "    font-size: 14px;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".table {" & CRLF
    css = css & "    width: 100%;" & CRLF
    css = css & "    border-collapse: collapse;" & CRLF
    css = css & "    margin-top: 20px;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".table th, .table td {" & CRLF
    css = css & "    padding: 10px;" & CRLF
    css = css & "    text-align: left;" & CRLF
    css = css & "    border-bottom: 1px solid #ddd;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    css = css & ".table-striped tbody tr:nth-child(odd) {" & CRLF
    css = css & "    background-color: #f9f9f9;" & CRLF
    css = css & "}" & CRLF & CRLF
    
    Return css
End Sub

Sub GenerateWebJS As String
    Dim js As String
    js = "// Web application JavaScript" & CRLF & CRLF
    
    js = js & "// API helper functions" & CRLF
    js = js & "const API = {" & CRLF
    js = js & "    baseUrl: '/api'," & CRLF & CRLF
    
    js = js & "    get: function(endpoint) {" & CRLF
    js = js & "        return fetch(this.baseUrl + endpoint)" & CRLF
    js = js & "            .then(response => response.json());" & CRLF
    js = js & "    }," & CRLF & CRLF
    
    js = js & "    post: function(endpoint, data) {" & CRLF
    js = js & "        return fetch(this.baseUrl + endpoint, {" & CRLF
    js = js & "            method: 'POST'," & CRLF
    js = js & "            headers: { 'Content-Type': 'application/json' }," & CRLF
    js = js & "            body: JSON.stringify(data)" & CRLF
    js = js & "        }).then(response => response.json());" & CRLF
    js = js & "    }," & CRLF & CRLF
    
    js = js & "    put: function(endpoint, data) {" & CRLF
    js = js & "        return fetch(this.baseUrl + endpoint, {" & CRLF
    js = js & "            method: 'PUT'," & CRLF
    js = js & "            headers: { 'Content-Type': 'application/json' }," & CRLF
    js = js & "            body: JSON.stringify(data)" & CRLF
    js = js & "        }).then(response => response.json());" & CRLF
    js = js & "    }," & CRLF & CRLF
    
    js = js & "    delete: function(endpoint) {" & CRLF
    js = js & "        return fetch(this.baseUrl + endpoint, {" & CRLF
    js = js & "            method: 'DELETE'" & CRLF
    js = js & "        }).then(response => response.status === 204 ? true : false);" & CRLF
    js = js & "    }" & CRLF
    js = js & "};" & CRLF & CRLF
    
    js = js & "// Common functions" & CRLF
    js = js & "function deleteItem(id) {" & CRLF
    js = js & "    if (confirm('Are you sure you want to delete this item?')) {" & CRLF
    js = js & "        API.delete('/' + id).then(() => location.reload());" & CRLF
    js = js & "    }" & CRLF
    js = js & "}" & CRLF
    
    Return js
End Sub

Sub GeneratePlatformStructure(platform As String, modelName As String, fields As List) As Boolean
    Try
        Log("Generating structure for platform: " & platform)
        
        Select platform
            Case "B4A"
                Return GenerateNativeStructure("B4A", modelName, fields)
            Case "B4I"
                Return GenerateNativeStructure("B4I", modelName, fields)
            Case "B4J"
                Return GenerateNativeStructure("B4J", modelName, fields)
            Case "web"
                Return GenerateWebStructure(modelName, fields)
            Case "hybrid"
                Return GenerateHybridStructure(modelName, fields)
            Case "all"
                Dim success As Boolean = True
                success = success And GenerateNativeStructure("B4A", modelName, fields)
                success = success And GenerateNativeStructure("B4I", modelName, fields)
                success = success And GenerateNativeStructure("B4J", modelName, fields)
                success = success And GenerateWebStructure(modelName, fields)
                Return success
            Case Else
                LogWarning("Unknown platform: " & platform)
                Return False
        End Select
    Catch
        LogError("Error generating platform structure: " & platform, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateNativeStructure(platform As String, modelName As String, fields As List) As Boolean
    Try
        Log("Generating native platform structure: " & platform)
        
        Dim platformPath As String = "platforms/" & platform
        Dim filesMap As Map
        filesMap.Initialize
        
        'CRUD Controller
        Dim crudController As String = GenerateCRUDController(platform, modelName, fields)
        filesMap.Put(modelName & "Controller.bas", crudController)
        
        'SQL Schema
        Dim sqlSchema As String = GenerateSQLSchema(modelName, fields)
        filesMap.Put(ConvertToSnakeCase(modelName) & ".sql", sqlSchema)
        
        'jRDC2 Config
        Dim jrdc2Config As String = GenerateJRDC2Config(modelName, "http://localhost:8080", "AppRDC")
        filesMap.Put(modelName & "_jRDC2.txt", jrdc2Config)
        
        'UI Layout (B4XPage for B4X platforms)
        Dim layout As String = GenerateB4XPageLayout(modelName, fields)
        filesMap.Put(modelName & "Page.bas", layout)
        
        Dim createdCount As Int = FileGenerator.CreateMultipleFiles(platformPath, filesMap)
        Log("Created " & createdCount & " files for " & platform & " platform")
        
        Return True
    Catch
        LogError("Error generating native structure: " & platform, LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateWebStructure(modelName As String, fields As List) As Boolean
    Try
        Log("Generating web platform structure")
        
        Dim webPath As String = "platforms/web"
        
        'Create subdirectories
        FileGenerator.CreateDirectoryIdempotent(webPath & "/assets/css")
        FileGenerator.CreateDirectoryIdempotent(webPath & "/assets/js")
        FileGenerator.CreateDirectoryIdempotent(webPath & "/views")
        FileGenerator.CreateDirectoryIdempotent(webPath & "/controllers")
        FileGenerator.CreateDirectoryIdempotent(webPath & "/routes")
        
        Dim filesMap As Map
        filesMap.Initialize
        
        'jServer Handler
        Dim handler As String = GenerateWebJServerHandler(modelName, fields)
        filesMap.Put(webPath & "/handlers/" & modelName & "Handler.bas", handler)
        
        'Router
        Dim router As String = GenerateWebRouter(modelName)
        filesMap.Put(webPath & "/routes/" & modelName & "_routes.bas", router)
        
        'HTML Form
        Dim form As String = GenerateWebHTMLForm(modelName, fields)
        filesMap.Put(webPath & "/views/" & ConvertToSnakeCase(modelName) & "_form.html", form)
        
        'HTML List
        Dim list As String = GenerateWebHTMLList(modelName, fields)
        filesMap.Put(webPath & "/views/" & ConvertToSnakeCase(modelName) & "_list.html", list)
        
        'CSS
        Dim css As String = GenerateWebCSS
        filesMap.Put(webPath & "/assets/css/styles.css", css)
        
        'JS
        Dim js As String = GenerateWebJS
        filesMap.Put(webPath & "/assets/js/app.js", js)
        
        'SQL Schema
        Dim sqlSchema As String = GenerateSQLSchema(modelName, fields)
        filesMap.Put(webPath & "/sql/" & ConvertToSnakeCase(modelName) & ".sql", sqlSchema)
        
        'jRDC2 Config
        Dim jrdc2Config As String = GenerateJRDC2Config(modelName, "http://localhost:8080", "WebRDC")
        filesMap.Put(webPath & "/" & modelName & "_jRDC2.txt", jrdc2Config)
        
        Log("Web platform structure generated")
        
        Return True
    Catch
        LogError("Error generating web structure", LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateHybridStructure(modelName As String, fields As List) As Boolean
    Try
        Log("Generating hybrid (web+desktop) structure")
        
        Dim success As Boolean = True
        success = success And GenerateNativeStructure("B4J", modelName, fields)
        success = success And GenerateWebStructure(modelName, fields)
        
        Return success
    Catch
        LogError("Error generating hybrid structure", LastException)
        Return False
    End TryCatch
End Sub

Sub GenerateForMultiplePlatforms(platforms As List, modelName As String, fields As List) As Boolean
    Try
        Log("Generating for multiple platforms: " & platforms.Size & " total")
        
        Dim success As Boolean = True
        Dim i As Int
        For i = 0 To platforms.Size - 1
            Dim platform As String = platforms.Get(i)
            Log("Processing platform: " & platform)
            success = success And GeneratePlatformStructure(platform, modelName, fields)
        Next
        
        Return success
    Catch
        LogError("Error generating for multiple platforms", LastException)
        Return False
    End TryCatch
End Sub

Sub ConvertToSnakeCase(text As String) As String
    Dim result As String = ""
    Dim i As Int
    For i = 0 To text.Length - 1
        Dim ch As String = text.CharAt(i)
        If ch = ch.ToUpperCase And ch <> ch.ToLowerCase And i > 0 Then
            result = result & "_" & ch.ToLowerCase
        Else
            result = result & ch.ToLowerCase
        End If
    Next
    Return result
End Sub

Sub GetSQLType(fieldType As String) As String
    Return TypeMapping.GetSQLType(fieldType)
End Sub

Sub GetB4XType(fieldType As String) As String
    Return TypeMapping.GetB4XType(fieldType)
End Sub

Sub PlatformGenerator_Initialize
End Sub
