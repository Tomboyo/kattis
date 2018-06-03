# PROBLEM DESCRIPTION:
See [Bobby's Bet](https://open.kattis.com/problems/bobby).

# SOLUTION DESCRIPTION:
This solution uses a combinatorial approach. Based on the `S`, `R`, `X`, and `Y` parameters, we determine the proportion of expected successful attempts, where 1 indicates that all attempts should succeed and 0 indicates that all attempts should fail. We multiply this proportion by the payoff `W`; if this value is greater than 1, we expect that Bobby will profit over time and should therefore take the bet.

Each time Bobby makes an attempt, there are a variety of ways in which he can roll at least `X` successes: Bobby could get exactly `X` successes, exactly `X + 1` successes, exactly `X + 2`, and so on up to `Y`. Each way with exactly `k` successes has a probability of occurring. We determine this probability by calculating the probability of a successful die result (`R` or higher) and the probability of an unsuccessful die result (less than `R`), and taking an appropriate product. That is, we take the success probability to the power of `k` and the failure probability to the power of `Y - k`, then multiply them together, thus giving us the likelihood that we roll exactly `k` successes and `Y - k` failures on `Y` dice. Finally, we sum the likelihoods for each possible value of `k` (which ranges from `X` to `Y`), giving us the proportion of attempts which result in success.

The probability of a die roll with `S` sides coming up with a value of at least `R` is `(S - R + 1) / S`, the number of sides on the die which indicate success out of the total number of sides.