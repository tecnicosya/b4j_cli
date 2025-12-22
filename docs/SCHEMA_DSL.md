# Contrato DSL - CRUDTemplate v1.1

## 📋 Definición del Lenguaje DSL

El Domain Specific Language (DSL) de CRUDTemplate v1.1 permite definir esquemas de datos de forma declarativa usando una sintaxis similar a TypeScript/Kotlin. Este documento especifica el contrato completo del lenguaje.

## 🔤 Sintaxis del Lenguaje

### Estructura General

```typescript
model ModelName {
    fieldName: FieldType [@constraints]
    // Campos adicionales...
}

// Relaciones
relation RelationName {
    from: ModelA
    to: ModelB
    type: RelationType
    fields: [fieldA, fieldB]?
}

// Configuración global
config {
    option: value
    // Opciones adicionales...
}
```

### Comentarios

```typescript
// Comentario de línea
/* Comentario 
   multilínea */

// Comentario de documentación
/// Este es un comentario de documentación
model User {
    /// Identificador único del usuario
    id: uuid @primary @autoIncrement
}
```

## 📊 Definición de Modelos

### Sintaxis Básica

```typescript
model ModelName {
    fieldName: FieldType [@constraints]
}
```

### Ejemplos

```typescript
// Modelo simple
model User {
    id: uuid @primary @autoIncrement
    username: string @required @unique
    email: string @required @email
    isActive: boolean @default(true)
}

// Modelo complejo con validaciones
model Product {
    id: uuid @primary @autoIncrement
    name: string @required @minLength(3) @maxLength(100)
    description: text? @maxLength(1000)
    price: decimal @required @min(0.01) @max(999999.99)
    stock: int @required @min(0) @default(0)
    category: Category @relation("CategoryProducts")
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
}
```

## 🔢 Tipos de Datos

### Tipos Primitivos

| DSL Type | Description | SQLite Type | Ejemplo |
|----------|-------------|-------------|---------|
| `string` | Texto corto | TEXT | `"Hello World"` |
| `text` | Texto largo | TEXT | `"Lorem ipsum..."` |
| `int` | Entero 32-bit | INTEGER | `42` |
| `long` | Entero 64-bit | BIGINT | `9223372036854775807` |
| `double` | Decimal doble precisión | REAL | `3.14159` |
| `float` | Decimal simple precisión | REAL | `3.14` |
| `boolean` | Valor booleano | INTEGER | `true/false` |
| `date` | Solo fecha | DATE | `2023-12-25` |
| `datetime` | Fecha y hora | DATETIME | `2023-12-25T15:30:00` |
| `uuid` | Identificador único | TEXT | `"550e8400-e29b-41d4-a716-446655440000"` |
| `decimal` | Decimal exacto | DECIMAL | `123.45` |

### Tipos Nullable

```typescript
model Example {
    required: string @required
    optional: string?           // Nullable con ?
    nullable: string @nullable  // Nullable con @nullable
}
```

### Tipos de Colección

```typescript
model User {
    // Array de strings
    tags: string[]
    
    // Array de objetos relacionados
    posts: Post[]
    
    // Map de string a int
    scores: Map<string, int>
}
```

## 🔗 Constraints y Validaciones

### Constraints Básicos

```typescript
model User {
    // Campo obligatorio
    username: string @required
    
    // Valor único
    email: string @unique
    
    // Valor por defecto
    isActive: boolean @default(true)
    
    // Autoincremento
    id: uuid @primary @autoIncrement
    
    // Timestamp automático
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
}
```

### Validaciones de Longitud

```typescript
model Product {
    name: string @required @minLength(3) @maxLength(100)
    description: text @maxLength(1000)
    code: string @required @minLength(5) @maxLength(10)
}
```

### Validaciones Numéricas

```typescript
model Product {
    price: decimal @required @min(0.01) @max(999999.99)
    stock: int @required @min(0) @default(0)
    discount: double? @min(0.0) @max(1.0)
}
```

### Validaciones de Patrón

```typescript
model User {
    username: string @required @pattern("^[a-zA-Z0-9_]{3,20}$")
    email: string @required @email
    phone: string? @pattern("^\\+?[1-9]\\d{1,14}$")
    website: string? @url
}
```

### Validaciones Personalizadas

```typescript
model User {
    email: string @required @custom("EmailValidator.validate")
    password: string @required @minLength(8) @custom("PasswordValidator.strength")
}
```

## 🔗 Relaciones entre Modelos

### One-to-Many (Unidireccional)

```typescript
model User {
    id: uuid @primary @autoIncrement
    username: string @required
    // Un usuario tiene muchos posts
    posts: Post[] @relation("UserPosts")
}

model Post {
    id: uuid @primary @autoIncrement
    title: string @required
    content: text @required
    // Un post pertenece a un usuario
    author: User @relation("UserPosts")
}
```

### Many-to-One (Bidireccional)

```typescript
model User {
    id: uuid @primary @autoIncrement
    username: string @required
    posts: Post[] @relation("UserPosts")
}

model Post {
    id: uuid @primary @autoIncrement
    title: string @required
    content: text @required
    author: User @relation("UserPosts")
}
```

### Many-to-Many

```typescript
model User {
    id: uuid @primary @autoIncrement
    username: string @required
    // Relación muchos a muchos
    roles: Role[] @relation("UserRoles")
}

model Role {
    id: uuid @primary @autoIncrement
    name: string @required @unique
    users: User[] @relation("UserRoles")
}
```

### One-to-One

```typescript
model User {
    id: uuid @primary @autoIncrement
    username: string @required
    // Un usuario tiene un perfil
    profile: UserProfile @relation("UserProfile")
}

model UserProfile {
    id: uuid @primary @autoIncrement
    bio: text?
    avatar: string?
    // Un perfil pertenece a un usuario
    user: User @relation("UserProfile")
}
```

### Relaciones con Campos Personalizados

```typescript
model User {
    id: uuid @primary @autoIncrement
    posts: Post[] @relation("UserPosts", fields: [id], references: [userId])
}

model Post {
    id: uuid @primary @autoIncrement
    title: string @required
    content: text @required
    // Campo personalizado para la relación
    userId: uuid
    author: User @relation("UserPosts", fields: [userId], references: [id])
}
```

## ⚙️ Configuración Global

### Configuración de Base de Datos

```typescript
config {
    database: {
        type: "sqlite"
        name: "app.db"
        version: 1
        migration: true
    }
}
```

### Configuración de JRDC2

```typescript
config {
    jrdc2: {
        enabled: true
        server: "localhost"
        port: 17178
        database: "app.db"
        timeout: 30000
    }
}
```

### Configuración de UI

```typescript
config {
    ui: {
        theme: "material"
        platform: "auto" // auto, b4j, b4a, b4i
        language: "es"
        responsive: true
    }
}
```

### Configuración de Sincronización

```typescript
config {
    sync: {
        enabled: true
        offline_first: true
        conflict_resolution: "auto" // auto, manual, last_write_wins
        retry_attempts: 3
        retry_delay: 5000 // milliseconds
    }
}
```

## 🎯 Índices y Constraints

### Índices Simples

```typescript
model User {
    id: uuid @primary @autoIncrement
    email: string @required @unique @index
    username: string @required @index("idx_username_active")
}
```

### Índices Compuestos

```typescript
model Post {
    id: uuid @primary @autoIncrement
    authorId: uuid @index("idx_author_created")
    createdAt: datetime @index("idx_author_created")
}

// Índice compuesto definido explícitamente
index "idx_author_created" {
    fields: [authorId, createdAt]
    unique: false
}
```

### Constraints de Tabla

```typescript
model Product {
    id: uuid @primary @autoIncrement
    price: decimal @required @min(0.01)
    stock: int @required @min(0)
}

// Constraint a nivel de tabla
constraint "price_positive" {
    check: "price > 0"
}

constraint "valid_stock" {
    check: "stock >= 0 AND stock <= 999999"
}
```

## 🏷️ Metadatos y Anotaciones

### Metadatos de Campo

```typescript
model User {
    id: uuid @primary @autoIncrement @meta({
        description: "Identificador único del usuario"
        example: "550e8400-e29b-41d4-a716-446655440000"
        ui: { visible: true, editable: false }
    })
    
    username: string @required @meta({
        label: "Nombre de Usuario"
        placeholder: "Ingrese su nombre de usuario"
        help: "Debe tener entre 3 y 20 caracteres"
    })
}
```

### Metadatos de Modelo

```typescript
model User @meta({
    description: "Modelo de usuario del sistema"
    table_name: "users"
    api_prefix: "/api/users"
    permissions: ["read", "write", "delete"]
}) {
    id: uuid @primary @autoIncrement
    username: string @required
    email: string @required
}
```

## 📝 Ejemplos Completos

### Ejemplo 1: Blog Simple

```typescript
// Configuración global
config {
    database: { type: "sqlite", name: "blog.db" }
    ui: { theme: "material", platform: "auto" }
}

// Modelo User
model User @meta({
    description: "Usuarios del blog"
    permissions: ["read", "write"]
}) {
    id: uuid @primary @autoIncrement
    username: string @required @unique @minLength(3) @maxLength(30)
    email: string @required @unique @email
    firstName: string @required @maxLength(50)
    lastName: string @required @maxLength(50)
    bio: text? @maxLength(500)
    avatar: string? @url
    isActive: boolean @default(true)
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    posts: Post[] @relation("UserPosts")
    comments: Comment[] @relation("UserComments")
}

// Modelo Post
model Post @meta({
    description: "Publicaciones del blog"
    permissions: ["read", "write", "publish"]
}) {
    id: uuid @primary @autoIncrement
    title: string @required @minLength(5) @maxLength(200)
    content: text @required @minLength(50)
    excerpt: text? @maxLength(300)
    slug: string @required @unique @pattern("^[a-z0-9-]+$")
    status: string @required @default("draft") @pattern("^(draft|published|archived)$")
    featuredImage: string? @url
    publishedAt: datetime?
    author: User @relation("UserPosts")
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    comments: Comment[] @relation("PostComments")
    tags: Tag[] @relation("PostTags")
}

// Modelo Comment
model Comment @meta({
    description: "Comentarios en publicaciones"
    permissions: ["read", "write"]
}) {
    id: uuid @primary @autoIncrement
    content: text @required @minLength(1) @maxLength(1000)
    author: User @relation("UserComments")
    post: Post @relation("PostComments")
    parentId: uuid? // Para comentarios anidados
    isApproved: boolean @default(false)
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
}

// Modelo Tag
model Tag @meta({
    description: "Etiquetas para clasificar publicaciones"
    permissions: ["read", "write"]
}) {
    id: uuid @primary @autoIncrement
    name: string @required @unique @minLength(2) @maxLength(30)
    slug: string @required @unique @pattern("^[a-z0-9-]+$")
    description: text? @maxLength(200)
    color: string? @pattern("^#[0-9A-Fa-f]{6}$")
    posts: Post[] @relation("PostTags")
}

// Índices adicionales
index "idx_posts_status_published" {
    fields: [status, publishedAt]
    where: "status = 'published'"
}
```

### Ejemplo 2: Sistema de Inventario

```typescript
config {
    database: { type: "sqlite", name: "inventory.db" }
    ui: { theme: "bootstrap", platform: "auto" }
    sync: { enabled: true, offline_first: true }
}

// Modelo Category
model Category @meta({
    description: "Categorías de productos"
    permissions: ["read", "write", "manage"]
}) {
    id: uuid @primary @autoIncrement
    name: string @required @unique @minLength(2) @maxLength(100)
    description: text? @maxLength(500)
    parentId: uuid? // Para categorías anidadas
    isActive: boolean @default(true)
    sortOrder: int @default(0) @index("idx_category_sort")
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    parent: Category? @relation("CategoryHierarchy")
    children: Category[] @relation("CategoryHierarchy")
    products: Product[] @relation("CategoryProducts")
}

// Modelo Supplier
model Supplier @meta({
    description: "Proveedores de productos"
    permissions: ["read", "write", "manage"]
}) {
    id: uuid @primary @autoIncrement
    name: string @required @unique @minLength(2) @maxLength(200)
    contactName: string? @maxLength(100)
    email: string? @email
    phone: string? @pattern("^\\+?[1-9]\\d{1,14}$")
    address: text? @maxLength(500)
    website: string? @url
    taxId: string? @unique @maxLength(50)
    isActive: boolean @default(true)
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    products: Product[] @relation("ProductSupplier")
}

// Modelo Product
model Product @meta({
    description: "Productos del inventario"
    permissions: ["read", "write", "manage"]
}) {
    id: uuid @primary @autoIncrement
    sku: string @required @unique @minLength(3) @maxLength(50)
    barcode: string? @unique @maxLength(50)
    name: string @required @minLength(2) @maxLength(200)
    description: text? @maxLength(1000)
    category: Category @relation("CategoryProducts")
    supplier: Supplier? @relation("ProductSupplier")
    
    // Precios
    costPrice: decimal @required @min(0.01) @precision(10,2)
    sellingPrice: decimal @required @min(0.01) @precision(10,2)
    discountPrice: decimal? @min(0.01) @precision(10,2)
    
    // Inventario
    currentStock: int @required @min(0) @default(0)
    minStock: int @required @min(0) @default(10)
    maxStock: int @required @min(1) @default(1000)
    
    // Dimensiones y peso
    weight: double? @min(0.0) @precision(8,3)
    length: double? @min(0.0) @precision(8,3)
    width: double? @min(0.0) @precision(8,3)
    height: double? @min(0.0) @precision(8,3)
    
    // Metadatos
    isActive: boolean @default(true)
    isDigital: boolean @default(false)
    requiresShipping: boolean @default(true)
    images: string[] // URLs de imágenes
    tags: string[]
    
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    inventoryMovements: InventoryMovement[] @relation("ProductMovements")
}

// Modelo InventoryMovement
model InventoryMovement @meta({
    description: "Movimientos de inventario"
    permissions: ["read", "write"]
}) {
    id: uuid @primary @autoIncrement
    product: Product @relation("ProductMovements")
    type: string @required @pattern("^(in|out|adjustment|transfer)$")
    quantity: int @required // Positivo para entrada, negativo para salida
    reason: string? @maxLength(200)
    reference: string? @maxLength(100) // Número de orden, factura, etc.
    userId: uuid? // Quién realizó el movimiento
    createdAt: datetime @autoTimestamp
}

// Índices específicos
index "idx_products_category_active" {
    fields: [category, isActive]
}

index "idx_products_sku_active" {
    fields: [sku, isActive]
}

index "idx_movements_product_date" {
    fields: [product, createdAt]
}
```

## 🔍 Reglas de Validación del Parser

### Validaciones Sintácticas

1. **Nombres de modelos**: Deben empezar con letra mayúscula, solo letras y números
2. **Nombres de campos**: Deben empezar con letra minúscula, solo letras, números y guiones bajos
3. **Tipos de datos**: Deben ser tipos válidos del DSL
4. **Constraints**: Deben ser constraints válidos para el tipo de dato
5. **Relaciones**: Los modelos referenciados deben existir

### Validaciones Semánticas

1. **Primary Key**: Cada modelo debe tener exactamente un campo @primary
2. **AutoIncrement**: Solo aplicable a campos @primary
3. **Unique**: No puede aplicarse a campos nullable
4. **Relations**: Las relaciones deben ser consistentes (bidireccionales cuando aplique)
5. **Dependencies**: Los modelos referenciados en relaciones deben estar definidos

### Errores Comunes

```typescript
// ERROR: Sin primary key
model Invalid {
    name: string
}

// ERROR: Multiple primary keys
model Invalid {
    id: uuid @primary
    guid: string @primary
}

// ERROR: Constraint incompatible
model Invalid {
    email: string @required @unique
    secondaryEmail: string? @unique // ERROR: unique en campo nullable
}

// ERROR: Relación inexistente
model User {
    posts: Post[] // ERROR: Post no existe
}

// ERROR: Sintaxis inválida
model Invalid {
    name: string @required @minLength(-5) // ERROR: valor negativo
}
```

## 🚀 Extensibilidad

### Constraints Personalizados

```typescript
// Registrar constraint personalizado
DSL.registerConstraint("strongPassword", {
    validate: (value) => /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(value),
    errorMessage: "La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas, números y símbolos"
});

model User {
    password: string @required @strongPassword
}
```

### Tipos Personalizados

```typescript
// Registrar tipo personalizado
DSL.registerType("email", {
    base: "string",
    validate: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
    normalize: (value) => value.toLowerCase().trim()
});

model User {
    email: email @required @unique
}
```

---

**Versión del documento**: 1.1.0  
**Última actualización**: $(date +%Y-%m-%d)  
**Estado**: Especificación final  
**Compatibilidad**: CRUDTemplate v1.1.x