# EasyBot

A Fast, Simple, Experimental Chatbot Framework Using IRIS Vector Search.

## The Goal

Can we create a framework for Object Script and Embedded Python that allows us to perform
actions and request information that feels more like a conversation (i.e. chatbot) instead
of traditional menu-driven interfaces?

The core EasyBot framework does the heavy lifting of mapping user prompts to targeted
actions.  Custom actions (and groups of actions) are easy for developers to install
and develop. 

## InterSystems AI Programming Contest: Vector Search, GenAI and AI Agents
This library was originally created/published for the [InterSystems AI Programming Contest: Vector Search, GenAI and AI Agents](https://community.intersystems.com/post/intersystems-ai-programming-contest-vector-search-genai-and-ai-agents).

## Prerequisites
- IRIS 2022.1+ (for Embedded Python support)
- Python 3 installed on the system

## Installation

There are several methods for installing this library:
1. Import classes directly into IRIS
2. Install the IPM/ZPM package 
3. Docker

### Option 1: Import Classes Directly into IRIS

Download the most recent `exports/easybot.Export.xml` from the repository.

Import `easybot.Export.xml` into your IRIS instance using the **Import** button found on the **System Operation > Classes** page in your Management Portal.

If you prefer loading `easybot.Export.xml` from an IRIS terminal:

```cls
USER>do $system.OBJ.Load("/path/to/easybot.Export.xml", "cuk")
```
### Option 2: Install the IPM/ZPM package 

Once package is approved, use `zpm` install the `easybot` package:
```cls
USER>zpm

=============================================================================
|| Welcome to the Package Manager Shell (ZPM). version 0.7.4               ||
|| Enter q/quit to exit the shell. Enter ?/help to view available commands ||
|| Current registry https://pm.community.intersystems.com                  ||
=============================================================================
zpm:USER>install easybot
```
### Option 3: Docker

If you prefer, you can load the library with docker, run the built-in tests, and experiment with the `easybot` classes.

First, download/clone the repo to your local computer:

```bash
git clone git@github.com:jamerfort/iris-easybot.git
```
Build and connect to your instance:

```bash
cd ./iris-easybot

# Rebuild/start the image
docker compose up --build -d

# Connect to your instance
docker exec -it iris-easybot-iris-1 iris terminal IRIS

# Load EasyBot classes
USER>zn "IRISAPP"
IRISAPP>do $system.OBJ.LoadDir("/home/irisowner/dev/src/cls","cuk",,1)

# Load EasyBot Agents
IRISAPP>do ##class(easybot.core.Loader).Load()

# Enjoy EasyBot
IRISAPP>do ##class(easybot.core.Shell).Run()
How can I help you?
>>> list namespaces
    | Choose one of these options...
      1. List Namespaces (.86)
      2. Namespaces Menu (.86)
      3. Filter Namespaces (.82)
>>> 1
    | Here are the namespaces I found:
    | 
    | - Namespace1
    | - Namespace2
    | - Namespace3


# Stop your containers
docker compose down 
```
## Verify/Test Installation

To verify installation, run the following commands:
```cls
USER>do ##class(easybot.core.Shell).Run()
How can I help you?
>>> I need help with namespaces
    | Choose one of these options...
      1. List Namespaces (.86)
      2. Namespaces Menu (.85)
      3. Filter Namespaces (.82)
>>> 3
    | Here are the filtered namespaces:
    | 
    | - FilteredNS1
    | - FilteredNS3
>>> 
```

## Description
When researching the current landscape of AI and RAG (Retrieval-Augmented Generation), it seemed that a core requirement is the ability to map phrases, sentences, and documents to a vector.  This process of mapping inputs to a vector is called embedding.

Realizing that embedding is critical to AI solutions, I began to experiment with the idea of creating a chat bot/agent built solely on text embedding (without relying on large language models (LLMs)).

After a couple of successful experiments, EasyBot was born!

## Menu-Driven Inspiration and Design
Menu-driven interfaces are the inspiration for EasyBot's functionality.  By tying keywords to specially crafted ObjectScript classes and methods, EasyBot is able to use vector searching to determine which method to call when a user submits a prompt.  This allows EasyBot to be constrained (like a menu-driven interface) to only perform the actions of registered "agents", while providing responses to a wide range of free-text prompts.

## Easy to Extend
One of the main goals of EasyBot is to promote simple, easy customization through custom ObjectScript methods.

To customize EasyBot:
1. Create a new class that extends `easybot.core.Agent`.
2. Create a method with the following call signature and method comments:

  ```cls
  /// Display: EasyBot uses 'Display' whenever it needs to display this fuction.
  /// Keywords: The 'Keywords' lines are used to index/embed this method.
  /// Keywords: 'Keywords' are used by EasyBot to find the user's desired action.
  /// Keywords: You can havkje multiple 'Keywords' lines. They will be joined together to index/embed.
  Method MethodName(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
  ```

3. Run the 'load' command from an EasyBot chat.

## Example Custom Agent
Here's an example custom Agent class:

### Create a new class that extends `easybot.core.Agent`

Notice that the `DaysOfTheWeekAgent` method contains the `Display` and `Keywords` labels  in the comments.  This tells EasyBot to index/embed this method when `load` is called later.

```cls
Class easybot.bots.CustomAgent Extends easybot.core.Agent
{

/// Display: List the days of the week
/// Keywords: days of the week, weekend, weekday, holiday
Method DaysOfTheWeekAgent(ByRef prompt As easybot.core.Prompt, ByRef response As easybot.core.ShellResponse)
{
  do response.Respond("Here is information I have on the days of the week...")

  // gather information on days of the week
  // ...somehow...
  set days = $LB("Sun","Mon","Tue","Wed","Thu","Fri","Sat")

  for i=1:1:$LISTLENGTH(days) {
    set day = $LISTGET(days, i)
    do response.ListItem(day)
  }
}

}
```
Now, let's load this (and all other available agents) into IRIS.  This step will take the keywords from each
method it finds, embed the keyword text, and save it into the `easybot.store.Targets` table in IRIS.  EasyBot compares user prompts with the entries in this table.

```cls
IRISAPP>do ##class(easybot.core.Shell).Run()
How can I help you?
>>> load
Reloading
Loading easybot.bots.CustomAgent
Loading easybot.bots.DatabaseAgent
Loading easybot.bots.EnsAgent
Loading easybot.bots.HelpAgent
Loading easybot.bots.NamespaceAgent
```

Now let's ask EasyBot about days of the week.  In this example, EasyBot was able to confidently determine the Agent method to call.  In this case, EasyBot will go ahead and call our method!

```cls
>>> tell me about days this week
    | Here is information I have on the days of the week...
    | - Sun
    | - Mon
    | - Tue
    | - Wed
    | - Thu
    | - Fri
    | - Sat
```
When EasyBot is unable to determine the Agent method to call with confidence, it provides a list of possibly-related methods for the user to choose.  Notice that this matches the `Display` comment of the method.

```
>>> help days
    | Choose one of these options...
      1. List the days of the week (.73)
      2. List Bots, Agents, and Commands (.66)
>>> 1
    | Here is information I have on the days of the week...
    | - Sun
    | - Mon
    | - Tue
    | - Wed
    | - Thu
    | - Fri
    | - Sat
```
## Planned Features
Here are a list of current-planned features that should be easy to implement:
 - Web Frontend
 - Mulit-step Prompts

## Built-in Agents
- easybot.bots.CustomAgent
  - List the days of the week

- easybot.bots.DatabaseAgent
  - Databases Menu
  - Filter Databases
  - Database Help
  - List Databases

- easybot.bots.EnsAgent
  - List Interfaces
  - Start Interface
  - Start Production
  - Stop Interface
  - Stop Production

- easybot.bots.HelpAgent
  - Explain...
  - List Bots, Agents, and Commands

- easybot.bots.NamespaceAgent
  - Filter Namespaces
  - List Namespaces
  - Namespaces Menu
