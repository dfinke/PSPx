# Why do this?

- Do you have a very long installation documentation for our project and need a quick way of testing it? 
- It is general purpose tool that can be used for multiple purposes like executing a tutorial documentation, using docs as a script, etc.

Collects fenced code blocks from input markdown file and executes them in same order as they appear in the file. 

Example of fenced code block in markdown file

```ps1
foreach($i in 1..10) {
    $i
}
```

PSPx recognizes the tags `ps`, `ps1`, and `powershell`.

PSPx collects all the code blocks and executes them as a single script.

<br/>

| Function | Description |
| --- | --- |
| `Invoke-ExecuteMarkdown` | Execute PowerShell written in markdown code blocks |
| `Invoke-ScriptAnalyzerMarkdown` | Run PowerShell Script Analyzer on code blocks written in markdown |
| `Invoke-ScriptFormatterMarkdown` | Install a module |
| `Invoke-UpdateScriptFormat` | Run PowerShell Script Analyzer Formatter on code blocks, and return both markdown and formatted code blocks as a string.  |
| `Get-MarkdownCodeBlock` | Extracts PowerShell code blocks from markdown |

## Markdown scripts

`px` can execute scripts written in markdown ([examples/markdown.md](examples/markdown.md)):
```powershell
px examples/markdown.md
```

it can also execute scripts written in markdown from a `url`:

```powershell
px https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md | fl
```

# Run a markdown file
Execute code blocks in input.md file

```powershell
Invoke-ExecuteMarkdown input.md
```

# Run a markdown file from a Url

```powershell
$url = 'https://raw.githubusercontent.com/dfinke/PSPx/master/__tests__/testMarkdownFiles/basicPSBlocks.md'

Invoke-ExecuteMarkdown $url
```

## The output
```
Path   : https://raw.githubusercontent.com/dfinke/PSPx/master/__tests__/testMarkdownFiles/basicPSBlocks.md
Script : {"Hello World", "Goodbye", $xs = 1, 2, 3, foreach ($x in $xs) {ΓÇª}
Cmdlet : Invoke-ExecuteMarkdown
Result : {Hello World, Goodbye, 1, 2...}
```

# List Code Blocks

Wouldn't it be great to be able to list all code blocks that are going to be executed before actually using run command? You can! 
There are a couple of ways to do this.

This returns all of the code blocks as a single `Script`.

```powershell
Get-MarkdownCodeBlock basicPSBlocks.md
```

### Result
```
Path   : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md
Script : {"Hello World", "Goodbye", $xs = 1, 2, 3, foreach ($x in $xs) {...}
```

## Use `-Raw` Switch

This returns both the markdown and code blocks from the target `.md` file. Each is tagged with a `Type` => `PSScript`|`Markdown`.

```powershell
Get-MarkdownCodeBlock basicPSBlocks.md -Raw
```

### Result

```
Type : PSScript
Text : {```ps, "Hello World", ```}
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : Markdown
Text : {$null, , # Another block, }
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : PSScript
Text : {```ps, "Goodbye", ```}
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : Markdown
Text : {$null, , # Add some numbers, }
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : PSScript
Text : {```ps, $xs = 1, 2, 3, foreach ($x in $xs) {,     $x...}
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : Markdown
Text : {$null, , # Return a string, use a powershell block, }
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : PSScript
Text : {```powershell, 'This is a powershell block', ```}
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : Markdown
Text : {$null, , # Add Numbers, }
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md

Type : PSScript
Text : {```ps1, 3+4+5, ```}
Path : D:\mygit\PSPx\__tests__\testMarkdownFiles\basicPSBlocks.md
```

This gives you the ability to process the mardown file on your own. For example, you can extract the PowerShell from the `Text` parameter like this.

```powershell
Get-MarkdownCodeBlock basicPSBlocks.md -Raw |
    Where Type -eq 'PSScript' | 
    ForEach { $_.Text[1..($_.Text.Count - 2)] }
```

### Markdown

![](/media/PSMarkdown.png)

### Output

![](/media/PSOutput.png)

## Access Tokens

The `-Headers` parameter can be used to add access tokens to the request for markdown files behind a private Url. For example, if they are in a private GutHub repository, or Azure DevOps.

```powershell
$url = 'https://private.url.com/test.md'
$header = @{"Authorization"="token $($env:GITHUB_TOKEN)"}
Invoke-ExecuteMarkdown $url $header
```