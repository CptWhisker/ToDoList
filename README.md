# ToDoList App

## Overview

The ToDoList app is a task management application built using UIKit and VIPER architecture. The app allows users to manage their tasks, with capabilities for adding, editing, and deleting tasks, as well as filtering tasks by their status. The app integrates Core Data for persistent storage and utilizes network services to fetch initial data.

## Key Features

- **Task Management**: Create, edit, and delete tasks. Each task includes a title, description, creation date, and status (completed or not completed).
- **Task Filtering**: Filter tasks by status (All, Completed, Incompleted) with custom buttons showing filter counts.
- **Core Data Integration**: Persistent storage of tasks and categories using Core Data. Tasks are deleted if they are not relevant for the current day.
- **Networking**: Fetch initial task data from the DummyJSON API.
- **VIPER Architecture**: Structured codebase with distinct modules for view, interactor, presenter, and router.

## Technical Skills

- **VIPER Architecture**: Implements the VIPER pattern to separate concerns and improve code maintainability.
- **Core Data Service**: Uses Core Data for managing persistent storage and data operations.
- **Network Service**: Utilizes `URLSession` and `Codable` for fetching and decoding data from a RESTful API.
- **Custom UI Components**: Includes custom UI components like `PaddedTextField` and `FilterButton` for enhanced user interaction.
- **Progress HUD**: Implements a custom `loadingHUD` class for managing loading indicators with `ProgressHUD`.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ToDoList.git
