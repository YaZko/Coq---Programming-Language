(* Exercise 1 *)
(* Define an inductive type for the months in the gregorian calendar *)
(*(the French civil calendar) *)
Inductive month : Set :=
|January : month
|February : month
|March : month
|April : month
|May : month
|June : month
|July : month
|August : month
|September : month
|October : month
|November : month
|December : month.

(* Define an inductive type for the four seasons *)
Inductive season : Set :=
|Autumn : season
|Winter : season
|Spring : season
|Summer : season.

(* What is the inductive principle generated in each case ?*)
Check month_ind.
Check season_ind.

(* Define a function mapping each month to the season that contains *)
(* most of its days, using pattern matching *)
Definition season_of_month (m : month) :=
  match m with
    |January => Winter
    |February => Winter
    |March => Winter
    |April => Spring
    |May => Spring
    |June => Spring
    |July => Summer
    |August => Summer
    |September => Summer
    |October => Autumn
    |November => Autumn
    |December => Autumn
  end.

(* Exercise 2 *)
(* Define the boolean functions bool_xor, bool_and, bool_eq of type *)
(*bool -> bool -> bool, and the function bool_not of type bool -> bool *)
Definition bool_not (b:bool) : bool := if b then false else true.

Definition bool_xor (b b':bool) : bool := if b then bool_not b' else b'.

Definition bool_and (b b':bool) : bool := if b then b' else false.

Definition bool_or (b b':bool) := if b then true else b'.


Definition bool_eq (b b':bool) := if b then b' else bool_not b'.
  

(* prove the following theorems:*)
Lemma bool_xor_not_eq : forall b1 b2 : bool,
  bool_xor b1 b2 = bool_not (bool_eq b1 b2).
Proof.
  intros b1 b2; case b1; case b2; simpl; trivial.
Qed.

Lemma bool_not_and : forall b1 b2 : bool,
  bool_not (bool_and b1 b2) = bool_or (bool_not b1) (bool_not b2).
Proof.
  intros b1 b2; case b1; case b2; simpl; trivial.
Qed.

Lemma bool_not_not : forall b : bool, bool_not (bool_not b) = b.
Proof.
 intro b; case b; simpl; trivial.
Qed.

Lemma bool_or_not : forall b : bool, 
  bool_or b (bool_not b) = true.
Proof.
  intro b; case b; simpl; trivial.
Qed.

Lemma bool_id_eq : forall b1 b2 : bool, 
  b1 = b2 <-> bool_eq b1 b2 = true.
Proof.
  intros b1 b2 ;split.  
 intro H;rewrite  H;  case b2; trivial.
 case b1; case b2; simpl; trivial.
  intro e;discriminate e.
Qed.


Lemma bool_not_or : forall b1 b2 : bool,
  bool_not (bool_or b1 b2) = bool_and (bool_not b1) (bool_not b2).
Proof.
  intros b1 b2; case b1; case b2; simpl; trivial.
Qed.

Lemma bool_or_and : forall b1 b2 b3 : bool,
  bool_or (bool_and b1 b3) (bool_and b2 b3) = 
  bool_and (bool_or b1 b2) b3.
Proof.
  intros b1 b2 b3; case b1; case b2; case b3; simpl; trivial.
Qed.

(* Exercise 3 *)

(* Let us consider again the type color defined in the lecture :*)
Inductive color:Type :=
 | white | black | yellow | cyan | magenta | red | blue | green.

(* let us define the complement of a color *)

Definition compl (c : color) :=
 match c with 
 | white => black 
 | black => white
 | yellow => blue
 | cyan => red
 | magenta => green
 | red => cyan
 | blue => yellow
 | green => magenta
 end.

(*
Prove the following results:*)

Lemma compl_compl : forall c, compl (compl c)= c.
Proof.
 intro c;case c;simpl;trivial.
Qed.



Lemma compl_injective : forall c c', compl c = compl c' -> c = c'.
Proof.
 intro c;case c;intro c';case c';simpl;intro e;try discriminate;trivial.
Qed.




Lemma compl_surjective : forall c, exists c', c= compl  c'.
Proof.
 intro c; exists (compl c);rewrite compl_compl;trivial.
Qed.





(** Exercise 4 *)

(* Define an inductive type formula : Type that represents the *)
(*abstract language of propositional logic without variables: 
L = L /\ L | L \/ L | ~L | L_true | L_false
*)
Inductive formula : Type :=
|L_true : formula
|L_false : formula
|L_and : formula -> formula -> formula
|L_or : formula -> formula -> formula
|L_neg : formula -> formula.
  

(* Define a function formula_holds of type (formula -> Prop computing the *)
(* Coq formula corresponding to an element of type formula *)
Fixpoint formula_holds (f : formula) : Prop :=
  match f with
    |L_true => True
    |L_false => False
    |L_and f1 f2 => (formula_holds f1) /\ (formula_holds f2)
    |L_or f1 f2 =>  (formula_holds f1) \/ (formula_holds f2)
    |L_neg f => ~(formula_holds f)
  end.
 
(* Define  a function isT_formula of type (formula -> bool) computing *)
(* the intended truth value of (f : formula) *)
Fixpoint isT_formula (f : formula) : bool :=
  match f with
    |L_true => true
    |L_false => false
    |L_and f1 f2 => andb (isT_formula f1) (isT_formula f2)
    |L_or f1 f2 =>  orb (isT_formula f1) (isT_formula f2)
    |L_neg f => negb (isT_formula f)
  end.


(* prove that is (idT_formula f) evaluates to true, then its *)
(*corresponding Coq formula holds ie.:*)
Require Import Bool.
Lemma isT_formula_correct : forall f : formula, 
   isT_formula f = true <-> formula_holds f.
Proof.
induction f; simpl; split; trivial.
(* False *)
discriminate.
intro h; elim h.
(* And *)
case_eq (isT_formula f1); intro h1; case_eq (isT_formula f2); intro
   h2; try discriminate 1.
  split; [apply IHf1 | apply IHf2]; trivial.

  destruct IHf1 as [IHf1_1 IHf1_2].
  destruct IHf2 as [IHf2_1 IHf2_2].
  destruct 1.
  rewrite IHf1_2; trivial.
  rewrite IHf2_2; trivial.
(* Or *)
case_eq (isT_formula f1); intro h1; case_eq (isT_formula f2); intro
   h2; try discriminate 1.
  left; apply IHf1; trivial.
  left; apply IHf1; trivial.
  right; apply IHf2; trivial.

intro h.
destruct IHf1 as [IHf1_1 IHf1_2].
destruct IHf2 as [IHf2_1 IHf2_2].
destruct h as [h1 | h2].
  rewrite IHf1_2; trivial.
  rewrite IHf2_2; trivial.
  SearchAbout orb.
  rewrite orb_true_r; trivial.
(* False *)
destruct IHf as [IHf_1 IHf_2].
case_eq (isT_formula f).
  discriminate 2.
  intros h1 _ h3.
  generalize h1.
  rewrite IHf_2; trivial.
  discriminate 1.
destruct IHf as [IHf_1 IHf_2].
case_eq (isT_formula f); trivial.
intros h1 h2.
absurd (formula_holds f); trivial.
apply IHf_1.
trivial.
Qed.




(* Exercise 5 *)
(* We use the inductive type defined in the lecture:*)
Inductive natBinTree : Set :=
| Leaf : natBinTree
| Node : nat -> natBinTree -> natBinTree -> natBinTree.

(*
Define a function which sums all the values present in the tree.
*)
Fixpoint sum_natBinTree (t : natBinTree) :=
  match t with
    |Leaf => 0
    |Node n t1 t2 => n + (sum_natBinTree t1) + (sum_natBinTree t2)
  end.

(*
Define a function is_zero_present : natBinTree -> bool, which tests if 
the value 0 is present in the tree.
*)
Fixpoint is_zero_present (t : natBinTree) :=
  match t with
    |Leaf  => false
    |Node n t1 t2 => 
      match n with
        |0 => true
          |_ => 
            (is_zero_present t1) || (is_zero_present t2)
      end
  end.
