#!/usr/bin/perl

# ipswich throw
# ipswich gimme

# respective Aliases:

# ipswich pass
# ipswich catch

use strict; use warnings;
use feature 'say';
use Path::Tiny;
use TOML::Tiny;
use Class::Struct;
use IO::Compress::Gzip qw(gzip);
use Digest::SHA qw(sha256_hex);
use List::Util qw(any);

my $arguments = @ARGV;
my $ipswichFile = 'ipswich.toml';


my @allFiles = glob('*');
# the glob is non-recursive for a reason: Ipswich is designed for small projects.

my $emptyError = "Ipswich can't save this directory because there are no files in it.";
my $emptyErrorException = "Ipswich saved the config file that it generated, however, it did not catch any real files.";

# ipswich is designed to live in each project directory as an instance, so the TOML won't be too detailed, with sections for project names and whatnot.

sub startIpswich {
    open(my $ipsFile, '>', $ipswichFile) or die 'Sorry! Ipswich failed to open/create its file.';
    return $ipsFile;
}

struct TomlStructure => {
    'file_name' => '$',
    'file_hash' => '$',
    'file_blob' => '$'
};

# heres a benefit of Ipswich: branches are inherently part of gimme/catch.
# everytime you gimme, a new folder is created with every file from your last commit in it. 
# So, if you want, you could just make a new commit and immediately catch it for a branch.

# argue a file
my $findContents = sub {
    my $fileToVisit = shift;
    my $contents = path($fileToVisit)->slurp;
    return $contents;
};

# argue the thunk
sub fulfillPromises {
    my $thunk = shift;
    my @allStructures = ();

    for my $promise (@{$thunk}) {
        my $structure = TomlStructures->new;

        $structure->{file_name} = $promise;
        my $content = $findContents->($promise); $structure->file_hash = sha256_hex($content);

        my $gzippedBlob;
        gzip \$content => \$gzippedBlob;
        $structure->{file_blob} = $gzippedBlob;

        push @allStructures, $structure;
    }
    return @allStructures;
}

sub ipswichThrow {
    my @thunk = ();
    for my $file (@allFiles) {
        push @thunk, $file->basename unless $file eq '';
    }
    @thunk == 0 and die;
    if (@thunk == 1 && $thunk[0] eq $ipswichFile) {
        die $emptyError . $emptyErrorException;
    }
    my $debt = fulfillPromises(\@thunk);
    my $packagedDebt = to_toml($debt);
    path($ipswichFile)->spew($packagedDebt);

    say 'Ipswich successfully stored @allFiles files.'
}

sub ipswichCatch {    
    my $gotToml = from_toml(path($ipswichFile)->slurp);
    if (@{$gotToml} == 0) {
        die 'Failed to locate any files in the registry.'
    }
    my $lastCommit = $gotToml->[-1]; 
    my $projectName = $gotToml->{file_name};
    # I don't know why the hashes are there, we don't check for them. Why? Because Ipswich lets you make carbon copies!
    my $newDirectory = $projectName . ' Ipswich';
    mkdir($projectName . ' Ipswich');
    for my $file (\$gotToml->file_blob) {
        rename(\$file, "$newDirectory/$file"); # I'm pretty sure a pointer is right in this case because we don't want to touch the actual files in the previous commit
    }
    
    say 'Ipswich retrieved @{$gotToml} files and stored them in $newDirectory.'
}

startIpswich();

my @arguments = \@ARGV;
my $request =lc($arguments[1]);

my @throwWords = qw|throw pass 1 a|;
my @catchWords = qw|gimme pass 2 b|;
# I added in the numbers and letters because we only have two commands--
# Who am I to stop you if you just want to write 'ipswich a' or 'ipswich 1' and not 'ipswich throw'

sub greet {
    my $randomInteger = int(rand($4));
    my @greetings = (
        "Hey there! Working on that . . .",
        "Hello! Working . . .",
        "Hello from Ipswich! Working . . ."
    );
    say $greetings[$randomInteger];
}

sub farewell {
    my $randomInteger = int(rand($4));
    my @goodbyes = (
        "I hope you enjoy the rest of your coding session!",
        "Goodbye from Ipswich!",
        "Until we meet again."
    );
    say $goodbyes[$randomInteger];
}


if ( any { $_ eq $request } @throwWords) {
    greet(); 
    ipswichThrow(); 
    farewell();
} elsif ( any { $_ eq $request} @catchWords) {
    greet();
    ipswichCatch();
    farewell();
} else {
    my $throwCommands = join(", ", @throwWords);
    my $catchCommands = join(", ", @catchWords);

    say "
    Sorry, but that command doesn't exist.
    The only commands you can use are:
    $throwCommands
    $catchCommands
    ";
}