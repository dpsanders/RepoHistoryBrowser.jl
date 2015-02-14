using Interact

commits = reverse(readlines(`git log --oneline`))
hashes = ASCIIString[split(commit)[1] for commit in commits];

function use_commit(hash::String, filename::String)
    run(`git show $hash:$filename` |> "_tmp.jl")
end

filename = "example_code/example.jl"

# Concatenate two HTML representations
# HTML is a type defined in Interact.jl
+(a::HTML, b::HTML) = html(string(a.value, b.value))

function generate_html(hash::String, filename::String)
    use_commit(hash, filename)
    code = readall(`pygmentize -O full -f html -l julia _tmp.jl`);
    html(code)
end

@manipulate for n in 1:length(hashes)
    html(commits[n]) + generate_html(hashes[n], filename)

end
