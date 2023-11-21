⎕io ← 0 ⍝ Chris McLaughlin - V00912353

count ← { +/ 'ACGT' ∘.∊ '',⍵ }    ⍝ replace 0 with your one-line implementation

count_t ← ('' (+/ 'ACGT' ∘.∊ ,) ⊢)  ⍝ replace ⊢ with your one-line implementation

gc ← { 100×(((+/ 'C' ∘.∊ ⍵) + (+/ 'G' ∘.∊ ⍵)) ÷ ⍴ ⍵) }       ⍝ replace 0 with your one-line implementation

gc_t ←  ('CG' (100×((≢⊢)÷⍨(+/(+/∘.∊)))) ⊢)     ⍝ replace ⊢ with your one-line implementation

magic ← { ((⍴ sums)⍴1) ≡ (sums = ⊃sums) ⊣ sums ←   ∊(   (+/⍵) ((+⌿⍵)) (+/ ({ { orig_gamma ⌷⍨ ⍵ } ¨ (↓⍉↑ (⍳≢⍵) (⍳≢⍵)) ⊣ orig_gamma←⍵ } ⍵)) (+/ ({ { orig_gamma ⌷⍨ ⍵ } ¨ (↓⍉↑ (⍳≢⍵) (⊖(⍳≢⍵))) ⊣ orig_gamma←⍵ } ⍵))   )   }    ⍝ replace 0 with your one-line implementation

magic_t ← ( ⊢ )  ⍝ replace ⊢ with your one-line implementation