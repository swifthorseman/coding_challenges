#!/usr/bin/env perl -w

$|=1;

use Benchmark;
use Data::Dumper;

my $start_time;

my @sum_grid;
my @results;

my @input = <STDIN>;
chomp @input;

$start_time = new Benchmark;

# read the size of the grid
my ($num_rows, $num_cols) = split m/\s/, $input[0], 2;

# build up the accumulated sums
foreach my $line_num(1..$num_rows) {
  my @row_gold = split m/\s/, $input[$line_num], $num_cols;

  my $sum = 0;
  my @accumulator;

  foreach my $index(0..$#row_gold) {
    $sum += $row_gold[$index];

    if ($line_num == 1) {
      push @accumulator, $sum;
    } else {
      push @accumulator, $sum_grid[-1][$index] + $sum
    }
  }
  push @sum_grid, [@accumulator];
}

# get the number of queries
my $num_queries = $input[$num_rows + 1];

# process the queries
foreach my $line_num($num_rows+2..$num_rows+2+$num_queries-1) {
  my ($x1, $y1, $x2, $y2) = map { $_ - 1 } split m/\s/, $input[$line_num], 4;

  my $sum = $sum_grid[$x2][$y2];
  if ($x1 != 0 && $x2 != 0) {
    $sum -= $sum_grid[$x1-1][$y2]
  }
  if ($y1 != 0) {
    $sum -= $sum_grid[$x2][$y1-1]
  }
  if ($x1 != 0 && $y1 != 0) {
    $sum += $sum_grid[$x1-1][$y1-1]
  }

  push @results, $sum;
}


print STDOUT join "\n", @results;
print STDOUT "\n";

my $end_time = new Benchmark;
my $difference = timediff($end_time, $start_time);
print STDOUT "It took ", timestr($difference), "\n";
