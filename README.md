# Kattis Solutions
Solutions to [Open Kattis](https://open.kattis.com/) problems.

Solutions to problems are in `/solutions/<problem-name>`, where problem-name corresponds to the Kattis problem URL. For example, `solutions/bobby` solves https://open.kattis.com/problems/bobby.

Utility code (like Kattio) is located until `util/`.  This code is re-used between solutions.

# Building
Because every file has to be uploaded to kattis and compiled there, it's usually simpler to avoid toolchains like `gradle` or `cargo` to build and run locally.

## Java
```
javac -d target solutions/<solution>/<file>.java <path-to-any-util>
java -cp target <main class>
```
Use tab-completion for paths and class names!

## Rust
```
rustc /solutions/<solution>/<file>.rs
# Run the resulting binary executable directly
./<file>
```

