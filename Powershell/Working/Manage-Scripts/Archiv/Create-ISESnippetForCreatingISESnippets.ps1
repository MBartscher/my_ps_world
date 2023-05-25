New-IseSnippet -Title 'Create-Snippet' -Description 'For fast creating an ISE-Snippet.' -Text @"
`$Title=''
`$Description=''
`$Text=@'

'@
`$Author='MB'
`$CaretOffset=

New-IseSnippet -Title `$Title -Description `$Description -Text `$Text -Author `$Author -CaretOffset `$CaretOffset -Force
"@ -Author 'MB (Idea found at:"https://www.pdq.com/blog/creating-powershell-ise-snippets/")' -CaretOffset 8 -Force