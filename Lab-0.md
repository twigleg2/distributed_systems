**gfinch**
# Lab 0

**My public URL**
`https://raw.githubusercontent.com/twigleg2/distributed_systems/master/hello_world.krl?token=AINOKEFUFFSX4CC3XSHQE3S6ESXMM`


**Bad parse**
```
git commit -m "Test pre-commit parse"
Parse errors in hello_world.krl:
ParseError: Expected `}`

You can disable checking by setting the hook.allownoparse to true
```
**Good parse**
```
git commit -m "Test pre-commit parser"
Use of uninitialized value $rid_line[0] in split at .git/hooks/pre-commit line 46.
Use of uninitialized value $rid in substitution (s///) at .git/hooks/pre-commit line 48.
Use of uninitialized value $rid in concatenation (.) or string at .git/hooks/pre-commit line 57.
Use of uninitialized value $rid in print at .git/hooks/pre-commit line 60.
Flushing 
[master f0ef9b2] Test pre-commit parser
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 Lab-0.md
```

**Port:8080**