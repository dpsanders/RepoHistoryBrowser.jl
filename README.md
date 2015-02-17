# RepoHistoryBrowser

Julia package for interactively browsing through the history of a file in a git repo using an IJulia widget.

## Installation

    julia> Pkg.clone("https://github.com/dpsanders/RepoHistoryBrowser.jl")

### Required packages

- Python:
    - `pygments` package  (including the `pygmentize` command-line utility)
    
- Julia:
    - `Interact.jl` package


There is also a `use_pygments` branch that directly uses the Python `pygments` package instead, 
in which case you must also have the Julia package `PyCall` installed.

## Usage

Use 

    using HistoryBrowser

    browse_history(directory, filename)

or

    browse_history(filename)

## Contributors:
- David P. Sanders

