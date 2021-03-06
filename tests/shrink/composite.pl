:- multifile quickcheck:composite/3.
quickcheck:composite(even, I:integer, X) :-
  X is 2 * I.

quickcheck:composite(odd, I:integer, X) :-
  X is 2 * I + 1.

:- multifile quickcheck:has_type/2.
quickcheck:has_type(odd, X) :-
  integer(X),
  1 is X mod 2.

:- begin_tests(shrink_composite).

prop_even_numbers(E:even) :-
  E mod 2 =:= 0,
  E < 12.

test('all even numbers mod two equals zero', [forall(test_count_generator(_))]) :-
  catch(quickcheck(prop_even_numbers/1), error(counter_example, [E:even]), true),
  E >= 12.

% an odd plus an even is an odd
prop_odd_plus_even(O:odd, E:even) :-
  Sum is O + E,
  is_of_type(odd, Sum),
  Sum < 4.

test('even numbers plus odd numbers gives odd', [forall(test_count_generator(_))]) :-
  catch(quickcheck(prop_odd_plus_even/2), error(counter_example, [O:odd, E:even]), true),
  S is O + E,
  S >= 4.

:- end_tests(shrink_composite).