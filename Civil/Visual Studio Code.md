Visual Studio Code
Docs
Updates
Blog
API
Extensions
FAQ
MCP
Switch to the dark theme
Search Docs
Download
Try MCP servers to extend agent mode in VS Code!

Dismiss this update
Overview
Setup
Get Started
Configure
Edit code
Build, Debug, Test
GitHub Copilot
Overview
Setup
Quickstart
Chat
Chat Overview
Chat Tutorial
Manage Context
Chat Modes
Ask Mode
Edit Mode
Agent Mode
MCP Servers
Inline Chat
Prompt Engineering
Code Completions
Copilot Coding Agent
Smart Actions
Customize Copilot
Language Models
Guides
Edit Notebooks with AI
Test with AI
Debug with AI
MCP Dev Guide
Tips and Tricks
FAQ
Reference
Source Control
Terminal
Languages
Node.js / JavaScript
TypeScript
Python
Java
C++
C#
Container Tools
Data Science
Intelligent Apps
Azure
Remote
Dev Containers
Reference
Use MCP servers in VS Code
Model Context Protocol (MCP) servers enable you to expand your chat experience in VS Code with extra tools for connecting to databases, invoking APIs, or performing specialized tasks. Model Context Protocol (MCP) is an open standard that enables AI models to interact with external tools and services through a unified interface. This article guides you through setting up MCP servers and using tools with agent mode in Visual Studio Code.

Prerequisites
Install the latest version of Visual Studio Code
Access to Copilot
What is MCP?
Model Context Protocol (MCP) provides a standardized way for AI models to discover and interact with external tools, applications, and data sources. When you enter a chat prompt to a language model with agent mode in VS Code, the model can invoke various tools to perform tasks like file operations, accessing databases, or calling APIs in response to your request.

How does MCP work?
Supported MCP capabilities in VS Code
Finding MCP servers
Enable MCP support in VS Code
Note
MCP support in VS Code is generally available starting from VS Code 1.102, but can be disabled by your organization.

Centrally manage MCP support
You have two options to centrally manage MCP support in your organization:

Device management: Centrally enable or disable MCP support in your organization via group policies or configuration profiles. Learn more about managing VS Code settings with device management.

GitHub Copilot policy: Control the availability of MCP servers in your organization with a GitHub Copilot policy. Learn more about Managing policies and features for Copilot in your enterprise in the GitHub Copilot documentation.

Add an MCP server
You have multiple options to add an MCP server in VS Code:

Direct installation: Visit the curated list of MCP servers and select Install on any MCP server to automatically add it to your VS Code instance.
Workspace settings: add a .vscode/mcp.json file in your workspace to configure MCP servers for a workspace and share configurations with team members.
User settings: specify the server in your user configuration (MCP: Open User Configuration) to enable the MCP server across all workspaces, synchronized via Settings Sync.
Automatic discovery: enable autodiscovery (chat.mcp.discovery.enabled) of MCP servers defined in other tools, such as Claude Desktop.
To view and manage the list of configured MCP servers, run the MCP: Show Installed Servers command from the Command Palette or visit the MCP SERVERS - INSTALLED section in the Extensions view.

After you add an MCP server, you can use the tools it provides in agent mode.

Caution
MCP servers can run arbitrary code on your machine. Only add servers from trusted sources, and review the publisher and server configuration before starting it.

Add an MCP server to your workspace
To configure an MCP server for a specific workspace, you can create a .vscode/mcp.json file in your workspace folder. This allows you to share the server configuration with project team members.

Important
Make sure to avoid hardcoding sensitive information like API keys and other credentials by using input variables or environment files.

To add an MCP server to your workspace:

Create a .vscode/mcp.json file in your workspace.

Select the Add Server button to add a template for a new server. VS Code provides IntelliSense for the MCP server configuration file.

The following example shows how to configure a Perplexity MCP server, where VS Code prompts you for the API key when the server starts. Learn more about the Configuration format.

{
  // 💡 Inputs are prompted on first server start, then stored securely by VS Code.
  "inputs": [
    {
      "type": "promptString",
      "id": "perplexity-key",
      "description": "Perplexity API Key",
      "password": true
    }
  ],
  "servers": {
    // https://github.com/github/github-mcp-server/
    "Github": {
      "url": "https://api.githubcopilot.com/mcp/"
    },
    // https://github.com/ppl-ai/modelcontextprotocol/
    "Perplexity": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "server-perplexity-ask"],
      "env": {
        "PERPLEXITY_API_KEY": "${input:perplexity-key}"
      }
    }
  }
}
Copy
Alternatively, run the MCP: Add Server command from the Command Palette, choose the type of MCP server to add and provide the server information. Next, select Workspace Settings to create the .vscode/mcp.json file in your workspace if it doesn't already exist.

Add an MCP server to your user configuration
To configure an MCP server for all your workspaces, you can add the server configuration to your user configuration. This allows you to reuse the same server configuration across multiple projects.

To add an MCP to your user configuration, run the MCP: Open User Configuration command, which opens the mcp.json file in your user profile. If the file does not exist, VS Code creates it for you.

Alternatively, use the MCP: Add Server command from the Command Palette, provide the server information, and then select Global to add the server configuration to your profile.

When you use multiple VS Code profiles, this allows you to switch between different MCP server configurations based on your active profile. For example, the Playwright MCP server could be configured in a web development profile, but not in a Python development profile.

Dev Container support
MCP servers can be configured in Dev Containers through the devcontainer.json file. This allows you to include MCP server configurations as part of your containerized development environment.

To configure MCP servers in a Dev Container, add the server configuration to the customizations.vscode.mcp section:

{
  "image": "mcr.microsoft.com/devcontainers/typescript-node:latest",
  "customizations": {
    "vscode": {
      "mcp": {
        "servers": {
          "playwright": {
            "command": "npx",
            "args": ["-y", "@microsoft/mcp-server-playwright"]
          }
        }
      }
    }
  }
}
Copy
When the Dev Container is created, VS Code automatically writes the MCP server configurations to the remote mcp.json file, making them available in your containerized development environment.

Automatic discovery of MCP servers
VS Code can automatically detect and reuse MCP servers that you defined in other tools, such as Claude Desktop.

Enable autodiscovery with the chat.mcp.discovery.enabled setting.

Configuration format
Use the following JSON configuration format to define MCP servers.

"servers": {}

Contains the list of MCP servers, and follows Claude Desktop's configuration format.

Specify the server name as the key and provide the server configuration as the value. VS Code shows the server name in the MCP server list. Follow these naming conventions for the server name:

Use camelCase for the server name, such as "uiTesting".
Avoid using whitespace or special characters.
Use a unique name for each server to avoid conflicts.
Use a descriptive name that reflects the server's functionality or brand, such as "github" or "database".
Provide the following fields in the server configuration. You can use predefined variables in the server configuration, for example to refer to the workspace folder (${workspaceFolder}).

Server configuration for `stdio`
Expand table
Field	Description	Examples
type	Server connection type.	"stdio"
command	Command to start the server executable. The command needs to be available on your system path or contain its full path.
If you use docker, don't use the detach option.	"npx","node", "python", "docker"
args	Array of arguments passed to the command.	["server.py", "--port", "3000"]
env	Environment variables for the server.	{"API_KEY": "${input:api-key}"}
envFile	Path to an .env from which to load additional environment variables.	"${workspaceFolder}/.env"
Server configuration for `sse` or `http`
"inputs": []

Lets you define custom placeholders for configuration values to avoid hardcoding sensitive information, such as API keys or passwords in the server configuration.

VS Code prompts you for these values when the server starts for the first time, and securely stores them for subsequent use. To avoid showing the typed value, set the password field to true.

Learn more about how to configure input variables in VS Code.

Configuration example
The following code snippet shows an example MCP server configuration that specifies three servers and defines an input placeholder for the API key.

View `.vscode/mcp.json`
Use MCP tools in agent mode
Once you have added an MCP server, you can use the tools it provides in agent mode.

To use MCP tools in agent mode:

Open the Chat view (Ctrl+Alt+I), and select Agent mode from the dropdown.

Agent mode dropdown option

Select the Tools button to view the list of available tools.

Optionally, select or deselect the tools you want to use. You can search tools by typing in the search box.

MCP tools list

Important
A chat request can have a maximum of 128 tools enabled at a time. If you have more than 128 tools selected, reduce the number of tools by deselecting some tools in the tools picker.

You can now enter a prompt in the chat input box and notice how tools are automatically invoked as needed.

By default, when a tool is invoked, you need to confirm the action before it is run. This is because tools might run locally on your machine and might perform actions that modify files or data.

Use the Continue button dropdown options to automatically confirm the specific tool for the current session, workspace, or all future invocations.

MCP Tool Confirmation

Tip
You can also directly reference a tool in your prompt by typing # followed by the tool name. You can do this in all chat modes (ask, edit, and agent mode).

Optionally, verify and edit the tool input parameters before running the tool.

MCP Tool Input Parameters

MCP elicitations
MCP servers can request additional input from you through elicitations. When an MCP server needs more information to complete a task, it can prompt you for specific details, such as confirmations, configuration values, or other parameters required for the operation.

When an MCP server sends an elicitation request, VS Code presents you with a dialog or input field where you can provide the requested information. This allows MCP servers to gather necessary data dynamically without requiring all configuration to be set up in advance.

Use MCP resources
In addition to tools, MCP servers can also provide resources that you can use as context in your chat prompts. For example, a file system MCP server might provide access to files and directories, or a database MCP server might provide access to database tables.

To add a resource from an MCP server to your chat prompt:

In the Chat view, select Add Context > MCP Resources

Select a resource type from the list and provide optional resource input parameters.

Screenshot of the MCP resource Quick Pick, showing resource types provided by the GitHub MCP server.

To view the list of available resources for an MCP server, use the MCP: Browse Resources command or use the MCP: List Servers > Browse Resources command to view resources for a specific server.

MCP tools can return resources as part of their response. You can view or save these resources to your workspace with the Save button or by dragging and dropping the resource to the Explorer view.

Use MCP prompts
MCP servers can provide preconfigured prompts for common tasks, so you don't have to type an elaborate chat prompt. You can directly invoke these prompts in the chat input box by typing / followed by the prompt name, formatted as mcp.servername.promptname. Optionally, the prompt might ask you for additional input parameters.

Screenshot of the Chat view, showing an MCP prompt invocation and a dialog asking for additional input parameters.

Group related tools in a tool set
As you add more MCP servers, the list of tools can become long. This can make it tedious to manage individual tools, for example when you want to define a reusable prompt file or a custom chat mode.

To help you manage tools, you can group related tools into a tool set. A tool set is a collection of individual tools that you can refer to as a single entity. A tool set can contain built-in tools, MCP tools, or tools provided by extensions.

Learn more about how to create and use tool sets in VS Code.

Manage MCP servers
You can manage the list of installed MCP servers from the MCP SERVERS - INSTALLED section in the Extensions view (Ctrl+Shift+X) in VS Code. This dedicated view makes it easy to monitor, configure, and control your installed MCP servers.

Screenshot showing the MCP servers in the Extensions view.

Right-click on an MCP server or select the gear icon to perform the following actions:

Start/Stop/Restart: Start, stop, or restart the MCP server.
Disconnect Account: Disconnect the account for authentication with the MCP server.
Show Output: View the server logs to diagnose issues.
Show Configuration: View the MCP server configuration.
Configure Model Access: Configure which models the MCP server can access (sampling).
Show Sampling Requests: View the sampling requests made by the MCP server.
Browse Resources: View the resources provided by the MCP server.
Uninstall: Uninstall the MCP server from your environment.
Alternatively, run the MCP: List Servers command from the Command Palette to view the list of configured MCP servers. You can then select a server and perform actions on it.

Tip
When you open the .vscode/mcp.json file via MCP: Open Workspace Folder MCP Configuration, VS Code shows commands to start, stop, or restart a server directly from the editor.

MCP server configuration with lenses to manage server.

Command-line configuration
You can also use the VS Code command-line interface to add an MCP server to your user profile or to a workspace.

To add an MCP server to your user profile, use the --add-mcp command line option, and provide the JSON server configuration in the form {\"name\":\"server-name\",\"command\":...}.

code --add-mcp "{\"name\":\"my-server\",\"command\": \"uvx\",\"args\": [\"mcp-server-fetch\"]}"
Copy
URL handler
VS Code also includes a URL handler that you can use to install an MCP server. To form the URL, construct an obj object in the same format as you would provide to --add-mcp, and then create the link by using the following logic:

// For Insiders, use `vscode-insiders` instead of `code`
const link = `vscode:mcp/install?${encodeURIComponent(JSON.stringify(obj))}`;
Copy
This link can be used in a browser, or opened on the command line, for example via xdg-open $LINK on Linux.

Synchronize MCP servers across devices
With Settings Sync enabled, you can synchronize settings and configurations across devices, including MCP server configurations. This allows you to maintain a consistent development environment and access the same MCP servers on all your devices.

To enable MCP server synchronization with Settings Sync, run the Settings Sync: Configure command from the Command Palette, and ensure that MCP Servers is included in the list of synchronized configurations.

Troubleshoot and debug MCP servers
MCP output log
When VS Code encounters an issue with an MCP server, it shows an error indicator in the Chat view.

MCP Server Error

Select the error notification in the Chat view, and then select the Show Output option to view the server logs. Alternatively, run MCP: List Servers from the Command Palette, select the server, and then choose Show Output.

MCP Server Error Output

Debug an MCP server
You can enable development mode for MCP servers by adding a dev key to the MCP server configuration. This is an object with two properties:

watch: A file glob pattern to watch for files change that will restart the MCP server.
debug: Enables you to set up a debugger with the MCP server.
{
  "servers": {
    "gistpad": {
      "command": "node",
      "args": ["build/index.js"],
     "dev": {
       "watch": "build/**/*.js",
       "debug": { "type": "node" }
     },
Copy
Note
We currently only support debugging Node.js and Python servers launched with node and python respectively.

Frequently asked questions
Can I control which MCP tools are used?
Yes, you have several options to control which tools are active:

Select the Tools button in the Chat view when in agent mode, and toggle specific tools on/off as needed.
Add specific tools to your prompt by using the Add Context button or by typing #.
For more advanced control, you can use .github/copilot-instructions.md to fine-tune tool usage.
The MCP server is not starting when using Docker
Verify that the command arguments are correct and that the container is not running in detached mode (-d option). You can also check the MCP server output for any error messages (see Troubleshooting).

I'm getting an error that says "Cannot have more than 128 tools per request."
A chat request can have a maximum of 128 tools enabled at a time due to model constrains. If you have more than 128 tools selected, reduce the number of tools by deselecting some tools or whole servers in the tools picker in the Chat view.

Screenshot showing the Chat view, highlighting the Tools icon in the chat input and showing the tools Quick Pick where you can select which tools are active.

Related resources
VS Code curated list of MCP servers
Model Context Protocol Documentation
Model Context Protocol Server repository
Use agent mode in Visual Studio Code
Was this documentation helpful?
Yes, this page was help
fulNo, this page was not helpful
07/09/2025
On this page there are 15 sectionsOn this page
Prerequisites
What is MCP?
Enable MCP support in VS Code
Add an MCP server
Configuration format
Use MCP tools in agent mode
MCP elicitations
Use MCP resources
Use MCP prompts
Group related tools in a tool set
Manage MCP servers
Synchronize MCP servers across devices
Troubleshoot and debug MCP servers
Frequently asked questions
Related resources
RSSRSS Feed
StackoverflowAsk questions
TwitterFollow @code
GitHubRequest features
IssuesReport issues
YouTubeWatch videos
Follow us on X VS Code on Github VS Code on YouTube
Microsoft homepage
Support Privacy Terms of Use License