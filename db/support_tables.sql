-- ================================================================
-- CRUDTemplate v1.1 - Tablas de Soporte para Sincronización
-- ================================================================
-- Este archivo contiene las tablas necesarias para el sistema
-- de sincronización offline/online de CRUDTemplate v1.1
--
-- Autor: CRUDTemplate Team
-- Versión: 1.1.0
-- Fecha: 2024-12-22
-- ================================================================

-- ================================================================
-- TABLA: _sync_queue
-- Propósito: Cola de operaciones de sincronización pendientes
-- ================================================================
CREATE TABLE IF NOT EXISTS _sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL CHECK(operation IN ('INSERT', 'UPDATE', 'DELETE')),
    data TEXT NOT NULL, -- JSON con los datos del registro
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending', 'syncing', 'completed', 'failed', 'cancelled')),
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    last_error TEXT,
    last_retry_at DATETIME,
    sync_priority INTEGER DEFAULT 5, -- 1=alta, 5=normal, 10=baja
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLA: _sync_conflicts
-- Propósito: Gestión de conflictos de sincronización
-- ================================================================
CREATE TABLE IF NOT EXISTS _sync_conflicts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    local_id TEXT NOT NULL,
    remote_id TEXT,
    conflict_type TEXT NOT NULL CHECK(conflict_type IN ('version_mismatch', 'concurrent_update', 'deleted_remotely', 'deleted_locally')),
    local_data TEXT, -- JSON con datos locales
    remote_data TEXT, -- JSON con datos remotos
    resolution TEXT CHECK(resolution IN ('local_wins', 'remote_wins', 'merge', 'manual')),
    resolved_by TEXT, -- ID del usuario que resolvió
    resolution_timestamp DATETIME,
    last_modified_local DATETIME,
    last_modified_remote DATETIME,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT
);

-- ================================================================
-- TABLA: _sync_metadata
-- Propósito: Metadatos del sistema de sincronización
-- ================================================================
CREATE TABLE IF NOT EXISTS _sync_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    data_type TEXT NOT NULL DEFAULT 'string' CHECK(data_type IN ('string', 'number', 'boolean', 'json')),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLA: _sync_log
-- Propósito: Log de todas las operaciones de sincronización
-- ================================================================
CREATE TABLE IF NOT EXISTS _sync_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sync_session_id TEXT NOT NULL,
    operation TEXT NOT NULL,
    table_name TEXT,
    record_id TEXT,
    status TEXT NOT NULL CHECK(status IN ('started', 'success', 'error', 'warning')),
    message TEXT,
    details TEXT, -- JSON con detalles adicionales
    duration_ms INTEGER,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- TABLA: _sync_health
-- Propósito: Monitoreo de salud del sistema de sincronización
-- ================================================================
CREATE TABLE IF NOT EXISTS _sync_health (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    metric_name TEXT NOT NULL,
    metric_value REAL NOT NULL,
    metric_unit TEXT,
    status TEXT NOT NULL CHECK(status IN ('healthy', 'warning', 'critical')),
    threshold_warning REAL,
    threshold_critical REAL,
    message TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    component TEXT DEFAULT 'sync_engine'
);

-- ================================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ================================================================

-- Índices para _sync_queue
CREATE INDEX IF NOT EXISTS idx_sync_queue_status ON _sync_queue(status);
CREATE INDEX IF NOT EXISTS idx_sync_queue_table ON _sync_queue(table_name);
CREATE INDEX IF NOT EXISTS idx_sync_queue_timestamp ON _sync_queue(timestamp);
CREATE INDEX IF NOT EXISTS idx_sync_queue_priority ON _sync_queue(sync_priority);
CREATE INDEX IF NOT EXISTS idx_sync_queue_retry ON _sync_queue(retry_count, last_retry_at);

-- Índices para _sync_conflicts
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_table ON _sync_conflicts(table_name);
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_resolved ON _sync_conflicts(resolved);
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_timestamp ON _sync_conflicts(timestamp);
CREATE INDEX IF NOT EXISTS idx_sync_conflicts_type ON _sync_conflicts(conflict_type);

-- Índices para _sync_metadata
CREATE INDEX IF NOT EXISTS idx_sync_metadata_key ON _sync_metadata(key);

-- Índices para _sync_log
CREATE INDEX IF NOT EXISTS idx_sync_log_session ON _sync_log(sync_session_id);
CREATE INDEX IF NOT EXISTS idx_sync_log_timestamp ON _sync_log(timestamp);
CREATE INDEX IF NOT EXISTS idx_sync_log_status ON _sync_log(status);
CREATE INDEX IF NOT EXISTS idx_sync_log_table ON _sync_log(table_name);

-- Índices para _sync_health
CREATE INDEX IF NOT EXISTS idx_sync_health_component ON _sync_health(component);
CREATE INDEX IF NOT EXISTS idx_sync_health_timestamp ON _sync_health(timestamp);
CREATE INDEX IF NOT EXISTS idx_sync_health_status ON _sync_health(status);

-- ================================================================
-- TRIGGERS PARA AUTOMATIZACIÓN
-- ================================================================

-- Trigger para actualizar updated_at en _sync_queue
CREATE TRIGGER IF NOT EXISTS update_sync_queue_timestamp 
AFTER UPDATE ON _sync_queue
FOR EACH ROW
BEGIN
    UPDATE _sync_queue SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger para actualizar updated_at en _sync_metadata
CREATE TRIGGER IF NOT EXISTS update_sync_metadata_timestamp 
AFTER UPDATE ON _sync_metadata
FOR EACH ROW
BEGIN
    UPDATE _sync_metadata SET updated_at = CURRENT_TIMESTAMP WHERE key = NEW.key;
END;

-- Trigger para limpiar registros antiguos en _sync_log (mantener últimos 30 días)
CREATE TRIGGER IF NOT EXISTS cleanup_sync_log 
AFTER INSERT ON _sync_log
FOR EACH ROW
BEGIN
    DELETE FROM _sync_log 
    WHERE timestamp < datetime('now', '-30 days');
END;

-- Trigger para limpiar métricas de salud antiguas (mantener últimos 7 días)
CREATE TRIGGER IF NOT EXISTS cleanup_sync_health 
AFTER INSERT ON _sync_health
FOR EACH ROW
BEGIN
    DELETE FROM _sync_health 
    WHERE timestamp < datetime('now', '-7 days');
END;

-- ================================================================
-- DATOS INICIALES PARA METADATOS
-- ================================================================

INSERT OR REPLACE INTO _sync_metadata (key, value, data_type) VALUES 
('schema_version', '1.1.0', 'string'),
('last_sync_timestamp', '', 'string'),
('sync_enabled', 'true', 'boolean'),
('offline_first', 'true', 'boolean'),
('conflict_resolution', 'manual', 'string'),
('retry_attempts', '3', 'number'),
('retry_delay_ms', '5000', 'number'),
('max_batch_size', '100', 'number'),
('sync_interval_seconds', '30', 'number'),
('heartbeat_interval_seconds', '60', 'number'),
('network_timeout_ms', '30000', 'number'),
('client_id', '', 'string'),
('server_url', '', 'string'),
('database_name', '', 'string'),
('created_at', datetime('now'), 'string');

-- ================================================================
-- VISTAS ÚTILES PARA MONITOREO
-- ================================================================

-- Vista: Resumen de cola de sincronización
CREATE VIEW IF NOT EXISTS sync_queue_summary AS
SELECT 
    status,
    COUNT(*) as count,
    COUNT(DISTINCT table_name) as affected_tables
FROM _sync_queue 
GROUP BY status;

-- Vista: Conflictos pendientes de resolución
CREATE VIEW IF NOT EXISTS pending_conflicts AS
SELECT 
    c.id,
    c.table_name,
    c.conflict_type,
    c.local_id,
    c.remote_id,
    c.timestamp,
    CASE 
        WHEN c.conflict_type = 'version_mismatch' THEN 'Conflicto de versión'
        WHEN c.conflict_type = 'concurrent_update' THEN 'Actualización concurrente'
        WHEN c.conflict_type = 'deleted_remotely' THEN 'Eliminado remotamente'
        WHEN c.conflict_type = 'deleted_locally' THEN 'Eliminado localmente'
        ELSE c.conflict_type
    END as conflict_description
FROM _sync_conflicts c
WHERE c.resolved = FALSE
ORDER BY c.timestamp DESC;

-- Vista: Salud del sistema de sincronización
CREATE VIEW IF NOT EXISTS sync_health_summary AS
SELECT 
    component,
    COUNT(*) as total_metrics,
    AVG(CASE WHEN status = 'healthy' THEN 1 ELSE 0 END) as healthy_ratio,
    MAX(timestamp) as last_check
FROM _sync_health
WHERE timestamp > datetime('now', '-1 day')
GROUP BY component;

-- ================================================================
-- PROCEDIMIENTOS ALMACENADOS (si la base de datos los soporta)
-- ================================================================

-- Nota: SQLite no soporta procedimientos almacenados nativos,
-- pero se pueden crear funciones en la aplicación que ejecuten
-- estas consultas de forma conveniente.

-- ================================================================
-- CONSULTAS DE MANTENIMIENTO ÚTILES
-- ================================================================

-- Limpiar cola de sincronización completada (mantener últimos 7 días)
-- DELETE FROM _sync_queue 
-- WHERE status = 'completed' AND timestamp < datetime('now', '-7 days');

-- Estadísticas de uso
-- SELECT 
--     'Total Operaciones' as metric,
--     COUNT(*) as value
-- FROM _sync_queue
-- UNION ALL
-- SELECT 
--     'Operaciones Exitosas' as metric,
--     COUNT(*) as value
-- FROM _sync_queue 
-- WHERE status = 'completed'
-- UNION ALL
-- SELECT 
--     'Operaciones Fallidas' as metric,
--     COUNT(*) as value
-- FROM _sync_queue 
-- WHERE status = 'failed';

-- ================================================================
-- NOTAS PARA DESARROLLADORES
-- ================================================================
-- 
-- 1. Estas tablas se crearán automáticamente al inicializar 
--    el sistema de sincronización de CRUDTemplate v1.1
-- 
-- 2. Los metadatos iniciales pueden ser modificados desde la 
--    configuración del proyecto
-- 
-- 3. Los triggers de limpieza mantendrán el rendimiento óptimo
--    eliminando datos antiguos automáticamente
-- 
-- 4. Las vistas proporcionan acceso rápido a información importante
--    para el monitoreo del sistema
-- 
-- 5. En caso de error en la creación de triggers, el sistema 
--    funcionará correctamente pero sin limpieza automática
-- 
-- ================================================================