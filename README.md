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
| Main           | GAME_START_SCRIPT                 | PATH   (.esc)    | Initial script executed when the game starts. |
|                | COMMAND_DIRECTORIES               | Array            | Custom command directories.                   |
|                | SAVEGAMES_PATH                    | PATH   (dir)     | Folder where saved games are stored.          |
|                | SETTINGS_PATH                     | PATH   (dir)     | Folder for game settings.                     |
|                | TEXT_LANG                         | String           | Default language for texts.                   |
|                | VOICE_LANG                        | String           | Default language for voices.                  |
|                | GAME_VERSION                      | String           | Game version.                                 |
|                | FORCE_QUIT                        | Bool             | Force immediate game exit.                    |
|                | ACTION_DEFAULT_SCRIPT             | PATH   (.esc)    | Default action script.                        |
| Debug          | TERMINATE_ON_WARNINGS             | Bool             | Terminate on warnings.                        |
|                | TERMINATE_ON_ERRORS               | Bool             | Terminate on errors.                          |
|                | DEVELOPMENT_LANG                  | String           | Main development language.                    |
|                | LOG_LEVEL                         | Enum             | Log level: ERROR, WARNING, INFO, DEBUG, TRACE |
|                | LOG_FILE_PATH                     | PATH   (dir)     | Path to save log files.                       |
|                | CRASH_MESSAGE                     | Multiline String | Message shown on game crash.                  |
|                | ENABLE_ROOM_SELECTOR              | Bool             | Enable room/scene selector in debug.          |
|                | ROOM_SELECTOR_ROOM_DIR            | PATH   (dir)     | Folder with scenes for room selector.         |
|                | ENABLE_HOVER_STACK_VIEWER         | Bool             | Shows stack trace on hover.                   |
| UI             | DEFAULT_DIALOG_TYPE               | String           | FLOATING / AVATAR                             |
|                | GAME_UI                           | PATH   (dir)     | UI type: keyboard, mouse, 9-verbs.            |
|                | UI_SCRIPT                         | String (.gd)     | Active UI script based on type.               |
|                | INVENTORY_ITEMS_PATH              | PATH   (dir)     | Folder with inventory items.                  |
|                | INVENTORY_ITEM_SIZE               | Vector2          | Inventory item size.                          |
|                | DEFAULT_TRANSITION                | String           | Default transition type.                      |
|                | TRANSITION_PATHS                  | Array of dirs    | Folders with transition scenes.               |
| Sound          | MASTER_VOLUME                     | Float (0-1)      | Master volume.                                |
|                | MUSIC_VOLUME                      | Float (0-1)      | Music volume.                                 |
|                | SFX_VOLUME                        | Float (0-1)      | SFX volume.                                   |
|                | SPEECH_VOLUME                     | Float (0-1)      | Speech volume.                                |
|                | SPEECH_ENABLED                    | Bool             | Enable/disable speech.                        |
|                | SPEECH_FOLDER                     | PATH   (dir)     | Folder for speech files.                      |
|                | SPEECH_EXTENSION                  | String           | Speech file extension (e.g., ogg).            |
| Platform       | SKIP_CACHE                        | Bool             | Skip cache for generic scenes.                |
|                | SKIP_CACHE_MOBILE                 | Bool             | Skip cache on mobile platforms.               |
| Dialog Manager | AVATAR_PATH                       | PATH   (folder)  | Default avatar folder.                        |
|                | SPEED_PER_C                       | Float            | Text speed per character.                     |
|                | FAST_TIME_C                       | Float            | Fast text speed per character.                |
|                | MAX_TIME_C                        | Float            | Maximum time for text display.                |
|                | READING_SPEED_IN_WPM              | Float            | Reading speed in words/minute.                |
|                | TEXT_TIME_PER_LETTER_MS           | Float            | Time per letter in ms.                        |
|                | TEXT_TIME_PER_LETTER_MS_FAST      | Float            | Fast time per letter in ms.                   |
|                | STOP_TALKING_ANIMATION_ON         | String           | Condition to stop talking animations.         |
|                | LEFT_CLICK_ACTION                 | String           | Left click action (e.g., speed up text).      |
|                | CLEAR_TEXT_BY_CLICK_ONLY          | Bool             | Requires click to clear text.                 |
|                | UI_TYPE                           | String           | Keyboard, mouse or 9verbs.                    |

---

## Usage

1. Configure project settings according to your game.  
2. Set main scene and starting script.  
3. Adjust language, sounds, transitions, and UI.  
4. Configure dialog manager and text speed if using dialogs.  
5. Use debug options during development (room selector, logs).  
6. If your game supports multiple languages, configure localization using Godot's built-in methods.

### Example: Setting start script and language

```gdscript
# Example of accessing settings in code
var start_script = ProjectSettings.get_setting("escoria/main/game_start_script")
var lang = ProjectSettings.get_setting("escoria/main/text_lang")
print("Game starts with:", start_script, " - Language:", lang)
```

---

## Additional Notes

- **UI Systems Included**:  
  Escoria 25 includes preconfigured UIs for:  
  - **Keyboard** (navigable menus and actions)  
  - **Mouse** (point & click interaction)  
  - **9 Verbs** (classic SCUMM-like interface)  

- **Dialog Display Modes**:  
  - **Floating** → The text appears at the dialog position assigned to the character.  
  - **Avatar** → A dialog box appears with the character’s avatar image, if one exists.  
    - Avatars must be defined as `.tres` files with the **same name as the character’s ID**.  

- **Directions Handling**:  
  This version manages directions differently:  
  - `0º` → South  
  - `90º` → Right  
  - `180º` → Left  
  (Useful for animations and navigation logic.)  

---

## Contributing

Contributions are welcome! 
If you find bugs, have feature requests, or want to improve documentation:  

1. Open an issue in the GitHub repository.  
2. Submit a Pull Request with your improvements.  

---

## License

This project is licensed under the **MIT License**.  

---

### Attribution Notice

This plugin has been developed using material from the official **Escoria** project.  
All original content and artwork belong to:

**Copyright (c) 2012-2020 Juan Linietsky, Ariel Manzur.**

The original Escoria content is licensed under the MIT License.  

---

### Publication

This version of the plugin is distributed **open source** and **without commercial purposes**, with the sole intent of contributing to the Escoria and Godot communities.

---

# Versión en Español

## Descripción

**Escoria 25** es un plugin para [Godot Engine](https://godotengine.org/) que busca **unificar y simplificar** la configuración de los diferentes plugins de Escoria.  

Su propósito es centralizar los ajustes del proyecto en un único lugar, facilitando el desarrollo de aventuras gráficas.

---

## Instalación

1. **Descarga el plugin** desde GitHub o Godot Asset Store.  
2. Copia el plugin en la carpeta de tu proyecto:  

   ```bash
   res://addons/escoria/
   ```
3. Abre tu proyecto en Godot y ve a:  
   **Proyecto > Configuración del Proyecto > Plugins**
4. **Activa** el plugin **Escoria 25**.  
5. Se recomienda recargar el proyecto (**Proyecto > Recargar Proyecto Actual**) o reiniciar Escoria tras activarlo.

---

## Configuración

Al activar el plugin, se crean nuevas categorías en **Configuración del Proyecto**, donde podrás ajustar los diferentes aspectos de Escoria.  

### Tabla de Configuración

*(ver sección en inglés para la tabla completa, es idéntica en español con nombres de campos en inglés)*

---

## Uso

1. Ajusta la configuración según tu juego.  
2. Define la escena principal y el script inicial.  
3. Configura idioma, sonidos, transiciones y UI.  
4. Si usas diálogos, configura el gestor de diálogos y la velocidad del texto.  
5. Usa las opciones de depuración durante el desarrollo (selector de escenas, logs).  
6. Para juegos multilenguaje, configura la localización con las herramientas propias de Godot.

### Ejemplo: Obtener configuraciones en código

```gdscript
var script_inicio = ProjectSettings.get_setting("escoria/main/game_start_script")
var idioma = ProjectSettings.get_setting("escoria/main/text_lang")
print("Juego inicia con:", script_inicio, " - Idioma:", idioma)
```

---

## Notas adicionales

- **Sistemas de UI incluidos**:  
  - **Teclado**  
  - **Ratón (point & click)**  
  - **9 verbos** (interfaz estilo SCUMM)  

- **Modos de diálogo**:  
  - **Floating** → El texto aparece en la posición de diálogo asignada al personaje.  
  - **Avatar** → Aparece un cuadro con el avatar del personaje, si existe un `.tres` con el mismo nombre que la ID del personaje.  

- **Direcciones**:  
  - `0º` = Sur  
  - `90º` = Derecha  
  - `180º` = Izquierda  

---

## Contribución

¡Se aceptan contribuciones! 🎉  
Puedes colaborar abriendo un **issue** o enviando un **Pull Request** en el repositorio de GitHub.  

---

## Licencia

Este proyecto se distribuye bajo la licencia **MIT**.  

---

### Aviso de atribución

Este plugin se ha desarrollado utilizando material del proyecto oficial **Escoria**.  
Todo el contenido original y el arte pertenecen a:

**Copyright (c) 2012-2020 Juan Linietsky, Ariel Manzur.**

El contenido original de Escoria está licenciado bajo la licencia MIT.  

---

### Publicación

Esta versión del plugin se distribuye como **open source** y **sin fines comerciales**, con el único objetivo de contribuir a las comunidades de Escoria y Godot.
