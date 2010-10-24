#!/usr/bin/perl -w

# Copyright 2010 Kevin Ryde

# This file is part of Gtk2-Ex-ComboBoxBits.
#
# Gtk2-Ex-ComboBoxBits is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# Gtk2-Ex-ComboBoxBits is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Gtk2-Ex-ComboBoxBits.  If not, see <http://www.gnu.org/licenses/>.

use 5.010;
use strict;
use warnings;
use Test::More;

use lib 't';
use MyTestHelpers;
use Test::Weaken::ExtraBits;
BEGIN { MyTestHelpers::nowarnings() }

require Gtk2::Ex::ComboBox::PixbufType;

require Gtk2;
Gtk2->disable_setlocale;  # leave LC_NUMERIC alone for version nums
Gtk2->init_check
  or plan skip_all => 'due to no DISPLAY available';

# Test::Weaken 3 for "contents"
eval "use Test::Weaken 3; 1"
  or plan skip_all => "due to Test::Weaken 3 not available -- $@";

eval "use Test::Weaken::Gtk2; 1"
  or plan skip_all => "due to Test::Weaken::Gtk2 not available -- $@";

plan tests => 1;


sub my_ignore {
  my ($ref) = @_;
  return ($ref == Gtk2::Ex::ComboBox::PixbufType->DEFAULT_MODEL);
}

{
  my $leaks = Test::Weaken::leaks
    ({ constructor => sub {
         my $toplevel = Gtk2::Window->new ('toplevel');
         my $combo = Gtk2::Ex::ComboBox::PixbufType->new;
         $toplevel->add ($combo);
         $toplevel->show_all;
         return $toplevel;
       },
       destructor => \&Test::Weaken::Gtk2::destructor_destroy,
       contents => \&Test::Weaken::Gtk2::contents_container,
       # ignore => \&my_ignore,
     });
  is ($leaks, undef, 'Test::Weaken deep garbage collection');
  if ($leaks) {
    eval { diag "Test-Weaken ", explain($leaks) }; # explain new in 0.82

    my $unfreed = $leaks->unfreed_proberefs;
    say "unfreed isweak ",
      (Scalar::Util::isweak ($unfreed->[0]) ? "yes" : "no");
    foreach my $proberef (@$unfreed) {
      diag "  unfreed $proberef";
    }
    foreach my $proberef (@$unfreed) {
      diag "  search $proberef";
      MyTestHelpers::findrefs($proberef);
    }
  }
}

exit 0;
