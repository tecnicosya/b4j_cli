# Especificación Completa CRUDTemplate v1.1

## 🎯 Objetivos del Proyecto

CRUDTemplate v1.1 tiene como objetivo proporcionar un sistema completo de generación automática de interfaces CRUD multiplataforma para el ecosistema B4X, permitiendo a los desarrolladores crear aplicaciones con interfaces consistentes y funcionales en B4J (Desktop), B4A (Android) y B4i (iOS) utilizando un solo esquema DSL.

## 📋 Requisitos Funcionales

### 1. Definición de Esquemas DSL
- **RF1**: Soporte para definición de modelos con TypeScript/Kotlin DSL
- **RF2**: Validación automática de esquemas DSL
- **RF3**: Soporte para tipos de datos básicos: string, int, long, double, float, boolean, date, text, uuid
- **RF4**: Validación de campos: required, minLength, maxLength, pattern, range
- **RF5**: Relaciones entre modelos: one-to-many, many-to-one, many-to-many

### 2. Generación de Interfaces de Usuario
- **RF6**: Generación automática de formularios CRUD para cada modelo
- **RF7**: Soporte para diferentes tipos de controles UI: TextField, TextArea, CheckBox, DatePicker, ComboBox, ListView
- **RF8**: Validación automática de formularios en cliente
- **RF9**: Generación de listas paginadas con búsqueda y filtrado
- **RF10**: Soporte para layouts responsivos en plataformas móviles

### 3. Integración Multiplataforma
- **RF11**: Generación consistente para B4J, B4A y B4i
- **RF12**: Adaptación automática de controles UI por plataforma
- **RF13**: Soporte para navegación específica de cada plataforma
- **RF14**: Mantenimiento de funcionalidad común entre plataformas

### 4. Persistencia de Datos
- **RF15**: Integración con SQLite local
- **RF16**: Soporte para JRDC2 para sincronización remota
- **RF17**: Generación automática de scripts SQL
- **RF18**: Manejo de migraciones de base de datos
- **RF19**: Sistema de sincronización offline/online

### 5. Configuración y Personalización
- **RF20**: Templates personalizables por el usuario
- **RF21**: Configuración de temas y estilos
- **RF22**: Soporte para localización (i18n)
- **RF23**: Configuración de validaciones personalizadas

## 📋 Requisitos No Funcionales

### 1. Rendimiento
- **RNF1**: Tiempo de generación < 5 segundos para modelos simples
- **RNF2**: Tiempo de generación < 30 segundos para modelos complejos
- **RNF3**: Interfaz UI responsiva (< 100ms respuesta visual)

### 2. Escalabilidad
- **RNF4**: Soporte para hasta 100 modelos por proyecto
- **RNF5**: Soporte para hasta 50 campos por modelo
- **RNF6**: Generación eficiente de proyectos grandes

### 3. Usabilidad
- **RNF7**: Documentación completa con ejemplos
- **RNF8**: Curva de aprendizaje mínima para desarrolladores B4X
- **RNF9**: Mensajes de error descriptivos y útiles
- **RNF10**: Herramientas de desarrollo integradas

### 4. Mantenibilidad
- **RNF11**: Código generado bien documentado y estructurado
- **RNF12**: Separación clara entre código generado y personalizado
- **RNF13**: Sistema de plugins para extensibilidad

### 5. Confiabilidad
- **RNF14**: Validación exhaustiva de entrada DSL
- **RNF15**: Manejo robusto de errores
- **RNF16**: Generación idempotente (mismo resultado con misma entrada)

## 🏗️ Arquitectura Técnica

### Componentes Principales

1. **DSL Parser**
   - Parser TypeScript/Kotlin-like DSL
   - Validador de esquemas
   - Generador de AST

2. **Template Engine**
   - Motor de templates configurable
   - Sistema de placeholders
   - Procesamiento condicional

3. **Platform Adapters**
   - B4JAdapter: Adaptaciones específicas para desktop
   - B4AAdapter: Adaptaciones específicas para Android
   - B4IAdapter: Adaptaciones específicas para iOS

4. **Code Generators**
   - UI Generator: Generación de interfaces
   - Controller Generator: Generación de controladores
   - Model Generator: Generación de modelos de datos
   - SQL Generator: Generación de scripts de base de datos

5. **Runtime Engine**
   - SQLiteManager: Manejo de base de datos local
   - JRDC2Client: Cliente para sincronización remota
   - SyncEngine: Motor de sincronización de datos

### Flujo de Procesamiento

```
DSL Input → Schema Parser → Template Engine → Platform Adapters → Code Generators → Output Files
     ↓              ↓               ↓                 ↓                ↓              ↓
 Validation    AST Generation   Template Processing  Platform Adaptation  File Generation  Project Structure
```

## 📊 Esquemas de Datos

### DSL Syntax

```typescript
// Esquema de ejemplo para modelo User
model User {
    id: uuid @primary @autoIncrement
    username: string @required @minLength(3) @maxLength(50)
    email: string @required @email @unique
    password: string @required @minLength(8)
    firstName: string @required @maxLength(100)
    lastName: string @required @maxLength(100)
    birthDate: date? 
    isActive: boolean @default(true)
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    posts: Post[] @relation("UserPosts")
    comments: Comment[] @relation("UserComments")
}

// Esquema de ejemplo para modelo Post
model Post {
    id: uuid @primary @autoIncrement
    title: string @required @minLength(5) @maxLength(200)
    content: text @required
    author: User @relation("UserPosts")
    createdAt: datetime @autoTimestamp
    updatedAt: datetime @autoTimestamp
    
    // Relaciones
    comments: Comment[] @relation("PostComments")
}
```

### Tipos de Datos Soportados

| DSL Type | SQLite Type | B4J Type | B4A Type | B4i Type |
|----------|-------------|----------|----------|----------|
| string | TEXT | String | String | String |
| int | INTEGER | Int | Int | Int |
| long | BIGINT | Long | Long | Long |
| double | REAL | Double | Double | Double |
| float | REAL | Float | Float | Float |
| boolean | INTEGER | Boolean | Boolean | Bool |
| date | DATE | Date | Date | Date |
| datetime | DATETIME | DateTime | DateTime | Date |
| text | TEXT | String | String | String |
| uuid | TEXT | String | String | String |
| decimal | DECIMAL | BigDecimal | BigDecimal | Decimal |

### Validaciones Soportadas

| Validación | Syntax | Descripción |
|------------|--------|-------------|
| Required | `@required` | Campo obligatorio |
| Min Length | `@minLength(n)` | Longitud mínima para strings |
| Max Length | `@maxLength(n)` | Longitud máxima para strings |
| Pattern | `@pattern(regex)` | Patrón regex para validación |
| Range | `@range(min,max)` | Rango numérico |
| Email | `@email` | Validación de formato email |
| URL | `@url` | Validación de formato URL |
| Unique | `@unique` | Valor único en tabla |
| Default | `@default(value)` | Valor por defecto |

## 🎨 Templates y UI

### Templates Base

1. **Form Template**
   - Layout responsivo
   - Validación en tiempo real
   - Manejo de errores

2. **List Template**
   - Tabla/paginación
   - Búsqueda y filtrado
   - Ordenamiento

3. **Detail Template**
   - Vista de solo lectura
   - Navegación entre registros
   - Botones de acción

### Controles UI por Plataforma

| Control | B4J | B4A | B4i |
|---------|-----|-----|-----|
| Text Field | TextField | EditText | UITextField |
| Text Area | TextArea | EditText | UITextView |
| Check Box | CheckBox | CheckBox | UISwitch |
| Date Picker | DatePicker | DatePicker | UIDatePicker |
| Combo Box | ComboBox | Spinner | UIPickerView |
| List View | ListView | ListView | UITableView |

## 🔄 Sincronización y Datos

### Tablas de Soporte

```sql
-- Tabla de cola de sincronización
CREATE TABLE _sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL, -- INSERT, UPDATE, DELETE
    data TEXT NOT NULL, -- JSON data
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT DEFAULT 'pending', -- pending, syncing, completed, failed
    retry_count INTEGER DEFAULT 0,
    last_error TEXT
);

-- Tabla de conflictos de sincronización
CREATE TABLE _sync_conflicts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    local_id TEXT NOT NULL,
    remote_id TEXT NOT NULL,
    conflict_type TEXT NOT NULL, -- version, data, deleted
    local_data TEXT,
    remote_data TEXT,
    resolution TEXT, -- local, remote, merge
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE
);

-- Tabla de metadatos de sincronización
CREATE TABLE _sync_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Flujo de Sincronización

1. **Detección de Cambios**
   - Tracking automático de modificaciones
   - Encolado de operaciones pendientes

2. **Resolución de Conflictos**
   - Detección automática de conflictos
   - Estrategias de resolución configurables

3. **Sincronización Remota**
   - Envío de cambios al servidor
   - Recepción de cambios del servidor

4. **Aplicación Local**
   - Integración de cambios remotos
   - Actualización de UI

## 📦 Distribución y Deployment

### Estructura de Proyecto Generado

```
GeneratedProject/
├── B4J/                    # Proyecto B4J Desktop
│   ├── Forms/
│   ├── Modules/
│   ├── Classes/
│   └── Objects/
├── B4A/                    # Proyecto B4A Android
│   ├── Activity/
│   ├── Classes/
│   ├── Objects/
│   └── Libraries/
├── B4i/                    # Proyecto B4i iOS
│   ├── Classes/
│   ├── Modules/
│   └── Objects/
├── Database/               # Scripts SQL y configuración
│   ├── schemas/
│   ├── migrations/
│   └── jrdc2/
└── Shared/                 # Código compartido
    ├── Models/
    ├── Controllers/
    └── Utils/
```

### Configuración JRDC2

```properties
# jrdc2.properties
# Configuración por defecto generada
server.port=17178
server.host=localhost
database.url=jdbc:sqlite:app.db
database.driver=org.sqlite.JDBC
database.username=
database.password=
pool.maxconnections=10
pool.timeout=30000
```

## 🧪 Testing y Validación

### Estrategia de Testing

1. **Unit Tests**
   - Parser DSL
   - Template Engine
   - Validators

2. **Integration Tests**
   - Generación completa de proyectos
   - Adaptadores de plataforma
   - Runtime Engine

3. **UI Tests**
   - Comportamiento de interfaces generadas
   - Validación de formularios
   - Navegación

### Casos de Prueba Principales

- Generación con modelos simples
- Generación con relaciones complejas
- Validación de esquemas inválidos
- Sincronización de datos
- Multiplataforma

## 📚 Documentación y Ejemplos

### Documentación Requerida

1. **Guía de Inicio Rápido**
   - Instalación
   - Primer proyecto
   - Ejemplo completo

2. **Referencia DSL**
   - Sintaxis completa
   - Ejemplos por tipo de campo
   - Validaciones

3. **Guía de Personalización**
   - Templates custom
   - Adaptadores personalizados
   - Plugins

4. **API Reference**
   - Interfaces públicas
   - Extensibilidad
   - Hooks y eventos

### Ejemplos de Uso

1. **Blog Simple**
   - Modelos: User, Post, Comment
   - Relaciones one-to-many
   - UI básica

2. **Inventario**
   - Modelos: Product, Category, Supplier
   - Validaciones complejas
   - Sincronización

3. **CRM**
   - Modelos: Client, Company, Deal
   - Relaciones many-to-many
   - UI avanzada

## 🚀 Roadmap y Extensiones Futuras

### Versión 1.2
- Soporte para web (B4J + jServer)
- Templates de gráficos y reportes
- Exportación a PDF/Excel

### Versión 1.3
- Integración con APIs REST externas
- Templates de autenticación
- Soporte para plugins de terceros

### Versión 2.0
- Editor visual de esquemas
- Generación de tests automatizados
- Integración con IDEs externos

---

**Documento versionado**: v1.1.0  
**Última actualización**: $(date +%Y-%m-%d)  
**Autor**: CRUDTemplate Team  
**Estado**: Draft para revisión