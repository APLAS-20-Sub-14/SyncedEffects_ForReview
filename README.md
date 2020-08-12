# A Synced Effects Logic of Esterel

## For both Logical Correctness and Temporal Verification


Esterel is an imperative style language that has found success in many safety-critical applications. Its precise semantics makes it natural for programming and reasoning. Existing techniques tackle either one of its main challenges: correctness checking or temporal verification. To resolve the issues simultaneously, we propose a new solution via a Hoare-style forward verifier and a term rewriting system (T.r.s) on Synced Effects. The first contribution is the novel effects logic computes the deterministic program behaviour via construction rules at the source level, defining program evaluation syntactically. As a second contribution, by avoiding the complex translation from temporal properties to Esterel programs, our purely algebraic T.r.s efficiently checks the temporal properties described by the Synced Effects. We prototype this logic on top of the HIP/SLEEK system and show our method’s feasibility using a number of case studies.

### To Compile:

```
git clone https://github.com/APLAS-20-Sub-14/SyncedEffects.git
cd SyncedEffects
chmod 755 clean 
chmod 755 compile 
./compile
```

### Dependencies:

```
opam switch create 4.07.1
eval $(opam env)
sudo apt-get install menhir
sudo apt-get install z3
```


### Entailments Checking Examples:
1. APLAS20_fig7:
```
/*
    ensure [ A, E  ] . [  B, C,   F ] . [ G] \/ (_^*) . [G]
*/

(signal A (signal B (signal C (signal D (signal E (signal F (signal G 
  (
  (emit A;
    (pause;
      (emit B;
        emit C
      )))
  ||
  (emit E;
    (pause;
      (emit F;
        (pause;
          emit G
        )))))
)))))))
```
Results by executing ./hip src/programs/APLAS20_fig7.txt
```
<<<<< Logical Correctness Checking >>>>>
=========================
Logical correct! 
Forward Result = 
[ A    E  ] . [  B C   F ] . [       G]

 <<<<< Temporal Verification >>>>>
====================================
[A;E].[B;C;F].[G] |- [A;E].[B;C;F].[G] + (_)^*.[G]
[Result] Succeed
[Verification Time: 9e-05 s]
 

* [A;E].[B;C;F].[G] |- [A;E].[B;C;F].[G] + (_)^*.[G]
* └── (-[A;E])[A;E].[B;C;F].[G] |- [A;E].[B;C;F].[G] + (_)^*.[G]   [UNFOLD]
*     └── (-[B;C;F])[B;C;F].[G] |- [B;C;F].[G] + (_)^*.[G]   [UNFOLD]
*         └── (-[G])[G] |- [G] + (_)^*.[G]   [UNFOLD]
*             └── Emp |- (_)^*.[G] + Emp   [PROVE]
```

2. APLAS20_fig9:
```
/*
    ensure (_) .(( _ . [   C])^w)
*/

(signal A
(signal B 
(signal C
 (
 emit A;
 (loop 
 (pause;
 (
   emit B;
   (
   pause;
   emit C   
   ) 
   )
 ))))))
```
Results by executing ./hip src/programs/APLAS20_fig7.txt.
```
<<<<< Logical Correctness Checking >>>>>
=========================
Logical correct! 
Forward Result = 
[ A  ] . ([  B ] . [   C])^w . 

 <<<<< Temporal Verification >>>>>
====================================
[A].([B].[C])^w.[] |- _.(_.[C])^w
[Result] Succeed
[Verification Time: 6e-05 s]
 

* [A].([B].[C])^w.[] |- _.(_.[C])^w
* └── (-[A])[A].([B].[C])^w.[] |- _.(_.[C])^w   [UNFOLD]
*     └── (-[B])([B].[C])^w |- (_.[C])^w   [UNFOLD]
*         └── (-[C])[C].([B].[C])^w.[] |- [C].(_.[C])^w   [UNFOLD]
*             └── ([B].[C])^w |- (_.[C])^w   [PROVE]
```

3. causality_check:
```
/*
    ensure [ SO1,  SL1, SL2 ]
*/

(signal SO1 (signal SO2 
(signal SL1 (signal SL2 (signal SL3
(
  (present SL1
    (present SL2 
              emit SO1 
              emit SL3) 
    (present SL2 
              emit SO2 
              emit SL3))
||
  (emit SL2;
  ((present SL3 pause nothing);
    emit SL1 ))))
))))
```
Results by executing ./hip src/programs/causality_check.txt.
```
<<<<< Logical Correctness Checking >>>>>
=========================
Logical correct! 
Forward Result = 
[ SO1  SL1 SL2 ]

 <<<<< Temporal Verification >>>>>
====================================
[SO1;SL1;SL2] |- [SO1;SL1;SL2]
[Result] Succeed
[Verification Time: 2.2e-05 s]
 

* [SO1;SL1;SL2] |- [SO1;SL1;SL2]
* └── (-[SO1;SL1;SL2])[SO1;SL1;SL2] |- [SO1;SL1;SL2]   [UNFOLD]
*     └── Emp |- Emp   [PROVE]
```


### Examples:

Entailments Checking 

```
./sleek src/effects/test1.txt 
```

Program Verification

```
./hip src/programs/fig5.txt
```

LTL to Effects Translator

```
./ltl src/ltl/Traffic_light.ltl 
```

### To Clean:

``` 
./clean
```

 
