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

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/4e32ed5b-c9ea-4683-a30e-3279b9710645" alt="Task List" width="300"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/8b33d31f-b4de-4082-a128-7c1b657dbbb6" alt="Task Detail" width="300"/>
</p>

<p align="center">
  <b>Task List</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Task Detail</b>
</p>

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ToDoList.git
