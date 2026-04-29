#!/usr/bin/env bash
# skills/osint-research/lib/secret-redactor.sh
# Reads stdin, redacts known secret patterns, writes stdout.
# Pattern source: skills/osint-research/lib/secret-patterns.txt

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_FILE="${OSINT_SECRET_PATTERNS:-$SCRIPT_DIR/secret-patterns.txt}"

if [ ! -r "$PATTERNS_FILE" ]; then
    echo "secret-redactor: patterns file not readable: $PATTERNS_FILE" >&2
    exit 2
fi

# Read all of stdin into a variable (acceptable for typical OSINT payloads <10MB).
input="$(cat)"

# Build a sed expression set, one per pattern. We use perl for richer regex support
# and easy callback-style replacement.
perl_script='
my %patterns;
while (<STDIN>) {
    chomp;
    next if /^\s*#/ || /^\s*$/;
    my ($label, $re) = split /\|/, $_, 2;
    $patterns{$label} = $re if defined $re;
}
my $text = do { local $/; <DATA> };
for my $label (keys %patterns) {
    my $re = $patterns{$label};
    $text =~ s/($re)/_truncate($1, $label)/ge;
}
print $text;

sub _truncate {
    my ($match, $label) = @_;
    return "<REDACTED:$label>" if length($match) < 12;
    return substr($match, 0, 4) . "..." . substr($match, -4);
}
'

# Pass patterns via stdin and the input via DATA section (joined with __DATA__).
# Implementation: use a here-doc trick.
{ cat "$PATTERNS_FILE"; printf '\n__SEP__\n'; printf '%s' "$input"; } | \
perl -e '
my %patterns;
my $section = 0;
my $text = "";
while (<STDIN>) {
    if (/^__SEP__$/) { $section = 1; next; }
    if ($section == 0) {
        chomp;
        next if /^\s*#/ || /^\s*$/;
        my ($label, $re) = split /\|/, $_, 2;
        $patterns{$label} = $re if defined $re;
    } else {
        $text .= $_;
    }
}
for my $label (keys %patterns) {
    my $re = $patterns{$label};
    eval {
        $text =~ s/($re)/_t($1, $label)/ge;
    };
}
print $text;

sub _t {
    my ($m, $l) = @_;
    return "<REDACTED:$l>" if length($m) < 12;
    # PEM markers are always fully redacted (they contain no extractable entropy after label).
    return "<REDACTED:$l>" if $l eq "private_key_pem";
    return substr($m, 0, 4) . "..." . substr($m, -4);
}
'
