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

package Gtk2::Ex::ComboBoxBits;
use 5.008;
use strict;
use warnings;

use Exporter;
our @ISA = ('Exporter');
our @EXPORT_OK = qw(set_active_text
                    find_text_iter);

# uncomment this to run the ### lines
#use Smart::Comments;

our $VERSION = 4;

sub set_active_text {
  my ($combobox, $str) = @_;
  ### ComboBoxBits set_active_text(): $str
  if (defined $str && (my $iter = find_text_iter ($combobox, $str))) {
    ### $iter
    $combobox->set_active_iter ($iter);
  } else {
    # pending perl-gtk 1.240 set_active_iter() accepting undef
    $combobox->set_active (-1);
  }
  ### active N now: $combobox->get_active
}

sub find_text_iter {
  my ($combobox, $str) = @_;
  ### ComboBoxBits find_text_iter(): $str
  my $ret;
  if (my $model = $combobox->get_model) {
    $model->foreach (sub {
                       my ($model, $path, $iter) = @_;
                       if ($str eq $model->get_value ($iter, 0)) {
                         ### found at: $path->to_string
                         $ret = $iter->copy;
                         return 1; # stop
                       }
                       return 0; # continue
                     });
  }
  return $ret;
}

1;
__END__

# sub _text_to_nth {
#   my ($combobox, $str) = @_;
#   if (my @indices = _text_to_indices($combobox, $str)) {
#     return $indices[0];
#   } else {
#     return -1;
#   }
#   return $n;
# }
# sub _text_to_indices {
#   my ($combobox, $str) = @_;
#   my @ret;
#   if (my $model = $combobox->get_model) {
#     $model->foreach (\&_text_to_nth_foreach, \$n);
#   }
#   return @ret;
# }
# sub _text_to_nth_foreach {
#   my ($model, $path, $iter, $aref) = @_;
#   if ($str eq $model->get_value ($iter, 0)) {
#     @$aref = $path->get_indices;
#     return 1; # stop
#   }
#   return 0; # continue
# }

=for stopwords Gtk2-Ex-ComboBoxBits ComboBox Ryde Gtk

=head1 NAME

Gtk2::Ex::ComboBoxBits -- misc Gtk2::ComboBox helpers

=head1 SYNOPSIS

 use Gtk2::Ex::ComboBoxBits;

=head1 FUNCTIONS

=over

=item C<< $str = Gtk2::Ex::ComboBoxBits::set_active_text ($combobox, $str) >>

C<$combobox> must be a simplified "text" type ComboBox.  Set the entry
C<$str> active.

(As of Gtk 2.20 ComboBox has a C<get_active_text>, but no C<set_active_text>
nor a corresponding property.)

=item C<< $iter = Gtk2::Ex::ComboBoxBits::find_text_iter ($combobox, $str) >>

Return a C<Gtk2::TreeIter> which is the row for C<$str> in a text style
combobox.  If C<$str> is not in C<$combobox> then return C<undef>.

=back

=head1 EXPORTS

Nothing is exported by default, but the functions can be requested in usual
C<Exporter> style,

    use Gtk2::Ex::ComboBoxBits 'set_active_text';

This can be handy if using C<set_active_text> in several places.
C<Gtk2::Ex::ComboBox::Text> imports it to use as an object method.

There's no C<:all> tag since this module is meant as a grab-bag of functions
and to import as-yet unknown things would be asking for name clashes.

=head1 HOME PAGE

L<http://user42.tuxfamily.org/gtk2-ex-comboboxbits/index.html>

=head1 LICENSE

Copyright 2010 Kevin Ryde

Gtk2-Ex-ComboBoxBits is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any later
version.

Gtk2-Ex-ComboBoxBits is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Gtk2-Ex-ComboBoxBits.  If not, see L<http://www.gnu.org/licenses/>.

=cut
