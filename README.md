# CRUDTemplate v1.1

Template UI multiplataforma para desarrollo rápido de aplicaciones CRUD con B4X.

## 📋 Descripción

CRUDTemplate v1.1 es una solución completa de templates multiplataforma que permite generar interfaces de usuario CRUD (Create, Read, Update, Delete) de forma automática para aplicaciones B4X (B4J, B4A, B4i).

## 🏗️ Arquitectura

Consulta [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) para el diagrama de capas y UML.

## 🛠️ Stack

- **Frontend**: B4J/B4A/B4i
- **Backend**: SQLite
- **Conectividad**: JRDC2
- **DSL**: TypeScript/Kotlin

## 📚 Documentación

- [Arquitectura del Sistema](./docs/ARCHITECTURE.md)
- [Especificación Completa v1.1](./docs/SPEC_v1.1.md)
- [Contrato DSL](./docs/SCHEMA_DSL.md)

## 🚀 Uso Rápido

```bash
# Generar template CRUD básico
b4x-crud-template create User "name:string,email:string,age:int"

# Generar para plataforma específica
b4x-crud-template create Product "title:string,price:double,in_stock:boolean" --platform B4J
```

## 📁 Estructura del Proyecto

```
├── docs/              # Documentación completa
├── src/              # Código fuente
│   ├── core/         # Núcleo del framework
│   ├── adapters/     # Adaptadores de plataforma
│   ├── template/     # Templates de UI
│   ├── generators/   # Generadores de código
│   └── runtime/      # Runtime engine
├── db/               # Scripts de base de datos
└── tests/            # Tests unitarios e integración
```

## 📄 Licencia

MIT License - Ver archivo LICENSE para más detalles.

## 🤝 Contribución

Ver [CONTRIBUTING.md](./CONTRIBUTING.md) para guías de contribución.

---

**Desarrollado con ❤️ para la comunidad B4X**