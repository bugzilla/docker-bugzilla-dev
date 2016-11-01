#!/bin/bash
# Add any custom setup instructions here

export PERL5LIB=$BUGZILLA_LIB

# Global Perl dependencies
export CPANM="sudo /usr/local/bin/cpanm --quiet --notest --skip-satisfied"

# Remove CPAN build files to minimize disk usage
rm -rf ~/.cpan*
