# Scaffolding Engine Documentation

## Overview
This is a comprehensive scaffolding engine implementation for B4X/B4J projects. It provides core logic for generating project structure, models, controllers, database schemas, and platform-specific code.

## Core Modules

### 1. TypeMapping.bas
Handles type mapping between B4X and SQL types.

**Key Functions:**
- `GetSQLType(fieldType As String) As String` - Maps field type to SQL equivalent
- `GetB4XType(fieldType As String) As String` - Maps field type to B4X equivalent

**Supported Types:**
- `string` → VARCHAR(255) / String
- `int` → INTEGER / Int
- `long` → BIGINT / Long
- `double` → DOUBLE / Double
- `float` → FLOAT / Float
- `boolean` → BOOLEAN / Boolean
- `date` → TIMESTAMP / Long
- `text` → TEXT / String
- `decimal` → DECIMAL(10,2) / Double
- `uuid` → VARCHAR(36) / String

### 2. FileGenerator.bas
Manages file and directory creation with idempotent operations.

**Key Functions:**
- `CreateDirectoryIdempotent(folderPath As String) As Boolean` - Creates directory if it doesn't exist
- `CreateFile(folderPath As String, fileName As String, content As String) As Boolean` - Creates file with content
- `CreateMultipleFiles(basePath As String, files As Map) As Int` - Creates multiple files in one operation
- `WriteToFile(filePath As String, content As String) As Boolean` - Writes content to existing file
- `ReadFromFile(filePath As String) As String` - Reads file content

**Features:**
- Idempotent directory creation (checks before creating)
- Comprehensive error handling
- Logging for all operations

### 3. TemplateEngine.bas
Evaluates template placeholders and handles naming conventions.

**Key Functions:**
- `EvaluateTemplate(template As String, context As Map) As String` - Evaluates placeholders like {{ModelName}}, {{model_name}}
- `ConvertToCamelCase(text As String) As String` - Converts text to camelCase
- `ConvertToSnakeCase(text As String) As String` - Converts text to snake_case
- `ExpandFieldsTemplate(fields As List) As String` - Generates field declarations
- `GenerateFieldProperties(fields As List) As String` - Generates getter/setter methods

**Supported Placeholders:**
- `{{ModelName}}` - Original model name
- `{{model_name}}` - Snake case version
- `{{modelName}}` - Camel case version
- `{{fields}}` - Expanded field definitions

### 4. Scaffolder.bas
Main orchestrator for the entire scaffolding process.

**Key Functions:**
- `ScaffoldProject(projectName As String, fieldsString As String) As Boolean` - Main entry point, generates complete project
- `ParseFieldDefinitions(fieldsString As String) As List` - Parses field definitions into structured metadata
- `GenerateModel(modelName As String, fields As List) As Boolean` - Generates model class
- `GenerateController(modelName As String, fields As List) As Boolean` - Generates controller with CRUD stubs
- `GenerateSQLSchema(modelName As String, fields As List) As Boolean` - Generates SQL CREATE TABLE statement
- `GenerateDatabase(modelName As String, fields As List) As Boolean` - Generates database initialization code with jRDC2 snippets
- `GeneratePlatformSpecific(platformName As String, modelName As String, fields As List) As Boolean` - Generates platform-specific code

**Supported Platforms:**
- B4X (generic)
- B4A (Android)
- B4I (iOS)

**Generated Structure:**
```
/models/
  - {ModelName}.bas
/controllers/
  - {ModelName}Controller.bas
/sql/
  - {table_name}.sql
/db/
  - {ModelName}DB.bas (with jRDC2 snippets)
/templates/
  - {ModelName}_list.html
/platforms/B4X/
  - {ModelName}_B4X.bas
/platforms/B4A/
  - {ModelName}_B4A.bas
/platforms/B4I/
  - {ModelName}_B4I.bas
```

### 5. Logging.bas
Centralized logging system.

**Key Functions:**
- `Log(message As String)` - Logs info message with timestamp
- `LogError(message As String, exception As Exception)` - Logs error with optional exception info
- `LogWarning(message As String)` - Logs warning message

**Output:**
- `/logs/scaffolder.log` - All logs
- `/logs/scaffolder_errors.log` - Error logs only

### 6. Config.bas
Configuration management.

**Key Functions:**
- `GetConfig() As Map` - Returns all configuration settings
- `GetModelPath()` - Returns models directory path
- `GetControllerPath()` - Returns controllers directory path
- `GetSQLPath()` - Returns SQL directory path
- `GetDBPath()` - Returns database directory path
- `GetTemplatePath()` - Returns templates directory path
- `GetPlatformPath()` - Returns platforms directory path
- `GetRDC2ServerURL()` - Returns jRDC2 server URL
- `GetRDC2ServiceName()` - Returns jRDC2 service name

### 7. Utils.bas
Utility functions.

**Key Functions:**
- `ValidateFieldDefinition(fieldDef As Map) As Boolean` - Validates field definition structure
- `IsValidIdentifier(text As String) As Boolean` - Checks if text is valid identifier
- `SanitizeFileName(fileName As String) As String` - Removes invalid characters from filename
- `StringToList(text As String, delimiter As String) As List` - Converts string to list
- `ListToString(list As List, delimiter As String) As String` - Converts list to string
- `TrimQuotes(text As String) As String` - Removes surrounding quotes

## Usage Example

```basic
'Define fields
Dim fieldsString As String = _
    "username,string,true" & CRLF & _
    "email,string,true" & CRLF & _
    "age,int,false"

'Scaffold project
Dim scaffolder As Scaffolder
scaffolder.Initialize
Dim success As Boolean = scaffolder.ScaffoldProject("User", fieldsString)

If success Then
    Log("Project scaffolded successfully")
Else
    LogError("Project scaffolding failed", Null)
End If
```

## Field Definition Format

Fields are defined with comma-separated values:
```
fieldName,fieldType[,required]
```

Examples:
- `username,string,true` - Required string field
- `email,string` - Optional string field
- `age,int,true` - Required integer field
- `birthDate,date` - Optional date field

## Generated Code Features

### Model Class
- Auto-generated id, createdAt, updatedAt fields
- Getter/setter methods for all fields
- DateTime initialization in constructor

### Controller Class
- GetAll() - Retrieves all records
- GetById(id) - Retrieves specific record
- Create(model) - Creates new record
- Update(id, model) - Updates record
- Delete(id) - Deletes record

### SQL Schema
- Auto-incrementing id as PRIMARY KEY
- created_at and updated_at timestamps
- Proper NOT NULL constraints based on field definitions
- Supports platform-specific SQL variations

### Database Initialization
- Commented jRDC2 connection example
- SQL instance declaration
- Query execution stubs
- Ready for implementation

### Platform-Specific Code
- B4X: Generic B4X platform code
- B4A: Android-specific with Context support
- B4I: iOS-specific implementations

## Error Handling

All operations include comprehensive error handling:
- Try/Catch blocks for file operations
- Validation of input data
- Logging of errors with context
- Graceful fallback to console logging if file operations fail

## Logging

All operations are logged to:
- `/logs/scaffolder.log` - Information and warning logs
- `/logs/scaffolder_errors.log` - Error logs with exception details

Logs include timestamps in format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] message`

## Idempotent Operations

All directory creation is idempotent:
- Checks if directory exists before creating
- No errors if directory already exists
- Safe to run multiple times

## Notes

- All generated code includes comments and stubs
- jRDC2 connection examples are commented for reference
- Generated code is ready for developer customization
- Type mapping can be extended for custom types
- Platform-specific code serves as starting point for platform-specific implementations
