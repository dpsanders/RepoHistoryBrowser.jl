# Only works from within IJulia, since uses widgets

module RepoHistoryBrowser

export browse_history

using Interact


# Concatenate two HTML representations
# HTML is a type defined in Interact.jl
+(a::HTML, b::HTML) = html(string(a.value, b.value))


# Syntax for using git on another directory:
# git -C ~/Dropbox/projects/RepoBrowser/ log --oneline

# Get the copy of a filename from a particular commit with a given hash, in the given directory
function use_commit(directory::String, hash::String, filename::String)
    try
        run(`git -C $directory show $hash:$filename` |> "_tmp.jl")  # pipe output to a temporary file
    catch
        run(`echo "No file $filename in commit $hash"` |> "_tmp.jl" )
    end
end

# Use pygments to make the highlighted HTML version:
function generate_html(directory::String, hash::String, filename::String)
    use_commit(directory, hash, filename)
    code = readall(`pygmentize -O full -f html -l julia _tmp.jl`);
    html(code)
end


# Main function: browse the history of a file in a git repo in the given directory

function browse_history(directory::String, filename::String)
    commits = []

    try
        commits = reverse(readlines(`git -C $directory log --oneline`))
    catch
        error("Not possible to get the history for $directory. Is it a git repository?")
    end

    hashes = ASCIIString[split(commit)[1] for commit in commits];

    @manipulate for n in 1:length(hashes)
        html(commits[n]) + html("<p>") + generate_html(directory, hashes[n], filename)
    end

end

# browse in the current directory if no directory given
browse_history(filename::String) = browse_history(pwd(), filename)

end
