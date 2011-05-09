# Copyright 2010, 2011 Kevin Ryde

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
our @EXPORT_OK = qw(set_active_path
                    set_active_text
                    find_text_iter);

# uncomment this to run the ### lines
#use Smart::Comments;

our $VERSION = 31;

sub set_active_path {
  my ($combobox, $path) = @_;
  my $n = -1;

  # Non-existent rows go to set_active(-1) since the Perl-Gtk2
  # set_active_iter() doesn't accept undef (NULL) until 1.240.
  # If ready to demand that version could
  #     $combobox->set_active_iter ($model->get_iter($path));
  # when there's a model

  if ($path) {
    if ($path->get_depth == 1) {
      # top-level row using set_active()
      ($n) = $path->get_indices;

    } elsif (my $model = $combobox->get_model) {
      if (my $iter = $model->get_iter($path)) {
        $combobox->set_active_iter ($iter);
        return;
      }
    }
  }
  $combobox->set_active ($n);
}

sub set_active_text {
  my ($combobox, $str) = @_;
  ### ComboBoxBits set_active_text(): $str

  if (defined $str && (my $iter = find_text_iter ($combobox, $str))) {
    ### $iter
    $combobox->set_active_iter ($iter);
  } else {
    # As of Gtk 2.20 set_active() throws a g_log() warning if there's no
    # model set.  Prefer to quietly do nothing to make no active item when
    # already no active item.
    if ($combobox->get_model) {
      # pending perl-gtk 1.240 set_active_iter() accepting undef
      $combobox->set_active (-1);
    }
  }
  ### set_active_text() active num now: $combobox->get_active
}

sub find_text_iter {
  my ($combobox, $str) = @_;
  ### ComboBoxBits find_text_iter(): $str
  my $ret;
  if (my $model = $combobox->get_model) {
    $model->foreach (sub {
                       my ($model, $path, $iter) = @_;
                       ### get_value: $model->get_value ($iter, 0)
                       if ($str eq $model->get_value ($iter, 0)) {
                         ### found at: $path->to_string
                         $ret = $iter->copy;
                         return 1; # stop
                       }
                       return 0; # continue
                     });
  }
  ### $ret
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

=item C<< Gtk2::Ex::ComboBoxBits::set_active_path ($combobox, $path) >>

Set the active item in C<$combobox> to the given C<Gtk2::TreePath>
position.  If C<$path> is empty or C<undef> or there's no such row in the
model then C<$combobox> is set to nothing active.

If there's no model in C<$combobox> then a toplevel path is remembered ready
for a model set later, the same as the native C<set_active>.  But sub-rows
don't enjoy the same remembering.

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

This can be handy if using C<set_active_text> many times.
C<Gtk2::Ex::ComboBox::Text> imports it to use as an object method.

There's no C<:all> tag since this module is meant as a grab-bag of functions
and to import as-yet unknown things would be asking for name clashes.

=head1 HOME PAGE

L<http://user42.tuxfamily.org/gtk2-ex-comboboxbits/index.html>

=head1 LICENSE

Copyright 2010, 2011 Kevin Ryde

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
