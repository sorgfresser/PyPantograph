/-
Task: prove that f(x) = 1/x has a vertical asymptote (unbounded limit) at x = 0 from both sides.

def unbounded_limit (f : ℝ → ℝ) (c : ℝ) : Prop := ∀ M > 0, ∃ δ > 0, ∀ x, 0 < |x - c| < δ → M < |f x|

theorem one_over_x_has_vertical_asymptote_both_sides : lim_{x -> c} f(x) = +-∞
Proof:
consider any M > 0
now show: ∃ δ > 0, ∀ x, 0 < |x - c| < δ → M < |f x|
So show: ∃ δ > 0, ∀ x, 0 < |x| < δ → M < |1/x|, so in particular don't forget you want -δ < x < δ when guessing δ from goal.
-- guess, delta (s.tif antecedent holds goal holds), so use goal M < |f(x)|, which is M < |1/x| ->
  1. M < 1/x (so x > 0 since M>0) -> x < M^⁻¹
  2. M < -1/x (so x < 0 since M>0 <-> M <-M) -> M * -x < 1 -> -x < M^⁻¹ -> -M^⁻¹ < -x
1 & 2  means -M^⁻¹ < x < M^⁻¹ <-> |x| < M^⁻¹, so choose δ = M^⁻¹
-- end guess heuristic reasoning
So continue proof by choosing δ = M^⁻¹, and then show that for all x, 0 < |x| < δ -> M < |1/x|
wts: for all x, 0 < |x| < M⁻¹ → M < |1/x|
so consider any x such that 0 < |x| < M⁻¹
I don't really know how to manipulate things freely with abs |.| so I will consider all the cases.
Hypothesis: 0 < |x| < M⁻¹ <-> either 0 < x < M⁻¹ or 0 < -x < M⁻¹ so for both cases we need to show it implies (either because x ∈ ℝ cannot satisfy both)
Goal: M < |1/x| <-> M < 1/x for positives or M < -1/x for negatives (either because 1/x ∈ ℝ cannot satisfy both)
case 1: I conjecture 0 < x < M⁻¹ -> M < 1/x
  1. M < 1/x -> x < 1/M = M^⁻¹ (valid since M > 0, so 1/M > 0, x > 0 so 1/x > 0)
  2. 0 < x < M^⁻¹ (as currently required)
case 2: I conjecture 0 < -x < M⁻¹ -> M < -1/x
  1. M < -1/x -> M * -x < 1 -> -x < 1/M = M^⁻¹ (valid since M > 0, so 1/M > 0, -x > 0 so -1/x > 0)
  2. 0 < -x < M^⁻¹ (as currently required)
Qed.

facts we will need (I think):
identity cancellation (which needs val ≠ 0)
multiply on both sides by some value and inequality doesn't change (or if it does that we show the multiplying val is negative)
simplifying 1 * val = val in either side
perhaps communtativity or/and associativity of multiplication to make sure things cancel simplifying as needed

note: to concluse p ∨ q we only need to show p or q, so we can consider them separately (if one holds you can conclude the disjoncution but also if both hold)
-/
import Mathlib.Data.Real.Basic

-- define f(x) = 1/x = x^⁻¹ for x ≠ 0 latter for mathlib notation (less friction during proofs)
noncomputable def f (x : ℝ) : ℝ := x⁻¹
#check f
-- note evals don't work so for unit tests we will de a theorem, due to ℝ not being "computable"
theorem f_evals_unit_test : f 2 = 1/2 := by simp [f]
#print f_evals_unit_test

-- define unbounded limit (form both sides) as a predicate (proposition)
def unbounded_limit (f : ℝ → ℝ) (c : ℝ) : Prop := ∀ M : ℝ, 0 < M → ∃ δ : ℝ, 0 < δ ∧ ∀ x : ℝ, 0 < |x - c| ∧ |x - c| < δ → M < |f x|
#check unbounded_limit
#print unbounded_limit
-- note: writing everything in terms of lt since gt is written in terms of lt

-- theorem to prove that f(x) = 1/x has a vertical asymptote (unbounded limit) at x = 0 from both sides
theorem one_over_x_has_vertical_asymptote_both_sides : unbounded_limit f 0 := by
  unfold unbounded_limit f
  -- consider some M > 0
  intro M h_zero_lt_M
  -- since goal doesn't have zeros, but we want to use it to match the antecedent, let's simplify the zeros by using the fact x - 0 = 0 at the goal
  simp only [sub_zero]
  -- guess δ = M^⁻¹ using goal i.e. M < |1/x| so M < 1/x so x < 1/M = M^⁻¹ and -M < -1/x so -x < M^⁻¹ as δ = M^⁻¹ should work
  use M⁻¹
  -- show 0 < δ = M^⁻¹, first deconstruct the ∧ in the goal
  apply And.intro
  -- show 0 < M^⁻¹
  . exact inv_pos.2 h_zero_lt_M
  . --introduce x and hypothesis deconstructed by and
    intro x ⟨h_zero_lt_abs_x, h_x_lt_δ⟩
    -- unfold abs on hypothesis and goal (since I assume it's harder to manipulate abs |.| function)
    #check abs -- abs := mabs (a : α) : α := a ⊔ a⁻¹ == a -> a ⊔ -a
    unfold abs at h_x_lt_δ h_zero_lt_abs_x; unfold abs

    -- want to show (wts) M < |1/x|, so transform the goal to M < 1/x for x > 0 and M < -1/x for x < 0
    -- transform the goal M < x⁻¹ ⊔ -x⁻¹ --> M < x⁻¹ ∨ M < -x⁻¹
    #check lt_sup_iff -- lt_sup_iff : a < b ⊔ c ↔ a < b ∨ a < c
    -- simp only [lt_sup_iff] -- also works
    apply lt_sup_iff.mpr
    -- transform hypothesis 0 < x ⊔ -x --> 0 < x ∨ 0 < -x
    apply lt_sup_iff.mp at h_zero_lt_abs_x
    -- transform hypothesis x ⊔ -x < M⁻¹ --> x < M⁻¹ ∧ -x < M⁻¹
    #check sup_lt_iff -- sup_lt_iff : a ⊔ b < c ↔ a < c ∧ b < c
    apply sup_lt_iff.mp at h_x_lt_δ
    -- to try to close goal M < |1/x|, let's consider both cases by break h_zero_lt_abs_x into both cases 0 < x and 0 < -x and close goals with both cases
    #check Or
    #check Or.inl
    cases h_zero_lt_abs_x with -- TODO: how to name hypothesis with cases in lean4
      | inl h_x_pos =>
        -- focus on positive target M < x⁻¹ given we are on the x > 0 case x, so also use positive hypothesis x < M⁻¹, simplify any 1 * val = val or val * 1 = val
        apply Or.inl
        apply And.left at h_x_lt_δ
        -- on goal: mul right goal both sides by x (x > 0), then cancel x⁻¹ with mul x (needs x⁻¹ ≠ 0)
        have h_x_ne_zero : x ≠ 0 := ne_of_gt h_x_pos
        -- mul both sides by M right
        #check mul_lt_mul_right -- (a0 : 0 < a) : b * a < c * a ↔ b < c
        -- exact (lt_inv h_zero_lt_M h_x_pos).mpr h_x_lt_δ -- also worked!
        rw [← mul_lt_mul_right h_x_pos]
        nth_rewrite 2 [mul_comm]
        #check mul_inv_cancel -- (h : a ≠ 0) : a * a⁻¹ = 1
        rw [mul_inv_cancel h_x_ne_zero]
        -- move M to the left by mul by M⁻¹ > 0 (needs M⁻¹ ≠ 0 and/or M ≠ 0)
        have h_M_inv_lt_zero : 0 < M⁻¹ := inv_pos.2 h_zero_lt_M
        rw [← mul_lt_mul_left h_M_inv_lt_zero]
        rw [← mul_assoc]
        have h_M_ne_zero : M ≠ 0 := ne_of_gt h_zero_lt_M
        nth_rewrite 2 [mul_comm]; rewrite [mul_inv_cancel h_M_ne_zero]; simp
        assumption
      | inr h_x_neg =>
        -- focus on negative target M < -x⁻¹ given we are on the x < 0 case x, so also use negative hypothesis -x < M⁻¹, simplify any 1 * val = val or val * 1 = val
        apply Or.inr
        apply And.right at h_x_lt_δ
        -- pass -x⁻¹ to the left and pass M to the right
        #check neg_lt -- -a < b ↔ -b < a
        -- transform expression -(x⁻¹) to (-x)⁻¹
        #check neg_inv -- -a⁻¹ = (-a)⁻¹
        rw [neg_inv]
        -- multiply both sides by -x (needs -x > 0) left
        #check mul_lt_mul_left -- (a0 : 0 < a) : a * b < a * c ↔ b < c
        rw [← mul_lt_mul_left h_x_neg]
        -- simp only [neg_mul, neg_lt_neg_iff]
        have h_neg_x_ne_zero : -x ≠ 0 := ne_of_gt h_x_neg
        rw [mul_inv_cancel h_neg_x_ne_zero]
        -- move M to the right of the lt by mul right by 0 < M⁻¹ (needs M ≠ 0 for inv cancelation)
        have h_M_inv_lt_zero : 0 < M⁻¹ := inv_pos.mpr h_zero_lt_M
        rw [← mul_lt_mul_right h_M_inv_lt_zero]
        rw [mul_assoc]
        have h_M_ne_zero : M ≠ 0 := ne_of_gt h_zero_lt_M
        simp only [mul_inv_cancel h_M_ne_zero]
        simp
        assumption
