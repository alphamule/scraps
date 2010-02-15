#!/usr/bin/perl


use strict;
use warnings;

my $INDIVIDUAL_DEDUCTION = 5700;
my $JOINT_DEDUCTION = 11400;
my $SS_CAP = 106800;

sub find_ss_taxes {
  my ($income) = shift;

  if ($income > $SS_CAP) {
    return $SS_CAP * .062;
  }
  return $income * .062;
}

sub find_medicare_taxes {
  my ($income) = shift;

  return $income * .0145;
}

sub find_fed_taxes {
  my ($income, $deduction) = @_;

  my $deducted = $income - $deduction;

  my $taxes_so_far = 0;
  my $marginal_left = $deducted;

  if ($deducted < 0) {
    return 0;
  }
  
  if ($deducted < 8375) {
    return $marginal_left * .10;
  }

  $taxes_so_far += (8375 * .10);
  $marginal_left = $deducted - 8375;

  if ($deducted < 34000) {
    return $taxes_so_far + $marginal_left * .15;
  }

  $taxes_so_far += ((34000 - 8375) * .15);
  $marginal_left = $deducted - 34000;

  if ($deducted < 82400) {
    return $taxes_so_far + $marginal_left * .25;
  }

  $taxes_so_far += ((82400 - 34000) * .25);
  $marginal_left = $deducted - 82400;

  if ($deducted < 171850) {
    return $taxes_so_far + $marginal_left * .28;
  }

  $taxes_so_far += ((171850 - 82400) * .28);
  $marginal_left = $deducted - 171850;

  if ($deducted < 373650) {
    return $taxes_so_far + $marginal_left * .33;
  }

  $taxes_so_far += ((373650 - 171850) * .33);
  $marginal_left = $deducted - 373650;

  return $taxes_so_far + $marginal_left * .35;
}


for my $x (1..500) {
  my $i = $x * 1000;
  my $individual_tax = find_fed_taxes($i, $INDIVIDUAL_DEDUCTION) + find_ss_taxes($i) + find_medicare_taxes($i);
  my $individual_rate = $individual_tax / $i;

  my $joint_tax = find_fed_taxes($i, $JOINT_DEDUCTION) + find_ss_taxes($i) + find_medicare_taxes($i);
  my $joint_rate = $joint_tax / $i;
  print "$i,$individual_tax,$individual_rate,$joint_tax,$joint_rate\n";
}


