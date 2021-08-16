## Install

```powershell
Install-Module -Name PSPx
```

## Markdown scripts

`px` can execute scripts written in markdown ([examples/markdown.md](examples/markdown.md)):
```powershell
px examples/markdown.md
```

it can also execute scripts written in markdown from a `url`:

```powershell
px https://gist.githubusercontent.com/dfinke/610703acacd915a94afc1a4695fc6fce/raw/479e8a5edc62607ac5f753a4eb2a56ead43a841f/testErrors.md | fl
```

### Markdown

![](/media/PSMarkdown.png)

### Output

![](/media/PSOutput.png)