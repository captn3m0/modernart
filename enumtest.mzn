include "globals.mzn";
% Since the documentation is unclear, wrote this test to figure
% out whether enums wrap around or not.
enum Letters;
Letters= {A,B,C};

var Letters: x;
var Letters: y;
var Letters: z;

constraint x = enum_next(Letters, y);
constraint y = B;
% This is unsatisfiable, because nothing comes after x=C
constraint z = enum_next(Letters, x);