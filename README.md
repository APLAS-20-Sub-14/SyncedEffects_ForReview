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

## Next, we display examples upon (1) Esterel Program Verification, (2) Entailments Checking, and (3) LTL to Effects Translation 

### (1) Program Verification Examples:
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


### (2) Entailments Checking Examples:
1 ./sleek src/effects/Disjunction_both.ee
```
====================================
[A;B] + [C] + [B;D] |- [A;D] + [B]
[Result] Fail
[Verification Time: 5.6e-05 s]
 

* [A;B] + [C] + [B;D] |- [A;D] + [B]
* └── (-[A;B])[A;B] + [C] + [B;D] |- [A;D] + [B]   [UNFOLD]
*     ├── (-[C])[A;B] + [C] + [B;D] |- [A;D] + [B]   [UNFOLD]
*     │   ├── (-[B;D])[A;B] + [C] + [B;D] |- [A;D] + [B]   [UNFOLD]
*     │   │   └── Emp |- Emp   [PROVE]
*     │   └── Emp |- _|_   [DISPROVE]
*     └── Emp |- Emp   [PROVE]

====================================
[A;B] + [C] + [B;D] |- [A;D] + [B] + [C]
[Result] Succeed
[Verification Time: 8.2e-05 s]
 

* [A;B] + [C] + [B;D] |- [A;D] + [B] + [C]
* └── (-[A;B])[A;B] + [C] + [B;D] |- [A;D] + [B] + [C]   [UNFOLD]
*     ├── (-[C])[A;B] + [C] + [B;D] |- [A;D] + [B] + [C]   [UNFOLD]
*     │   ├── (-[B;D])[A;B] + [C] + [B;D] |- [A;D] + [B] + [C]   [UNFOLD]
*     │   │   └── Emp |- Emp   [PROVE]
*     │   └── Emp |- Emp   [PROVE]
*     └── Emp |- Emp   [PROVE]

====================================
[A;C] + ([B;D])^* |- (_)^* + [A]
[Result] Succeed
[Verification Time: 5.4e-05 s]
 

* [A;C] + ([B;D])^* |- (_)^* + [A]
* └── (-[A;C])[A;C] + ([B;D])^* |- (_)^* + [A]   [UNFOLD]
*     └── (-[B;D])[A;C] + ([B;D])^* |- (_)^* + [A]   [UNFOLD]
*         └── (-[B;D])([B;D])^* |- (_)^*   [UNFOLD]
*             └── ([B;D])^* |- (_)^*   [PROVE]

====================================
[D;B] + [A;B].[C;D] |- [A].[C] + [B]
[Result] Succeed
[Verification Time: 6.6e-05 s]
 

* [D;B] + [A;B].[C;D] |- [A].[C] + [B]
* └── (-[D;B])[D;B] + [A;B].[C;D] |- [A].[C] + [B]   [UNFOLD]
*     └── (-[A;B])[D;B] + [A;B].[C;D] |- [A].[C] + [B]   [UNFOLD]
*         └── (-[C;D])[C;D] |- [C] + Emp   [UNFOLD]
*             └── Emp |- Emp   [PROVE]

====================================
[A;B] + [C;D] + [E] |- [B] + (_)^*
[Result] Succeed
[Verification Time: 6.8e-05 s]
 

* [A;B] + [C;D] + [E] |- [B] + (_)^*
* └── (-[A;B])[A;B] + [C;D] + [E] |- [B] + (_)^*   [UNFOLD]
*     ├── (-[C;D])[A;B] + [C;D] + [E] |- [B] + (_)^*   [UNFOLD]
*     │   ├── (-[E])[A;B] + [C;D] + [E] |- [B] + (_)^*   [UNFOLD]
*     │   │   └── Emp |- (_)^*   [PROVE]
*     │   └── Emp |- (_)^*   [PROVE]
*     └── Emp |- Emp + (_)^*   [PROVE]
```


### (3) LTL to Effects Translator Examples:

./ltl src/ltl/Traffic_light.ltl 

```
====================================
([] Green)

[Translated to Effects] ===>
 
([ Green])^* 

====================================
(<> Green)

[Translated to Effects] ===>
 
(_)^* . [ Green] 

====================================
(<> Red)

[Translated to Effects] ===>
 
(_)^* . [ Red] 

====================================
(<> Yellow)

[Translated to Effects] ===>
 
(_)^* . [ Yellow] 

====================================
(<> ([] Green))

[Translated to Effects] ===>
 
(_)^* . ([ Green])^* 

====================================
([] (<> Red))

[Translated to Effects] ===>
 
((_)^* . [ Red])^* 

====================================
((<> Red) -> (! (Green U Red)))

[Translated to Effects] ===>
 
(!(_)^* . [ Red])
(!([ Green])^* . [ Red]) 

====================================
([] (Red -> (! (XGreen))))

[Translated to Effects] ===>
 
((![ Red]))^*
((!_ . [ Green]))^* 

====================================
([] (Red -> (<> Green)))

[Translated to Effects] ===>
 
((![ Red]))^*
((_)^* . [ Green])^* 

====================================
([] (Red -> ([] (! Green))))

[Translated to Effects] ===>
 
((![ Red]))^*
(((![ Green]))^*)^* 

====================================
([] (Red -> (! (Green U Yellow))))

[Translated to Effects] ===>
 
((![ Red]))^*
((!([ Green])^* . [ Yellow]))^* 

====================================
([] (Red -> (X(Red U Yellow))))

[Translated to Effects] ===>
 
((![ Red]))^*
(_ . ([ Red])^* . [ Yellow])^* 

====================================
([] (Red -> (X(Red U (X(Yellow U Green))))))

[Translated to Effects] ===>
 
((![ Red]))^*
(_ . ([ Red])^* . _ . ([ Yellow])^* . [ Green])^* 
```

### To Clean:

``` 
./clean
```

 
