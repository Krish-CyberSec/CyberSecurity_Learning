# John the Ripper: Custom Rules & Archive Password Cracking

John the Ripper (often called **John**) is a password-cracking tool that can test large numbers of candidate passwords against password hashes and other supported password-protected formats.

This guide focuses on two useful areas:

1. **Custom rules** — creating predictable variations of words from a wordlist.
2. **Password-protected ZIP/RAR archives** — extracting crackable hash data and testing candidates with John.

> **Important:** Use these techniques only on systems, files, and accounts you own or have explicit permission to test.

---

## Table of Contents

- [1. The Big Idea](#1-the-big-idea)
- [2. Why Custom Rules Matter](#2-why-custom-rules-matter)
- [3. Understanding John Rules](#3-understanding-john-rules)
- [4. Common Rule Commands](#4-common-rule-commands)
- [5. Character Sets](#5-character-sets)
- [6. Building a Custom Rule Step by Step](#6-building-a-custom-rule-step-by-step)
- [7. Using a Custom Rule](#7-using-a-custom-rule)
- [8. Debugging and Testing Rules](#8-debugging-and-testing-rules)
- [9. ZIP Archives](#9-zip-archives)
- [10. RAR Archives](#10-rar-archives)
- [11. A Complete Workflow](#11-a-complete-workflow)
- [12. Common Mistakes](#12-common-mistakes)
- [13. Quick Reference](#13-quick-reference)
- [14. Key Takeaways](#14-key-takeaways)

---

# 1. The Big Idea

Imagine you have a dictionary containing:

```text
password
football
monkey
dragon
sunshine
```

A normal dictionary attack tests those exact words.

But people rarely create passwords by simply choosing one dictionary word. Instead, they modify familiar words:

```text
Password1!
Football123!
Monkey2026!
Sunshine@
```

The important observation is that these modifications are often **predictable**.

A custom rule tells John:

> "Take every word from my wordlist and transform it according to this pattern."

So instead of manually creating:

```text
Password0!
Password1!
Password2!
...
Password9!
```

you can describe the pattern once and let John generate the candidates.

### Analogy: A word-processing machine

Think of your wordlist as a box of plain T-shirts:

```text
shirt
hoodie
jacket
```

A custom rule is like a machine with instructions:

1. Capitalize the first letter.
2. Add a number.
3. Add a symbol.

The machine turns:

```text
shirt
```

into candidates such as:

```text
Shirt0!
Shirt0@
Shirt1!
Shirt1@
...
```

The same process is applied to the other words.

---

# 2. Why Custom Rules Matter

## Dictionary attacks vs. rule-based attacks

A dictionary attack might test:

```text
password
football
monkey
```

A rule-based attack can turn those into many likely human-created variations:

```text
Password1!
Football1!
Monkey1!

Password2!
Football2!
Monkey2!

Password3!
Football3!
Monkey3!
```

This can be much more effective when you have reason to believe passwords follow a particular pattern.

### Password complexity does not necessarily mean unpredictability

A password policy might require:

- at least one lowercase character
- at least one uppercase character
- at least one number
- at least one symbol

That may encourage patterns such as:

```text
Password1!
Football123!
Welcome1@
```

These passwords technically satisfy the requirements, but the locations of the added characters can be predictable.

From a security-testing perspective, **knowing the likely structure can dramatically reduce the search space**.

---

# 3. Understanding John Rules

Custom rules are defined in John's configuration file, commonly named:

```text
john.conf
```

Depending on how John was installed, its location can differ. Common locations include:

```text
/etc/john/john.conf
```

or a configuration file inside John's installation directory.

Always check your installation rather than assuming one path.

---

## 3.1 Naming a rule

A custom rule section looks like:

```text
[List.Rules:PoloPassword]
```

The part after the colon is the rule's name:

```text
PoloPassword
```

You later refer to that name when asking John to use the rule.

Think of this like naming a recipe:

```text
Recipe: ChocolateCake
```

The recipe contains the instructions, and `ChocolateCake` is how you refer to it.

---

# 4. Common Rule Commands

John has a large rule language with many operations. This guide concentrates on the operations useful for understanding basic password transformations.

## `c` — Capitalize

```text
c
```

Capitalizes the first character of the word.

Example:

```text
password
```

becomes:

```text
Password
```

---

## `Az` — Append characters

```text
Az
```

`A` means "insert/append characters" and `z` specifies the end position.

For example, a rule containing:

```text
Az"[0-9]"
```

can append a digit to the candidate.

Conceptually:

```text
password
   ↓
password0
password1
password2
...
password9
```

---

## `A0` — Prepend characters

```text
A0
```

This is used to add characters at the beginning.

Conceptually:

```text
password
   ↓
0password
1password
2password
...
9password
```

---

# 5. Character Sets

Character sets tell John which characters it should try.

They are written inside square brackets:

```text
[ ]
```

For example:

```text
[0-9]
```

means:

> Try the digits from 0 through 9.

---

## 5.1 Numbers

```text
[0-9]
```

Represents:

```text
0 1 2 3 4 5 6 7 8 9
```

---

## 5.2 A single number

```text
[0]
```

Represents only:

```text
0
```

This is useful when you deliberately want exactly one fixed character.

---

## 5.3 Uppercase letters

```text
[A-Z]
```

Represents uppercase letters:

```text
A B C ... Z
```

---

## 5.4 Lowercase letters

```text
[a-z]
```

Represents lowercase letters:

```text
a b c ... z
```

---

## 5.5 A custom collection

You can explicitly list characters:

```text
[!£$%@]
```

This means John can choose from:

```text
!
£
$
%
@
```

This is different from a range. You are explicitly specifying the characters you want.

---

# 6. Building a Custom Rule Step by Step

Suppose our starting word is:

```text
polopassword
```

We want to model passwords following this structure:

```text
Polopassword1!
```

Break the desired transformation into small steps.

### Step 1 — Capitalize the first letter

Starting word:

```text
polopassword
```

After:

```text
c
```

we conceptually get:

```text
Polopassword
```

### Step 2 — Add a number

We want:

```text
Polopassword1
```

So we append a digit.

Conceptually:

```text
Az"[0-9]"
```

### Step 3 — Add a symbol

We then want something like:

```text
Polopassword1!
```

We can include a symbol character set such as:

```text
[!£$%@]
```

The exact rule syntax depends on the rule language's quoting and operation structure, so it is a good habit to validate the rule against a small test wordlist before launching a long cracking job.

---

## The important mental model

Don't try to memorize a complicated rule as one giant string.

Instead, read it like instructions:

```text
c
```

> Capitalize.

```text
Az
```

> Add something at the end.

```text
[0-9]
```

> Choose a digit.

```text
[!£$%@]
```

> Choose one of these symbols.

### Analogy: LEGO blocks

A John rule is easier to understand if you think of each operation as a LEGO block.

```text
[capitalize] + [append number] + [append symbol]
```

You combine the blocks to create a password-generation pattern.

---

# 7. Using a Custom Rule

Once the rule is defined, you can tell John to use it with:

```bash
john --wordlist=/path/to/wordlist.txt --rule=PoloPassword /path/to/hashfile
```

The important pieces are:

```text
john
```

Start John.

```text
--wordlist=/path/to/wordlist.txt
```

Use the specified wordlist as the source of base words.

```text
--rule=PoloPassword
```

Apply the custom rule named `PoloPassword`.

```text
/path/to/hashfile
```

Provide the password hash file that John should test.

---

## Example

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt --rule=PoloPassword hashes.txt
```

The exact wordlist and hash file should match your authorized lab environment.

---

# 8. Debugging and Testing Rules

Custom rules can become confusing quickly.

A useful approach is to **test the transformation before performing a full cracking run**.

For example, start with a tiny wordlist:

```text
password
football
monkey
```

Then inspect what your rule generates.

This lets you answer questions such as:

- Did the capitalization happen?
- Was the number appended?
- Was the symbol appended?
- Did the rule generate more candidates than expected?
- Did I accidentally create an enormous search space?

### Why this matters

Suppose you have:

```text
10 possible digits
```

and:

```text
5 possible symbols
```

Then just those two positions can create:

```text
10 × 5 = 50
```

variations for **each base word**.

If your wordlist has 100,000 words:

```text
100,000 × 50 = 5,000,000
```

candidate passwords.

That's why understanding the search space is important.

---

# 9. ZIP Archives

John can work with password-protected ZIP archives by first converting information from the archive into a format John understands.

The helper program commonly used for this is:

```text
zip2john
```

Think of `zip2john` as a **translator**.

### Analogy: Translator

A ZIP archive speaks:

```text
ZIP format
```

John expects:

```text
John-readable hash information
```

`zip2john` translates the relevant information between the two.

---

## 9.1 Extract ZIP hash information

Basic syntax:

```bash
zip2john [zip-file] > [output-file]
```

For example:

```bash
zip2john archive.zip > zip_hash.txt
```

The `>` is shell output redirection.

It means:

> Take the output produced by `zip2john` and save it into this file.

So:

```text
archive.zip
     ↓
 zip2john
     ↓
zip_hash.txt
```

---

## 9.2 Run John

Once the hash information has been extracted:

```bash
john --wordlist=/path/to/wordlist.txt zip_hash.txt
```

John can then test candidates against the extracted ZIP password-verification data.

---

## 9.3 Why don't we give the ZIP directly to John?

Because different file formats store password-verification information differently.

The conversion step creates a representation John knows how to process.

The overall workflow is therefore:

```text
Password-protected ZIP
        ↓
     zip2john
        ↓
  John-readable data
        ↓
      John
        ↓
 Candidate testing
```

---

# 10. RAR Archives

RAR archives work in a very similar way.

The helper program is:

```text
rar2john
```

It extracts the relevant password-verification information from a RAR archive so John can work with it.

---

## 10.1 Extract RAR hash information

Basic syntax:

```bash
rar2john [rar-file] > [output-file]
```

Example:

```bash
rar2john archive.rar > rar_hash.txt
```

Some installations may place `rar2john` in a John-specific directory, so the command may look like:

```bash
/opt/john/rar2john archive.rar > rar_hash.txt
```

Use the path appropriate to your installation.

---

## 10.2 Run John

Once the data has been extracted:

```bash
john --wordlist=/path/to/wordlist.txt rar_hash.txt
```

The process is:

```text
Password-protected RAR
        ↓
     rar2john
        ↓
  John-readable data
        ↓
      John
        ↓
 Candidate testing
```

---

# 11. A Complete Workflow

Let's put everything together.

Suppose you have an authorized password-protected archive and believe the password is based on words from a known wordlist.

## Step 1 — Start with a wordlist

```text
password
football
monkey
sunshine
dragon
```

---

## Step 2 — Decide on a pattern

Suppose your testing hypothesis is:

```text
Capitalized word + one digit + one symbol
```

Examples:

```text
Password1!
Football7@
Monkey3$
```

This is a **hypothesis**, not a guarantee.

---

## Step 3 — Create a John rule

Define a rule with a descriptive name, for example:

```text
[List.Rules:MyPattern]
```

Then define the transformations according to John's rule syntax.

Keep the rule as simple as possible initially.

---

## Step 4 — Test the rule

Use a small wordlist first.

Confirm that the generated candidates actually look like:

```text
Password1!
Password1@
Password2!
...
```

rather than accidentally generating something completely different.

---

## Step 5 — Convert the archive

For ZIP:

```bash
zip2john archive.zip > zip_hash.txt
```

For RAR:

```bash
rar2john archive.rar > rar_hash.txt
```

---

## Step 6 — Run John

With a standard wordlist:

```bash
john --wordlist=/path/to/wordlist.txt zip_hash.txt
```

or:

```bash
john --wordlist=/path/to/wordlist.txt rar_hash.txt
```

With a custom rule:

```bash
john --wordlist=/path/to/wordlist.txt --rule=MyPattern zip_hash.txt
```

or:

```bash
john --wordlist=/path/to/wordlist.txt --rule=MyPattern rar_hash.txt
```

---

# 12. Common Mistakes

## Mistake 1 — Treating rules like regular expressions

John's rule language may look somewhat like other pattern languages, but it is **not simply regex**.

Don't assume regex syntax will work directly.

Instead, learn each John rule operation and how it combines with character sets.

---

## Mistake 2 — Forgetting that every variation multiplies the workload

Suppose you have:

```text
100,000 words
```

and your rule produces:

```text
10 digits × 5 symbols
```

That's:

```text
100,000 × 10 × 5
= 5,000,000
```

candidates.

Adding another variable can increase this dramatically.

---

## Mistake 3 — Using huge character sets without thinking

For example, if a position can contain:

```text
A-Z
a-z
0-9
20 symbols
```

you already have a very large number of possibilities.

A targeted rule based on a realistic hypothesis is often much more useful than blindly generating everything.

---

## Mistake 4 — Not testing the rule

A typo in a custom rule can waste a lot of time.

Always validate your rule using a tiny wordlist before using it against a large dataset.

---

## Mistake 5 — Assuming a password must follow your pattern

Custom rules are based on assumptions.

For example:

```text
Word + number + symbol
```

may be common, but it is not universal.

A failed rule does **not** prove that the password is strong or that the underlying word is absent from the wordlist.

It simply means that particular hypothesis did not succeed.

---

# 13. Quick Reference

## Rule definition

```text
[List.Rules:RuleName]
```

Defines a named custom rule.

---

## Capitalization

```text
c
```

Capitalizes the first character.

---

## Append

```text
Az
```

Used to append characters.

---

## Prepend

```text
A0
```

Used to prepend characters.

---

## Character ranges

| Pattern | Meaning |
|---|---|
| `[0-9]` | digits 0–9 |
| `[A-Z]` | uppercase A–Z |
| `[a-z]` | lowercase a–z |
| `[0]` | only `0` |
| `[a]` | only `a` |
| `[!£$%@]` | one of the listed symbols |

---

## Run a named rule

```bash
john --wordlist=/path/to/wordlist.txt --rule=RuleName /path/to/hashfile
```

---

## ZIP

Extract:

```bash
zip2john archive.zip > zip_hash.txt
```

Crack/test:

```bash
john --wordlist=/path/to/wordlist.txt zip_hash.txt
```

---

## RAR

Extract:

```bash
rar2john archive.rar > rar_hash.txt
```

Crack/test:

```bash
john --wordlist=/path/to/wordlist.txt rar_hash.txt
```

---

# 14. Key Takeaways

### 1. Wordlists provide the raw material

A wordlist gives John base words:

```text
password
football
monkey
```

### 2. Rules transform the raw material

A rule can turn those into structured candidates:

```text
Password1!
Football1!
Monkey1!
```

### 3. Character sets define choices

For example:

```text
[0-9]
```

means:

> Try each digit.

And:

```text
[!£$%@]
```

means:

> Try each listed symbol.

### 4. Custom rules exploit predictable password construction

People often modify memorable words using familiar patterns.

Understanding those patterns allows security testers to build targeted candidate-generation strategies.

### 5. ZIP and RAR require a conversion step

Use:

```text
zip2john
```

for ZIP files and:

```text
rar2john
```

for RAR files.

The helper tools convert archive information into a form John can process.

### 6. Think in hypotheses, not magic commands

The most important skill is not memorizing commands.

It is learning to think:

```text
What is my base word?
        ↓
What transformation is likely?
        ↓
How many candidates will that create?
        ↓
Can I test the rule on a small sample?
        ↓
Is the hypothesis worth running?
```

That's the real power of custom rules: **you replace blind guessing with structured, hypothesis-driven candidate generation.**

---

## Further Learning

John the Ripper's rule language contains many more operations than the small set covered here. Once the basic model makes sense, study the official rule documentation and experiment with rules in an isolated, authorized lab environment.

The key progression is:

```text
Wordlist
   ↓
Understand password patterns
   ↓
Create transformation
   ↓
Estimate search space
   ↓
Test rule
   ↓
Run against authorized hash/archive data
```

That workflow will make John's rule system much easier to understand than trying to memorize every modifier at once.
