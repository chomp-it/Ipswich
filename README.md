# Ipswich

Version control doesn't need a whole lot of bells and whistles. At it's core,
a version control system just needs to stash your code and restore it upon your request.

That's exactly what Ipswich does. With Ipswich, there are only two commands: `stash` and `gimme`, 
which will respectively stash and restore your code.

# Use Ipswich

Naturally, using Ipswich is quite simple and intuitive.

To use Ipswich, run `stash` whenever you want to commit your changes, and `gimme` whenever you want to restore them.

Here are a couple of things to know about Ipswich if you're coming from a VCS like Git:
- There's no need to initialize Ipswich like you do with Git and `Git init`.
- Ipswich only tracks the last commit — each time you `stash` your changes, the previous saved changes are deleted.

# Install Ipswich

First, make sure you have Perl installed.
If you don't, you can find instructions [here](https://www.perl.org/get.html).

You can use these shell commands to install Ipswich:
```
curl -fsSL https://raw.githubusercontent.com/chomp-it/Ipswich/refs/heads/main/ipswich.pl -o ipswich
chmod +x ipswich
mv ipswich ~/.local/bin
```

You'll also want to make sure `~/.local/bin` is on your PATH.

If you don't want to do that, then you'll have to follow these steps yourself:
- get the source code
- make Ipswich executable and remove the Perl file extension
- move Ipswich to your PATH

<hr>

Thanks for giving Ipswich a look.

Feel free to email me at reeceturner1358@gmail.com if you have any questions.

Cheers!
