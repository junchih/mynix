{ mylib
, ...
}@file-args:

let
  inherit (builtins)
    isFunction
    foldl'
    ;
  inherit (mylib)
    I
    ;
in
rec {

  # binding: a -> (a | (f: b -> (c | f)))
  # binding a b c d e == a (b (c (d e)))
  # Or with haskell $ operator, a $ b $ c $ d $ e
  binding = a:
    if !(isFunction a) then a
    else b:
      if !(isFunction b) then a b
      else c:
        binding a (binding b c);

  # assign: a -> (a -> b) -> (b -> c) -> (c -> d) -> ... -> e
  # assign a b c d e null == e (d (c (b a)))
  # like >>= operator in haskell
  assign = val: f:
    if f == null then val
    else assign (f val);

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
