# Escoria 25 Plugin Guide / Guía del Plugin Escoria 25

---

# English Version

## Description

**Escoria 25** is a plugin for [Godot Engine](https://godotengine.org/) that aims to **unify and simplify** the configuration of various existing Escoria plugins.

Its purpose is to centralize project settings for games developed with Escoria.

---

## Installation

1. **Download the plugin** from GitHub or Godot Asset Store.
2. Copy the plugin into your project folder:

   ```bash
   res://addons/escoria/
   ```
3. Open your project in Godot and navigate to:
   **Project > Project Settings > Plugins**
4. **Enable** the **Escoria 25** plugin.
5. Once enabled, it is recommended to reload the project (**Project > Reload Current Project**) or restart Escoria.

---

## Configuration

Activating the plugin will create new categories in **Project Settings** to configure different aspects of Escoria.

### Configuration Table

| Category       | Setting Name                      | Type             | Description                                   |
| -------------- | --------------------------------- | ---------------- | --------------------------------------------- |
| Main           | application/run/main\_scene       | String (.tscn)   | Main scene of the game.                       |
|                | GAME\_START\_SCRIPT               | String (.esc)    | Initial script executed when the game starts. |
|                | COMMAND\_DIRECTORIES              | Array            | Custom command directories.                   |
|                | SAVEGAMES\_PATH                   | String (dir)     | Folder where saved games are stored.          |
|                | SETTINGS\_PATH                    | String (dir)     | Folder for game settings.                     |
|                | TEXT\_LANG                        | String           | Default language for texts.                   |
|                | VOICE\_LANG                       | String           | Default language for voices.                  |
|                | GAME\_VERSION                     | String           | Game version.                                 |
|                | FORCE\_QUIT                       | Bool             | Force immediate game exit.                    |
|                | ACTION\_DEFAULT\_SCRIPT           | String (.esc)    | Default action script.                        |
| Debug          | TERMINATE\_ON\_WARNINGS           | Bool             | Terminate on warnings.                        |
|                | TERMINATE\_ON\_ERRORS             | Bool             | Terminate on errors.                          |
|                | DEVELOPMENT\_LANG                 | String           | Main development language.                    |
|                | LOG\_LEVEL                        | Enum             | Log level: ERROR, WARNING, INFO, DEBUG.       |
|                | LOG\_FILE\_PATH                   | String (dir)     | Path to save log files.                       |
|                | CRASH\_MESSAGE                    | Multiline String | Message shown on game crash.                  |
|                | ENABLE\_ROOM\_SELECTOR            | Bool             | Enable room/scene selector in debug.          |
|                | ROOM\_SELECTOR\_ROOM\_DIR         | String (dir)     | Folder with scenes for room selector.         |
|                | ENABLE\_HOVER\_STACK\_VIEWER      | Bool             | Shows stack trace on hover.                   |
| UI             | DEFAULT\_DIALOG\_TYPE             | String           | Default dialog type.                          |
|                | GAME\_SCENE                       | Enum             | UI type: keyboard, mouse, 9verbs.             |
|                | UI\_SCRIPT                        | String (.gd)     | Active UI script based on type.               |
|                | INVENTORY\_ITEMS\_PATH            | String (dir)     | Folder with inventory items.                  |
|                | INVENTORY\_ITEM\_SIZE             | Vector2          | Inventory item size.                          |
|                | DEFAULT\_TRANSITION               | String           | Default transition type.                      |
|                | TRANSITION\_PATHS                 | Array of dirs    | Folders with transition scenes.               |
| Sound          | MASTER\_VOLUME                    | Float (0-1)      | Master volume.                                |
|                | MUSIC\_VOLUME                     | Float (0-1)      | Music volume.                                 |
|                | SFX\_VOLUME                       | Float (0-1)      | SFX volume.                                   |
|                | SPEECH\_VOLUME                    | Float (0-1)      | Speech volume.                                |
|                | SPEECH\_ENABLED                   | Bool             | Enable/disable speech.                        |
|                | SPEECH\_FOLDER                    | String (dir)     | Folder for speech files.                      |
|                | SPEECH\_EXTENSION                 | String           | Speech file extension (e.g., ogg).            |
| Platform       | SKIP\_CACHE                       | Bool             | Skip cache for generic scenes.                |
|                | SKIP\_CACHE\_MOBILE               | Bool             | Skip cache on mobile platforms.               |
| Dialog Manager | DIALOG\_MANAGERS                  | String (.gd)     | List of dialog manager scripts.               |
|                | AVATAR                            | String (folder)  | Default avatar folder.                        |
|                | SPEED\_PER\_C                     | Float            | Text speed per character.                     |
|                | FAST\_TIME\_C                     | Float            | Fast text speed per character.                |
|                | READING\_SPEED\_IN\_WPM           | Float            | Reading speed in words/minute.                |
|                | TEXT\_TIME\_PER\_LETTER\_MS       | Float            | Time per letter in ms.                        |
|                | TEXT\_TIME\_PER\_LETTER\_MS\_FAST | Float            | Fast time per letter in ms.                   |
|                | STOP\_TALKING\_ANIMATION\_ON      | String           | Condition to stop talking animations.         |
|                | LEFT\_CLICK\_ACTION               | String           | Left click action (e.g., speed up text).      |
|                | CLEAR\_TEXT\_BY\_CLICK\_ONLY      | Bool             | Requires click to clear text.                 |

---

## Usage

1. Configure project settings according to your game.
2. Set main scene and starting script.
3. Adjust language, sounds, transitions, and UI.
4. Configure dialog manager and text speed if using dialogs.
5. Use debug options during development (room selector, logs).

---

# Versión en Español

## Descripción

**Escoria 25** es un plugin para [Godot Engine](https://godotengine.org/) que tiene como objetivo **reunificar y simplificar** la configuración de los distintos plugins de Escoria existentes.


Su propósito es centralizar la configuración de proyectos desarrollados con Escoria.

---

## Instalación

1. **Descargar el plugin** desde GitHub o Godot Asset Store.
2. Copiar el plugin en tu proyecto dentro de la carpeta:

   ```bash
   res://addons/escoria/
   ```
3. Abrir el proyecto en Godot y dirigirse a:
   **Project > Project Settings > Plugins**
4. **Activar** el plugin **Escoria 25**.
5. Una vez activado, se recomienda recargar el proyecto (**Project > Reload Current Project**) o reinicializar Escoria.

---

## Configuración

Al activar el plugin se crearán nuevas categorías en **Project Settings** para configurar distintos aspectos de Escoria.

### Tabla de Configuración

| Categoría      | Nombre                            | Tipo                | Descripción                                         |
| -------------- | --------------------------------- | ------------------- | --------------------------------------------------- |
| Main           | application/run/main\_scene       | String (.tscn)      | Escena principal del juego.                         |
|                | GAME\_START\_SCRIPT               | String (.esc)       | Script inicial que se ejecuta al comenzar el juego. |
|                | COMMAND\_DIRECTORIES              | Array               | Directorios con comandos personalizados.            |
|                | SAVEGAMES\_PATH                   | String (directorio) | Carpeta donde se guardan las partidas.              |
|                | SETTINGS\_PATH                    | String (directorio) | Carpeta para configuraciones del juego.             |
|                | TEXT\_LANG                        | String              | Idioma por defecto para los textos.                 |
|                | VOICE\_LANG                       | String              | Idioma por defecto para voces.                      |
|                | GAME\_VERSION                     | String              | Versión del juego.                                  |
|                | FORCE\_QUIT                       | Bool                | Forzar salida inmediata del juego.                  |
|                | ACTION\_DEFAULT\_SCRIPT           | String (.esc)       | Script de acción por defecto.                       |
| Debug          | TERMINATE\_ON\_WARNINGS           | Bool                | Terminar el juego si hay advertencias.              |
|                | TERMINATE\_ON\_ERRORS             | Bool                | Terminar el juego si hay errores.                   |
|                | DEVELOPMENT\_LANG                 | String              | Idioma principal de desarrollo.                     |
|                | LOG\_LEVEL                        | Enum                | Nivel de log: ERROR, WARNING, INFO, DEBUG.          |
|                | LOG\_FILE\_PATH                   | String (directorio) | Carpeta donde se guardan los logs.                  |
|                | CRASH\_MESSAGE                    | Multilínea          | Mensaje mostrado en caso de crash.                  |
|                | ENABLE\_ROOM\_SELECTOR            | Bool                | Habilitar selector de escenas en debug.             |
|                | ROOM\_SELECTOR\_ROOM\_DIR         | String (directorio) | Carpeta con escenas para selector.                  |
|                | ENABLE\_HOVER\_STACK\_VIEWER      | Bool                | Mostrar trazas de error al pasar el cursor.         |
| UI             | DEFAULT\_DIALOG\_TYPE             | String              | Tipo de diálogo por defecto.                        |
|                | GAME\_SCENE                       | Enum                | Tipo de interfaz: keyboard, mouse, 9verbs.          |
|                | UI\_SCRIPT                        | String (.gd)        | Script activo de la UI según tipo.                  |
|                | INVENTORY\_ITEMS\_PATH            | String (directorio) | Carpeta con ítems del inventario.                   |
|                | INVENTORY\_ITEM\_SIZE             | Vector2             | Tamaño de los ítems en el inventario.               |
|                | DEFAULT\_TRANSITION               | String              | Tipo de transición por defecto.                     |
|                | TRANSITION\_PATHS                 | Array de dirs       | Carpetas con escenas de transición.                 |
| Sound          | MASTER\_VOLUME                    | Float (0-1)         | Volumen maestro.                                    |
|                | MUSIC\_VOLUME                     | Float (0-1)         | Volumen de música.                                  |
|                | SFX\_VOLUME                       | Float (0-1)         | Volumen de efectos.                                 |
|                | SPEECH\_VOLUME                    | Float (0-1)         | Volumen de voces.                                   |
|                | SPEECH\_ENABLED                   | Bool                | Habilitar/deshabilitar voces.                       |
|                | SPEECH\_FOLDER                    | String (directorio) | Carpeta de archivos de voz.                         |
|                | SPEECH\_EXTENSION                 | String              | Extensión de los archivos de voz (ej. ogg).         |
| Platform       | SKIP\_CACHE                       | Bool                | Omitir cache de escenas genéricas.                  |
|                | SKIP\_CACHE\_MOBILE               | Bool                | Omitir cache en plataformas móviles.                |
| Dialog Manager | DIALOG\_MANAGERS                  | String (.gd)        | Lista de scripts de dialog manager.                 |
|                | AVATAR                            | String (directorio) | Carpeta de avatar por defecto.                      |
|                | SPEED\_PER\_C                     | Float               | Velocidad del texto por carácter.                   |
|                | FAST\_TIME\_C                     | Float               | Velocidad rápida por carácter.                      |
|                | READING\_SPEED\_IN\_WPM           | Float               | Velocidad de lectura en palabras/minuto.            |
|                | TEXT\_TIME\_PER\_LETTER\_MS       | Float               | Tiempo por letra en ms.                             |
|                | TEXT\_TIME\_PER\_LETTER\_MS\_FAST | Float               | Tiempo rápido por letra en ms.                      |
|                | STOP\_TALKING\_ANIMATION\_ON      | String              | Condición para detener animaciones de hablar.       |
|                | LEFT\_CLICK\_ACTION               | String              | Acción de clic izquierdo (ej. acelerar texto).      |
|                | CLEAR\_TEXT\_BY\_CLICK\_ONLY      | Bool                | Requiere clic para limpiar texto.                   |

---

## Uso

1. Configura los parámetros en **Project Settings** según tu juego.
2. Define la escena principal y el script inicial.
3. Ajusta idioma, sonidos, transiciones y UI.
4. Configura el dialog manager y la velocidad de texto si usas diálogos.
5. Usa las opciones de debug durante el desarrollo (selector de escenas, logs).
