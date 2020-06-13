% include "globals.mzn";
% Since the documentation is unclear, wrote this test to figure
% out whether enums wrap around or not.
% enum Letters;

enum Letters;

Letters = {A,B,C};

var Letters: a;
var Letters: b;
constraint a=A;
constraint b=B;

var set of Letters: d;

constraint d = set_diff(Letters,a..b);