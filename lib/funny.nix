{ ... }:

{
  # Y combinator
  Y = f: (x: f (x x)) (x: f (x x));

  # SKI combinator
  S = x: y: z: x z (y z);
  K = x: y: x;
  I = x: x;

  # BCKW combinator
  B = x: y: z: x (y z);
  C = x: y: z: x z y;
  W = x: y: x y y;
}
