#!/usr/bin/perl
use strict;
use warnings;
use blib;
use CUDA::Minimal;
use feature 'say';

SetSize(my $test_scalar, Sizeof(f => 30));
say "Length of test scalar is ", length($test_scalar);

# Create a packed scalar with values that we will copy to the device:
my $array = pack('f*', 1..10);
say "Length of packed array is ", length($array);
my $dev_ptr = Malloc($array);
my $to_print = $dev_ptr;
say "Device pointer's memory address is $to_print";
END {
	# Free the memory when it's all over
	Free($dev_ptr);
}

# Copy the packed scalar to the device:
Transfer($array => $dev_ptr);

# Create a new scalar to which we copy the device memory back:
SetSize(my $new_array, length($array));
say "Length of new array is ", length($new_array);

# Printout the current contents of $new_array:
say "new_array currently looks like this:";
say foreach (unpack 'f*', $new_array);

# Copy the device memory back:
Transfer($dev_ptr => $new_array);

# Copy the device memory back again:
Transfer($dev_ptr => $new_array);

# Print out the results, which should be 1-10:
say "Now new_array looks like this:";
say foreach (unpack 'f*', $new_array);

