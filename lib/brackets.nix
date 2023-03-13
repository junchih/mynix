{ mylib
, ...
}@file-args:

let
  inherit (builtins)
    isFunction
    foldl'
    head
    tail
    length
    ;
  inherit (mylib)
    I
    ;
in
rec {

  # binding: just like function call, if arg is a function, push to stack
  # if not, applying stack top to it, and repeat.
  # binding K (map f) a {} == map f a
  # binding K (map f) (filter g) a {} == map f (filter g a)
  binding = __binding [ ];

  __binding = stack: a:
    if !(isFunction a) && stack == [ ] then
      a
    else if isFunction a then
      b: __binding ([ a ] ++ stack) b
    else # length stack >= 1
      let
        top = head stack;
        rest = tail stack;
      in
      __binding rest (top a);

  # assign: just like binding, but with reversed order
  # assign a (map f) K {} == map f a
  # assign a (filter g) (map f) K {} == map f (filter g a)
  assign = __assign [ ];

  __assign = stack: a:
    if !(isFunction a) then
      b: __assign ([ a ] ++ stack) b
    else if length stack < 1 then
      a
    else
      let
        top = head stack;
        rest = tail stack;
      in
      __assign rest (a top);

  # nArg:
  # mapping = nArg 2 [1 2 3] map
  # mapping (x: x + 1) == [2 3 4]
  nArg = n: x: f:
    if n < 1 || !(isFunction f) then f
    else if n == 1 then f x
    else a: nArg (n - 1) x (f a);
  nArg1 = nArg 1;
  nArg2 = nArg 2;
  nArg3 = nArg 3;
  nArg4 = nArg 4;
  nArg5 = nArg 5;

  # foldr': (a -> b -> c) -> list -> iv
  # foldr' f [a, b, c] d == f a (f b (f c d))
  foldr' = op: ls: iv:
    foldl' (f: b: c: f (op b c)) I ls iv;

  # rapply: list -> iv -> a
  # rapply [a b c d] iv == a (b (c (d iv)))
  # If a b c d, any of them are not function, the applying will return itself.
  # E.g. a is not function, (a b) == a
  rapply = ls: iv:
    foldr' (a: b: if isFunction a then a b else a) ls iv;

  # lapply: iv -> list -> a
  # lapply iv [a b c d] == iv a b c d
  # More see rapply
  lapply = iv: ls:
    foldl' (a: b: if isFunction a then a b else a) iv ls;
}
