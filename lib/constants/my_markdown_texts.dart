class MyMarkdownTexts {
  static const introMarkdown = """
# Register Machine Simulator

This website offers simulation and Gödelisation for **Register Machines**. As a part of the "Models of Computation" syllabus at Imperial College, I made this tool (originally as a CLI written in Haskell) during the term. Since then, I have decided to hide away the Haskell complications and release it as a website so that it can be more accessible.

A good way to start is to click on the "Simulation" tab and check out the examples there : )

This page contains a short description of what are Register Machines and how to use this website. For more information, please check out [here](https://github.com/sorrowfulT-Rex/Haskell-RM#readme).

## Introduction

A Register Machine is a simple system involving a finite number of registers (each can hold a natural number), a finite number of lines, and only three instructions (increment, decrement and halt).  

An increment instruction takes a register and a line. It increments a the register and jumps to the given line.  

A decrement instruction takes a register and two line s (say `m` and `n`). If the register is positive, it decrements the value and jumps to line `m`. Otherwise it jump to line `n` (without changing the register, which is still 0).  

A halt instruction terminates the machine. If we jump to a line that does not exist, it is treated as a halt instruction as well.

Consider the following example:

```Register Machine
L0: R1- 1 2
L1: R0+ 0
L2: R2- 3 4
L3: R0+ 2
L4: HALT
```

Assume `R0 = 0`, `R1 = 1` and `R2 = 2`. We start from line 0; which decrements R1 and goes to line 1; which increments R0 and goes back to line 0; which goes to line 2 since `R1 = 0`; which decrements R2 and goes to line 3; which increments R0 and goes to line 2; which decrements R2 and goes to line 3; which increments R0 and goes to line 3; which goes to line 4 since `R2 = 0`; which halts with `R0 = 3`, `R1 = 0` and `R2 = 0`.

If we treat R0 as the result and the other registers as the input, then a Register Machine that has registers from R0 to R{n} is a partial function from N^n to N (it is partial because the machine may not terminate, thus not providing any result). In our previous example, the function is `f(R1, R2) = R1 + R2`.  

Despite its first appearance, Register Machines are actually very powerful: the system is Turing-complete. This means they are capable of basically whatever modern computers can do.

## Performance

As one may imagine, Register Machines are in general very inefficient since it can increment or decrement at most one register at a time. For example (they are available in the "Simulation" tab), the adder machine which computes `f(x, y) = x + y` takes `2(x + y) + 3` steps, and the multiplier machine which computes `f(x, y) = xy` takes `5xy + 3x + 2` steps. If we take the input size as the number of digits the inputs have, then these two "trivial" functions both have exponential time complexity.

As a result, a naïve Register Machine simulation is pretty useless except for extremely small inputs. In my implementation, the simulator analyses the control flow of the machine, detecting execution cycles, and execute the iterations in one go. For example, the adder machine consists of a R0-R1 cycle and a R0-R2 cycle where the contents of both inputs "flow" into R0. With my optimisation, each cycle only consists of one step during the simulation so that the execution has *de juro* constant-time.

This optimisation also makes simulating the Universal Register Machine(a Register Machine that can simulate all Register Machines) possible.

If an infinite loop is detected, the simulator would end immediately and report the machine is never going to terminate. Of course, it is not able to detect all infinite loops since the Halting Problem is undecidable.
""";
}
