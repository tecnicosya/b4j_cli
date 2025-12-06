# Template Library Documentation

This directory contains template files used by the B4X CLI scaffolding engine to generate code for CRUD applications across multiple platforms (B4A, B4I, B4J, Web).

## Template Files

### 1. `model.template`
**Purpose:** Generates B4X model classes with properties, getters/setters, and serialization methods.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name (e.g., User, Product)
- `{{model_name}}` - snake_case version (e.g., user, product)
- `{{modelName}}` - camelCase version (e.g., user, product)
- `{{fields}}` - Expanded field declarations
- `{{field_properties}}` - Expanded getter/setter methods

**Example Output:** `User.bas` with fields like `username`, `email`, etc.

---

### 2. `controller.template`
**Purpose:** Generates controller classes with CRUD operations and jRDC2 integration stubs.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version
- `{{modelName}}` - camelCase version

**CRUD Operations:**
- `GetAll()` - Retrieve all records
- `GetById(id)` - Retrieve single record
- `Create(model)` - Insert new record
- `Update(id, model)` - Update existing record
- `Delete(id)` - Delete record

**jRDC2 Integration:** Includes commented examples for database commands.

**Example Output:** `UserController.bas`

---

### 3. `sql.template`
**Purpose:** Generates SQL schema files with CREATE TABLE statements and indexes.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case table name
- `{{table_name}}` - Same as model_name
- `{{sql_columns}}` - Expanded SQL column definitions

**Features:**
- Auto-increment primary key (`id`)
- Timestamp columns (`created_at`, `updated_at`)
- Custom field columns with appropriate SQL types
- Indexes for performance
- jRDC2 query examples in comments

**Example Output:** `user.sql` with table definition

---

### 4. `b4xpage.template`
**Purpose:** Generates cross-platform B4XPage classes for UI forms.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version
- `{{ui_controls}}` - Expanded UI control declarations
- `{{form_bindings}}` - Expanded form-to-model bindings

**Features:**
- Form initialization and data loading
- CRUD UI operations (Create, Read, Update, Delete)
- Form validation
- Controller integration
- Cross-platform compatibility (B4A, B4I, B4J)

**Example Output:** `UserPage.bas`

---

### 5. `b4x_layout.template`
**Purpose:** Generates B4X layout definitions in JSON-like format for Visual Designer.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version
- `{{layout_controls}}` - Expanded layout control definitions

**Control Types:**
- `EditText` - Text input fields
- `CheckBox` - Boolean fields
- `DatePicker` - Date fields
- `Button` - Action buttons (Save, Cancel, Delete, New)
- `Panel`, `ScrollView` - Containers

**Example Output:** `user_form.bjl` layout definition

---

### 6. `web_index.template`
**Purpose:** Generates HTML list/index page with table view and CRUD operations.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version for URLs
- `{{table_headers}}` - Expanded table header columns
- `{{table_columns}}` - Expanded table data columns

**Features:**
- Responsive table with Bootstrap-style classes
- Search and filter functionality
- Pagination
- Action buttons (View, Edit, Delete)
- Delete confirmation modal
- JavaScript API integration

**API Endpoints:**
- GET `/api/{{model_name}}` - Fetch all records
- DELETE `/api/{{model_name}}/:id` - Delete record

**Example Output:** `user_list.html`

---

### 7. `web_form.template`
**Purpose:** Generates HTML create/edit form page with validation and submission.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version for URLs
- `{{form_fields}}` - Expanded form input fields
- `{{validation_rules}}` - Expanded validation JavaScript
- `{{field_bindings}}` - Expanded form data binding code

**Features:**
- Dynamic form (works for both create and edit)
- Client-side validation
- Form data collection and submission
- Field type handling (text, number, date, checkbox, etc.)
- Metadata fields (created_at, updated_at)
- Responsive design

**API Endpoints:**
- POST `/api/{{model_name}}` - Create new record
- PUT `/api/{{model_name}}/:id` - Update record
- GET `/api/{{model_name}}/:id` - Load existing record for editing

**Example Output:** `user_form.html`

---

### 8. `web_handler.template`
**Purpose:** Generates jServer handler classes for REST API endpoints.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version for URLs and database

**REST API Methods:**
- `HandleGet(req, resp)` - GET requests (list all or get by ID)
- `HandlePost(req, resp)` - POST requests (create)
- `HandlePut(req, resp)` - PUT requests (update)
- `HandleDelete(req, resp)` - DELETE requests (delete)

**HTTP Status Codes:**
- 200 OK - Successful GET/PUT
- 201 Created - Successful POST
- 204 No Content - Successful DELETE
- 400 Bad Request - Invalid input
- 404 Not Found - Record not found
- 500 Internal Server Error - Server error

**jRDC2 Integration:** Uses jRDC2 commands for database operations.

**Example Output:** `UserHandler.bas`

---

### 9. `web_router.template`
**Purpose:** Generates router configuration for mapping URLs to handlers.

**Placeholders:**
- `{{ModelName}}` - PascalCase model name
- `{{model_name}}` - snake_case version for URLs

**Route Types:**

**API Routes (JSON responses):**
- GET `/api/{{model_name}}` - List all
- GET `/api/{{model_name}}/:id` - Get by ID
- POST `/api/{{model_name}}` - Create
- PUT `/api/{{model_name}}/:id` - Update
- DELETE `/api/{{model_name}}/:id` - Delete

**Web UI Routes (HTML pages):**
- GET `/web/{{model_name}}` - List view
- GET `/web/{{model_name}}/new` - Create form
- GET `/web/{{model_name}}/:id` - View details
- GET `/web/{{model_name}}/:id/edit` - Edit form

**Example Output:** `UserRouter.bas`

---

## Token Replacement System

The TemplateEngine module processes templates and replaces placeholder tokens with actual values.

### How Token Replacement Works

1. **Context Map**: Create a Map with key-value pairs
   ```b4x
   Dim context As Map
   context.Initialize
   context.Put("ModelName", "User")
   context.Put("model_name", "user")
   ```

2. **Evaluate Template**: Call EvaluateTemplate with template content and context
   ```b4x
   Dim result As String = TemplateEngine.EvaluateTemplate(templateContent, context)
   ```

3. **Automatic Case Conversion**:
   - `{{ModelName}}` → Exact value from context
   - `{{model_name}}` → Converted to snake_case
   - `{{modelName}}` → Converted to camelCase

### Special Placeholders

These placeholders require custom expansion logic:

- `{{fields}}` → Expanded by `ExpandFieldsTemplate(fields)`
- `{{field_properties}}` → Expanded by `GenerateFieldProperties(fields)`
- `{{sql_columns}}` → Expanded by SQL schema generator
- `{{ui_controls}}` → Expanded by UI control generator
- `{{form_bindings}}` → Expanded by form binding generator
- `{{table_headers}}` → Expanded by table header generator
- `{{table_columns}}` → Expanded by table column generator
- `{{layout_controls}}` → Expanded by layout control generator
- `{{validation_rules}}` → Expanded by validation rule generator

## jRDC2 Integration

All templates include jRDC2 (Remote Database Connector) integration for database operations.

### jRDC2 Configuration

Define SQL commands in `config.properties`:

```properties
# Database connection
DriverClass=com.mysql.jdbc.Driver
JdbcUrl=jdbc:mysql://localhost:3306/database_name
User=root
Password=

# Query commands for User model
sql.select_all_user=SELECT * FROM user ORDER BY created_at DESC
sql.select_user_by_id=SELECT * FROM user WHERE id=?
sql.insert_user=INSERT INTO user (username, email) VALUES (?, ?)
sql.update_user=UPDATE user SET username=?, email=?, updated_at=CURRENT_TIMESTAMP WHERE id=?
sql.delete_user=DELETE FROM user WHERE id=?
```

### jRDC2 Usage in Code

```b4x
'Initialize RDC connector
Dim rdc As RDCConnector
rdc.Initialize2(Me, "http://localhost:17178/rdc", "MyRDC")

'Execute query
Dim cmd As DBCommand
cmd.Initialize
cmd.Name = "select_all_user"
Dim result As List = rdc.ExecuteQuery(cmd)

'Execute with parameters
cmd.Name = "select_user_by_id"
cmd.Parameters = Array As Object(userId)
Dim result As List = rdc.ExecuteQuery(cmd)
```

## Usage Examples

### Generate Model

```b4x
'Parse field definitions
Dim fields As List = ParseFieldDefinitions("username,string,true" & CRLF & "email,string,true")

'Generate model
Dim success As Boolean = Scaffolder.GenerateModel("User", fields)
```

### Generate Complete Project

```b4x
'Scaffold complete project with all platforms
Dim platforms As List
platforms.Initialize
platforms.Add("B4A")
platforms.Add("B4I")
platforms.Add("web")

Dim fieldsString As String = "username,string,true" & CRLF & "email,string,true"
Dim success As Boolean = Scaffolder.ScaffoldProjectForPlatforms("User", fieldsString, platforms)
```

This generates:
- `/models/User.bas` - Model class
- `/controllers/UserController.bas` - Controller
- `/sql/user.sql` - SQL schema
- `/db/UserDB.bas` - Database initialization
- `/templates/User_list.html` - List template
- `/platforms/B4A/...` - B4A platform files
- `/platforms/B4I/...` - B4I platform files
- `/platforms/web/...` - Web platform files

## Field Type Mapping

### B4X Types
- `string` → `String`
- `int` → `Int`
- `long` → `Long`
- `double` → `Double`
- `float` → `Float`
- `boolean` → `Boolean`
- `date` → `Long` (timestamp)
- `text` → `String` (multiline)
- `decimal` → `Double`
- `uuid` → `String`

### SQL Types
- `string` → `VARCHAR(255)`
- `int` → `INT`
- `long` → `BIGINT`
- `double` → `DOUBLE`
- `float` → `FLOAT`
- `boolean` → `BOOLEAN`
- `date` → `TIMESTAMP`
- `text` → `TEXT`
- `decimal` → `DECIMAL(10,2)`
- `uuid` → `CHAR(36)`

### HTML Input Types
- `string` → `<input type="text">`
- `int/long/double` → `<input type="number">`
- `boolean` → `<input type="checkbox">`
- `date` → `<input type="date">`
- `text` → `<textarea>`
- `email` → `<input type="email">`

## Best Practices

1. **Naming Conventions**:
   - Models: PascalCase (e.g., `UserProfile`, `ProductCategory`)
   - Database tables: snake_case (e.g., `user_profile`, `product_category`)
   - Variables: camelCase (e.g., `userProfile`, `productCategory`)

2. **Required Fields**:
   - Always mark essential fields as required
   - Example: `"username,string,true"` (third parameter is required flag)

3. **Field Validation**:
   - Use appropriate field types for validation
   - Add custom validation in generated code

4. **jRDC2 Commands**:
   - Use descriptive command names
   - Follow pattern: `verb_model_name` (e.g., `select_all_user`, `insert_user`)

5. **Template Customization**:
   - Templates are starting points - customize generated code as needed
   - Add business logic to controller methods
   - Enhance UI with platform-specific features

## Testing Templates

To test template generation:

```bash
# Generate User model with fields
b4x-cli scaffold-platforms User "username,string,true email,string,true age,int" "B4A,web"

# Check generated files
ls models/
ls controllers/
ls sql/
ls platforms/web/
```

## Troubleshooting

**Issue:** Placeholder not replaced
- **Cause:** Placeholder name doesn't match context key
- **Solution:** Ensure exact match (case-sensitive)

**Issue:** SQL type not recognized
- **Cause:** Unknown field type
- **Solution:** Use supported types or extend TypeMapping module

**Issue:** Generated code has syntax errors
- **Cause:** Template has B4J syntax errors
- **Solution:** Validate template syntax before generation

**Issue:** jRDC2 commands not working
- **Cause:** Commands not defined in config.properties
- **Solution:** Add command definitions with proper SQL

## Contributing

When adding new templates:
1. Follow existing naming convention: `{category}_{purpose}.template`
2. Include comprehensive placeholder documentation at the top
3. Add jRDC2 integration examples where applicable
4. Include usage examples in comments
5. Update this README with template documentation
6. Test generation with various field types

## Version

Template Library Version: 1.0
Compatible with: B4X CLI Scaffolding Engine v1.0
Last Updated: 2024
