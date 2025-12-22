# Arquitectura CRUDTemplate v1.1

## Diagrama de Capas

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   B4J UI    │ │   B4A UI    │ │   B4i UI    │            │
│  │  (Desktop)  │ │ (Android)   │ │   (iOS)     │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   TEMPLATE ENGINE LAYER                      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   Views     │ │ Controllers │ │  Contracts  │            │
│  │   Template  │ │   Template  │ │    API      │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   ADAPTER LAYER                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │ B4J Adapter │ │ B4A Adapter │ │ B4i Adapter │            │
│  │             │ │             │ │             │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     CORE LAYER                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │  Template   │ │   Parser    │ │   Schema    │            │
│  │   Engine    │ │     DSL     │ │ Validator   │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                  GENERATION LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │    Code     │ │    File     │ │   Project   │            │
│  │  Generator  │ │  Generator  │ │  Generator  │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     RUNTIME LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │   SQLite    │ │   JRDC2     │ │   Sync      │            │
│  │   Engine    │ │   Client    │ │   Engine    │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

## Diagrama UML de Componentes

```mermaid
classDiagram
    class TemplateEngine {
        +parseSchema(schema: DSL) TemplateDefinition
        +generateView(template: ViewTemplate, data: Model) UIComponent
        +generateController(template: ControllerTemplate, model: Model) Controller
    }
    
    class PlatformAdapter {
        <<interface>>
        +adaptUI(component: UIComponent) PlatformUI
        +adaptController(controller: Controller) PlatformController
        +adaptModel(model: Model) PlatformModel
    }
    
    class B4JAdapter {
        +adaptUI(component: UIComponent) B4JUI
        +adaptController(controller: Controller) B4JController
    }
    
    class B4AAdapter {
        +adaptUI(component: UIComponent) B4AUI
        +adaptController(controller: Controller) B4AController
    }
    
    class B4IAdapter {
        +adaptUI(component: UIComponent) B4IUI
        +adaptController(controller: Controller) B4IController
    }
    
    class SchemaParser {
        +parse(dsl: String) Schema
        +validate(schema: Schema) ValidationResult
    }
    
    class CodeGenerator {
        +generateProject(project: ProjectDefinition) Project
        +generateFiles(files: FileDefinition[]) File[]
    }
    
    class DSL {
        +ModelDefinition[]
        +FieldDefinition[]
        +ValidationRules
    }
    
    TemplateEngine --> PlatformAdapter
    PlatformAdapter <|-- B4JAdapter
    PlatformAdapter <|-- B4AAdapter
    PlatformAdapter <|-- B4IAdapter
    TemplateEngine --> SchemaParser
    SchemaParser --> DSL
    TemplateEngine --> CodeGenerator
```

## Flujo de Generación

1. **DSL Input**: Usuario define el esquema usando TypeScript/Kotlin DSL
2. **Schema Validation**: Parser valida el esquema DSL
3. **Template Processing**: Engine procesa templates con datos del esquema
4. **Platform Adaptation**: Adaptadores convierten código genérico a específico de plataforma
5. **Code Generation**: Generador crea archivos finales de proyecto
6. **Runtime Integration**: Runtime engine configura SQLite y JRDC2

## Responsabilidades por Capa

### Presentation Layer
- Interfaces de usuario específicas por plataforma
- Manejo de eventos y navegación
- Validación de formularios en cliente

### Template Engine Layer
- Procesamiento de templates
- Generación de componentes UI
- Inyección de datos en templates

### Adapter Layer
- Conversión entre código genérico y específico
- Manejo de diferencias entre plataformas
- Normalización de APIs

### Core Layer
- Parsing del DSL
- Validación de esquemas
- Lógica de negocio común

### Generation Layer
- Generación de archivos de código
- Creación de estructura de proyectos
- Configuración de build

### Runtime Layer
- Conexión a base de datos
- Sincronización de datos
- Manejo de estado de aplicación