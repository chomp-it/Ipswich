#!/usr/bin/perl

# To stash your code (like git add . + git commit):
# ipswich stash

# To fetch your stashed code:
# ipswich gimme

use strict; use warnings;
use feature 'say';
use Path::Tiny;
use List::Util qw(any);
use Archive::Zip;

my @arguments = @ARGV;

# I'll make this recursive in the future 
# — even small projects can be nested.
my @allFiles = glob('*');

sub stash {
    my $zip = Archive::Zip->new();
    for my $file (@allFiles) {
        next if grep { $_ eq $file } qw [ipswich.zip DS_Store ];
        $zip->addFile($file);
    }
    $zip->writeToFileNamed('ipswich.zip');
}

sub gimme {
    my $zip = Archive::Zip->new();
    $zip->read('ipswich.zip');
    for my $member ($zip->members()) {
        $zip->extractMember($member);
    }
}

sub gitStash {
    system('git add . && git commit -m "ipswich stash"');
}

sub gitGimme {
    system('git checkout HEAD~1');
}

my $request = @arguments ? lc($arguments[0]) : '';

my $use_git = $ENV{'IPSWICH_USE_GIT'};

if ( $request eq "stash" ) {
    $use_git ? gitStash() : stash();
} elsif ( $request eq "gimme" ) {
    $use_git ? gitGimme() : gimme();
} else {
    say "  That command doesn't exist.
      To stash your code, use the 'stash' command.

      To retrieve your stashed code, use the 'gimme' command.";
}
