---
title: README
description: author: primary_desktop
categories: created: 2024-07-27T19:41:58-0800
updated: 2024-07-27T22:22:50-0800
version: 1.1.1
---
# Todoist.Nvim

_Project Status_: Project is still under active construction, please only install if you plan to help build out the structures with me, this is not intended for end-users yet

Todoist.nvim is an (relatively) unopinionated wrapper around the Todoists' Sync API with the ability for users to:
- Review
- Update
- Create
- And Delete
  All todoist objects entirely from a Neovim buffer. Heavily inspired by oil.nvim, Todoist.nvim intends to leverage the users' existing knowledge of text editing and traditional file management techniques to create a fully-featured client into the Todoist Service.

## Why do this?

Todoist is my primary GTD-based productivity manager. In my humble opinion, it is the best private productivity service on the market currently, especially when considering the relatively low cost of the premium service, as well as the generous free tier.

The only problem is that all work is intended to go through the traditional todoist web interface, and while this is fine on mobile, and the team has gone out of their way to be more keyboard-friendly than most web applications, I have still yearned for a way to manage my Todoist project structure from Neovim which is where the rest of my workflow lives.

Specifically, I wanted to be able to easily create, update, and delete Todoist objects using the same techniques that i use within my editor to enable easier management than the traditional web format affords me (think deleting multiple projects at once)

In addition, this felt like a good opportunity to leverage existing Neovim abstractions and mechanisms in service of something closer to a sub-application rather than a single filetype.

Another smaller sub-project (pun-intended) that has arisen out of this has been the creation of a new `projects` filetype that allows for a compact, user-readable format to translate Todoist objects into. This is all powered using tree-sitter to handle everything from highlighting to folding. The spec, as well as the grammer itself was moved to another project to leave open the possibility of incorporating it into the main treesitter repository if there was enough interest.


## Installation

Efforts have been taken to keep the list of dependencies small:
- plenary.nvim
    - Handles both forging requests as well as supplying a test harness
- tree-sitter-projects
    - My custom treesitter grammer for the new `projects` filetype.
    - necessary, since it provides highlighting, indentation, and folding rules which are the primary mechanisms used within the UI to help users manage list length

This can all be done in your package manager of choice as this is all done from github repositories

**Lazy**:
```lua
{
 "ca-mantis-shrimp/Todoist.nvim",
 dependencies = {
  "nvim-lua/plenary.nvim",
  "ca-mantis-shrimp/tree-sitter-projects",
 },
 config = { api_key = vim.env.TODOIST_API_KEY },
}
```
The only necessary part of configuration is supplying your Todoist API key. This can be extracted from the Todoist web api and from there, I recommend saving it to an environment variable(shown above), a secret manager, ANYTHING other than hard-coding this into your configuration as this is likely to get committed if you keep your configuration under version control 

Until this repository gets pulled into the main treesitter one, treesitter needs to be configured to utilize the installed manually
```lua
-- Important for tree-sitter parsers installed after the original plugin
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.projects = {
 install_info = {
  url = vim.fn.stdpath("data") .. "/lazy/tree-sitter-projects",
  files = { "src/parser.c" },
 },
 filetype = "projects",
}
```
If you want to this plugin as a dependency to treesitter, you can configure this parser upon installation of treesitter.
Otherwise, this snippet above is the easiest way to ensure that the parser is configured properly and that all necessary hooks. 
You know this worked because you will be able to run `TSInstall projects` successfully after initial configuration and can also use the normal Treesitter mechanisms to manage the parser like you would any other treesitter parser

With that, you should be ready to move onto workflow

## Workflow

Out of the box, we have a few commands intended to run the entire workflow:
- [x] `TodoistFullSync`
- [ ] `TodoistIncrementalSync`
- [x] `OpenTodoistProjectFile`
- [ ] `TodoistSendCommands`

Here is a visualization of the workflow from start to finish assuming you are working from a new machine:
```mermaid
stateDiagram
[*] --> Installation
[*] --> MobileEdit

Installation --> FullSync
FullSync --> OpenProjectFile

MobileEdit --> IncrementalSync
OpenProjectFile --> UpdateBuffer
UpdateBuffer --> SendCommands
SendCommands --> IncrementalSync
IncrementalSync --> UpdateBuffer
```
1. Your very first time you run the plugin on any machine, you should run `TodoistFullSync`, at which point, your entire Todoist structure will be downloaded via the Sync Api, and stored in your `cache` directory as dictated by neovim.
2. Next, you can use `OpenTodoistProjectFile` to jump to the proper file to edit and review
    1. You can also simply edit the file created at `XDG_CACHE_DIR/nvim/Todoist/client_todoist.projects`
3. After you have made some changes to any items in the buffer, run `TodoistSendCommands` to have your commands sent to the server.
    1. You may continue to make edits, sending commands every once in awhile and any failures will also be logged in the cache
    2. whenever you are ready, simply run `TodoistIncrementalSync` to get the newest Todoist updates and have your changes properly reflected in the buffer
4. Finally, `TodoistIncrementalSync` is useful when pulling changes that were put in
    1. either through another device (IE mobile, the web portal, another device running this plugin, etc...)
    2. or through the `TodoistSendCommands` command
    3. However, `TodoistFullSync` can also serve as an emergency lever in the case of errors, as it will overwrite all existing data and ensure that you are up-to-date with the latest changes in your account

If all goes well, you will spend the majority of your time in that loop in the workflow, updating your Todoist projects, sending your updates as commands, and requesting incremental syncs occasionally when you have more internet connection

This workflow is intended to meet a few requirements:
- Allows users control over the workflow, choosing whether they want to make many updates at once or send many small chunks of updates
- emphasis on incremental syncing facilitates an offline-first workflow to make it easier to work on your task list when away from internet
- Making these as commands allows the user to decide when they do each part of the process and allows a few escape hatches with the use of full syncs when necessary


### Sharpening your workflow

To facilitate more rapid workflows, users are encouraged to decide the automation format that works best for them.

The default approach would likely be to perform both a send and incremental sync command at the same time whenever the user saves the buffer.


## Architecture

Todoist has done a good job of implementing a REST api workflow that minimizes the amount of requests that need to be sent as  a client, and the fact that we are working with the sync api ensures that we have all the context necessary whenever we are working with our Todoist state


### Modeling the relationship

The relationship flow can be seen below:
```mermaid
sequenceDiagram
NeovimClient->>TodoistServer: Sends Full Sync Request
TodoistServer-->>NeovimClient: Sends Full Sync Response
NeovimClient->>TodoistServer: Sends Update Commands Request
TodoistServer-->>NeovimClient: Sends Command Result Response
NeovimClient->>TodoistServer: Sends Incremental Sync Request
TodoistServer-->>NeovimClient: Sends Incremental Sync Response
```
