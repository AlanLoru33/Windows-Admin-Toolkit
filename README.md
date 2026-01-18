# 🛠️ Windows Admin & Support Toolkit (WAST)
**By Alan Luciano Loru**

Colección de herramientas de automatización de alto impacto diseñadas para entornos de alta criticidad (**Soporte Tier 2 / SOC**). Estos scripts optimizan el tiempo de respuesta (MTTR) y estandarizan procedimientos de seguridad y mantenimiento.

## 📂 Contenido del Repositorio

### 🚀 [Master Suite de Soporte Técnico v11.0](./Suites-Integrales/)
La herramienta principal de diagnóstico.
- **Acceso Seguro:** Control de acceso mediante contraseña para personal técnico.
- **Modo Seguro:** Lógica adaptativa que detecta el entorno de arranque.
- **Módulos:** Reparación de imagen (DISM), respaldo de drivers y gestión de boot.

### 🧹 [Ultimate Purge & Clean Suite v12.0](./Mantenimiento/)
Script orientado a la higiene profunda del sistema.
- **Component Cleanup:** Ejecuta purgas de WinSxS para liberar espacio real.
- **RAM Optimization:** Liberación de memoria residual (Doofy Style).
- **Event Log Purge:** Limpieza de registros de eventos para auditorías limpias.

### ⚡ [Centro de Control Híbrido](./Suites-Integrales/)
Integración de herramientas de terceros y optimización de latencia de red.

---

## 🛡️ Instrucciones de Ejecución
Debido a las políticas de ejecución de PowerShell, se recomienda correr los scripts con el siguiente comando:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "NombreDelScript.ps1"
