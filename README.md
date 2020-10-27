# WriteParagraph
`Write-Host`... now with word wrapping!

## What is this?

`Write-Paragraph` is a wrapper around `Write-Host` with a few extra niceties including automatic word wrapping and extra line breaks. It's helpful if you ever find yourself trying to display large blocks of text in a PowerShell window. 

## Example

Assuming the following variables have been populated thusly...

```powershell
$p1 = "When, in the course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume, among the powers of the earth, the separate and equal station to which the laws of nature and of nature’s God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation."
$p2 = "We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable rights, that among these are life, liberty, and the pursuit of happiness. That, to secure these rights, governments are instituted among men, deriving their just powers from the consent of the governed. That, whenever any form of government becomes destructive of these ends, it is the right of the people to alter or to abolish it, and to institute new government, laying its foundation on such principles, and organizing its powers in such form, as to them shall seem most likely to effect their safety and happiness."
$p3 = "Prudence, indeed, will dictate that governments long established should not be changed for light and transient causes; and, accordingly, all experience has shown, that mankind are more disposed to suffer, while evils are sufferable, than to right themselves by abolishing the forms to which they are accustomed."
```

This is what you get with `Write-Host`:

![WriteHost](https://raw.githubusercontent.com/refactorsaurusrex/WriteParagraph/master/images/WriteHost.png)

And this is what `Write-Paragraph` produces:

![WriteParagraph](https://raw.githubusercontent.com/refactorsaurusrex/WriteParagraph/master/images/WriteParagraph.png)

## Installation

Available in the [PowerShell Gallery](https://www.powershellgallery.com/packages/WriteParagraph). 

```powershell
Install-Module -Name WriteParagraph
```

