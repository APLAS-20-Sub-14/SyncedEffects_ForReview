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
```
/*
    ensure ([S2 ]^*)
*/

(signal S2 (signal S1 
(signal S
  (present S emit S1 emit S2))
))
```
Execution results:
```
<<<<< Logical Correctness Checking >>>>>
=========================
Logical correct! 
Forward Result = 
[ S2  ]

 <<<<< Temporal Verification >>>>>
====================================
[S2] |- ([S2])^*
[Result] Succeed
[Verification Time: 2.1e-05 s]
 

* [S2] |- ([S2])^*
* └── (-[S2])[S2] |- ([S2])^*   [UNFOLD]
*     └── Emp |- ([S2])^*   [PROVE]
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

 
