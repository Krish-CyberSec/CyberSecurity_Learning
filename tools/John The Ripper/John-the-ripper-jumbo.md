# Cryptography & Hash Cracking with John the Ripper

A practical, memory-friendly guide to hashes, password cracking, hash
identification, and John the Ripper.

> **Learning goal:** Understand not only *which command to type*, but
> also *why it works*. The aim is to build a mental model that remains
> useful long after finishing this guide.

------------------------------------------------------------------------

## 1. The Big Picture

Imagine that a password is a valuable object placed inside a machine.

Instead of storing the password directly, the system runs it through a
special machine called a **hashing algorithm**. The machine produces a
fixed-length fingerprint.

``` text
Original password
       |
       v
Hashing algorithm
       |
       v
Fixed-length hash
```

For example:

``` text
polo
  |
  v
MD5
  |
  v
b53759f3ce692de7aff1b5779d3964da
```

The important idea is:

> A hash is like a fingerprint of data, not an encrypted version of the
> data.

A fingerprint helps identify something, but it does not contain the
original object in a form that can simply be "unlocked."

------------------------------------------------------------------------

## 2. What Is a Hash?

A **hash** is a fixed-length representation of input data.

The input can be:

-   A password
-   A sentence
-   A file
-   An image
-   A database record
-   A complete operating-system password database

The output is called the **hash value**, **digest**, or simply **hash**.

### Example: Same Algorithm, Different Inputs

``` text
Input:  polo
MD5:    b53759f3ce692de7aff1b5779d3964da
```

``` text
Input:  polomints
MD5:    584b6e4f4586e136bc280f27f9c64f3b
```

Both inputs are short, but both produce a 32-character hexadecimal MD5
value.

### Memory Analogy: A Fingerprint Machine

Think of a hash function as a fingerprint machine:

-   A small object goes in.
-   A fixed-size fingerprint comes out.
-   A larger object also produces a fingerprint of the same size.
-   The fingerprint is strongly connected to the input.
-   The fingerprint is not designed to reveal the original input.

A 4-character password and a 40-character password can both produce a
32-character MD5 hash.

### Common Hash Algorithms

  ------------------------------------------------------------------------
  Algorithm                    Typical Output Length Important Note
  --------------------- ---------------------------- ---------------------
  MD4                                       128 bits Old and
                                                     cryptographically
                                                     weak

  MD5                                       128 bits Fast and unsuitable
                                                     for password storage

  SHA-1                                     160 bits Deprecated for
                                                     collision-resistant
                                                     security

  SHA-256                                   256 bits Strong
                                                     general-purpose hash,
                                                     but too fast for
                                                     password storage by
                                                     itself

  NTLM / NT Hash                            128 bits Used in Windows
                                                     password
                                                     authentication
                                                     contexts
  ------------------------------------------------------------------------

> **Important:** A hash algorithm and a password-storage system are not
> the same thing. A fast hash such as SHA-256 may be useful for file
> integrity, but password storage should use a slow, password-specific
> algorithm such as Argon2, bcrypt, scrypt, or PBKDF2.

------------------------------------------------------------------------

## 3. The Main Properties of Hashes

A useful cryptographic hash function usually has these properties.

### 3.1 Deterministic

The same input always produces the same output.

``` text
polo -> b53759f3ce692de7aff1b5779d3964da
polo -> b53759f3ce692de7aff1b5779d3964da
```

This property makes password verification possible.

### 3.2 Fixed-Length Output

The input may be any length, but the output length is fixed for a given
algorithm.

``` text
"hi"       -> fixed-length hash
"hello"    -> fixed-length hash
"very long text..." -> fixed-length hash
```

### 3.3 One-Way Design

It should be easy to calculate:

``` text
input -> hash
```

But difficult to calculate:

``` text
hash -> original input
```

This is why we normally say that hashes are **one-way functions**.

### 3.4 Avalanche Effect

A tiny change in the input should produce a dramatically different
output.

``` text
polo
```

and

``` text
Polo
```

produce completely different hashes.

Changing one character is enough to change the entire digest.

### 3.5 Collision Resistance

A collision happens when two different inputs produce the same hash.

``` text
input A -> same hash
input B -> same hash
```

A secure modern hash function should make it extremely difficult to
deliberately find such a pair.

> MD5 and SHA-1 are no longer considered safe for collision-resistant
> cryptographic applications.

------------------------------------------------------------------------

## 4. Hashing Is Not Encryption

This distinction is essential.

### Encryption

Encryption is designed to be reversible when you have the correct key.

``` text
Plaintext + Key -> Ciphertext
Ciphertext + Key -> Plaintext
```

### Hashing

Hashing is designed to be one-way.

``` text
Input -> Hash
```

There is no normal "decrypt hash" operation.

### Analogy: Lock vs. Meat Grinder

-   **Encryption** is like putting a letter in a locked box. The correct
    key opens it.
-   **Hashing** is like putting the letter through a machine that turns
    it into a fingerprint. You cannot reconstruct the original letter
    from the fingerprint.

When people say they are "unhashing" a password, they usually mean
**guessing the original password and checking whether its hash
matches**.

------------------------------------------------------------------------

## 5. Why Can Hashes Be Cracked?

A hash may be difficult to reverse mathematically, but passwords are
often predictable.

People commonly use passwords such as:

``` text
password
123456
qwerty
welcome
summer2024
companyname123
```

If an attacker knows:

1.  The hash
2.  The hashing algorithm
3.  A likely password list

they can calculate hashes for many guesses and compare them.

``` text
Guess: password
       |
       v
MD5(password)
       |
       v
Does it match the target hash?
```

If the result matches, the guessed password is probably the original
password.

### Analogy: Trying Keys on a Lock

Imagine a lock with millions of possible keys.

You do not need to reverse-engineer the lock. You can simply try likely
keys:

``` text
Key 1 -> Does it open?
Key 2 -> Does it open?
Key 3 -> Does it open?
```

Hash cracking works similarly:

``` text
Guess 1 -> Hash it -> Compare
Guess 2 -> Hash it -> Compare
Guess 3 -> Hash it -> Compare
```

The attacker is not reversing the hash. They are searching for an input
that produces the same output.

------------------------------------------------------------------------

## 6. P, NP, and Why the Practical Explanation Matters

Hashing is often described as easy to calculate in the forward direction
and difficult to reverse.

For example:

``` text
password -> hash
```

is computationally straightforward.

However:

``` text
hash -> password
```

does not have a practical general-purpose reverse operation.

### A Careful Clarification

It is common to explain this using P and NP, but password cracking
should not be understood as simply:

> "Hashing is P, therefore unhashing is NP."

That is an oversimplification.

In practice, cracking usually works because:

-   Passwords are chosen from a limited human-generated space.
-   Many users reuse passwords.
-   Common words and patterns are predictable.
-   Attackers can test guesses quickly.
-   Weak algorithms are extremely fast.
-   Leaked password lists provide highly probable guesses.

The real problem is often not reversing the mathematics. It is searching
a space of likely passwords.

------------------------------------------------------------------------

## 7. Dictionary Attacks

A **dictionary attack** uses a list of possible passwords.

The list may contain:

-   Common passwords
-   Words
-   Names
-   Sports teams
-   Keyboard patterns
-   Previously leaked passwords
-   Organization-specific terms

Example:

``` text
password
123456
qwerty
letmein
football
sunshine
```

The attacker hashes each entry and compares it to the target.

``` text
Wordlist
   |
   v
Hash each word
   |
   v
Compare with target hash
   |
   v
Matching word = recovered password
```

### Why Dictionary Attacks Work

Humans are predictable.

A password may look complex but still follow a common pattern:

``` text
Summer2024!
CompanyName123
John1998
Password@
```

A good wordlist may already contain the base word, and cracking rules
can generate common variations.

------------------------------------------------------------------------

## 8. Brute Force vs. Dictionary Attack

### Dictionary Attack

Uses likely words and known password patterns.

``` text
password
football
dragon
summer2024
```

### Brute Force Attack

Tries every possible combination within a defined character set.

For example, a brute-force search for a 3-character lowercase password
might try:

``` text
aaa
aab
aac
...
zzz
```

### Analogy: Searching a Library

-   **Dictionary attack:** Check the most likely books first.
-   **Brute force:** Check every book in the library, even the unlikely
    ones.

Dictionary attacks are usually much faster against human-created
passwords.

------------------------------------------------------------------------

## 9. John the Ripper

**John the Ripper**, commonly called **John**, is a password-cracking
tool.

It can:

-   Test password guesses against hashes
-   Use wordlists
-   Apply password-mangling rules
-   Identify or work with many hash formats
-   Crack password hashes from several operating systems and
    applications
-   Process password-protected archives when the correct hash extraction
    tool is used

The **Jumbo** version includes many additional formats and utilities.

### Mental Model

Think of John as a highly optimized guessing engine:

``` text
Target hash
    +
Candidate passwords
    +
Hash algorithm
    |
    v
John compares the results
    |
    v
Recovered password, if found
```

John does not magically decrypt passwords. It automates the process of
generating, hashing, and comparing guesses.

------------------------------------------------------------------------

## 10. Installing or Checking John

On many security-focused Linux distributions, John is already installed.

Check it with:

``` bash
john
```

You should see usage information and a version string.

A Jumbo installation may display something similar to:

``` text
John the Ripper 1.9.0-jumbo-1
```

The exact version may differ.

### Linux Installation

On Ubuntu:

``` bash
sudo apt install john
```

On Fedora:

``` bash
sudo dnf install john
```

Distribution packages may provide the core version rather than every
Jumbo feature.

For advanced functionality, consult the official John the Ripper build
instructions.

### Windows

On Windows, use the appropriate official Jumbo binary for your system
architecture.

After extracting it, open a terminal in the John directory and run:

``` bash
john
```

> Only download security tools from trusted official sources or
> well-known project repositories.

------------------------------------------------------------------------

## 11. Wordlists

A **wordlist** is simply a file containing candidate passwords, usually
one per line.

Example:

``` text
password
123456
admin
welcome
football
```

Wordlists are the fuel for dictionary attacks.

### Common Locations

On Kali Linux and similar distributions:

``` bash
/usr/share/wordlists/
```

A popular password list is:

``` text
rockyou.txt
```

### RockYou

`rockyou.txt` is a widely used password wordlist created from a
historical data breach. It contains many commonly used passwords.

It is useful for learning because it represents real-world password
choices rather than randomly generated strings.

### Finding the File

``` bash
find /usr/share/wordlists -name "rockyou*"
```

If the file is compressed, it may need to be extracted first.

For a `.tar.gz` archive:

``` bash
tar xvzf rockyou.txt.tar.gz
```

### Wordlist Analogy

A wordlist is like a suspect list in an investigation.

Instead of questioning every person on Earth, you start with the people
most likely to know the answer.

------------------------------------------------------------------------

## 12. John Basic Syntax

The general syntax is:

``` bash
john [options] [file]
```

### Components

  Component     Meaning
  ------------- -------------------------------------------
  `john`        Starts John the Ripper
  `[options]`   Controls the cracking method
  `[file]`      Contains the target hash or password data

Example:

``` bash
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

This tells John to:

1.  Read the target hashes from `hashes.txt`.
2.  Read candidate passwords from `rockyou.txt`.
3.  Hash each candidate.
4.  Compare the results.
5.  Report any recovered passwords.

------------------------------------------------------------------------

## 13. Automatic Cracking

John can attempt to detect the hash format automatically.

``` bash
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

This is convenient when the format is unknown.

However, automatic detection is not always reliable because:

-   Several hash formats can look similar.
-   Some hashes have the same length.
-   A hash may be ambiguous without additional context.
-   John may choose an incorrect format.

### Best Practice

Use automatic detection as a first attempt, but identify the hash
manually when accuracy matters.

------------------------------------------------------------------------

## 14. Identifying Hash Types

A hash string alone may not uniquely identify its algorithm.

For example, a 32-character hexadecimal string could be:

-   MD5
-   NTLM
-   Another 128-bit hexadecimal format
-   A custom application hash

### Hash Identifier

A hash-identification tool can suggest likely formats.

Example:

``` bash
python3 hash-id.py
```

Then enter the hash.

Example input:

``` text
2e728dd31fb5949bc39cac5a9f066498
```

A tool may suggest:

``` text
MD5
Domain Cached Credentials
```

### Important Limitation

Hash identification is based on patterns and heuristics.

A tool saying "MD5" does not prove that the hash is MD5.

### Analogy: Identifying a Language

If you see a sentence written in a particular alphabet, you can make an
educated guess about the language. But the alphabet alone may not be
enough to prove it.

Hash identification works similarly.

------------------------------------------------------------------------

## 15. John Format-Specific Cracking

When the hash type is known, specify it explicitly.

``` bash
john --format=raw-md5 \
     --wordlist=/usr/share/wordlists/rockyou.txt \
     hashes.txt
```

### Meaning of `--format`

``` bash
--format=raw-md5
```

This tells John:

> Treat the input as a raw MD5 hash.

For many standard hash types, John uses a `raw-` prefix.

Examples:

``` bash
--format=raw-md5
--format=raw-sha1
--format=raw-sha256
```

The exact format name depends on John's supported formats.

### List Available Formats

``` bash
john --list=formats
```

Search for a particular format:

``` bash
john --list=formats | grep -iF "md5"
```

### Why Explicit Formats Are Better

Specifying the format:

-   Reduces ambiguity
-   Avoids incorrect automatic detection
-   Can improve performance
-   Makes your command reproducible
-   Helps you understand exactly what is being tested

------------------------------------------------------------------------

## 16. The Difference Between MD5 and NTLM

Both MD5 and NTLM commonly appear as 32 hexadecimal characters.

That does not mean they are interchangeable.

### MD5

``` text
MD5(password)
```

### NTLM

NTLM password hashes are based on the MD4 hash of the password encoded
in UTF-16LE.

Conceptually:

``` text
Password
   |
   v
UTF-16LE encoding
   |
   v
MD4
   |
   v
NT Hash / NTLM hash
```

### Key Lesson

The same-looking string can represent different algorithms.

Always consider:

-   Where the hash came from
-   The operating system or application
-   The expected format
-   Whether the hash includes a salt
-   Whether the hash is part of a larger authentication structure

------------------------------------------------------------------------

## 17. Windows Password Hashes: NT Hash / NTLM

Windows stores password-related information in structures such as the
**Security Account Manager (SAM)** database.

The NT hash is commonly associated with Windows password authentication.

### SAM

The SAM database contains local account information, including password
hashes.

Access to these hashes generally requires appropriate privileges.

### NTDS.dit

In an Active Directory environment, domain password hashes may be stored
in:

``` text
NTDS.dit
```

This is the Active Directory database.

### Important Security Context

Obtaining password hashes from a system is a privileged operation. In
legitimate security testing, it should only be performed on systems
where you have explicit authorization.

### Pass-the-Hash

Sometimes an attacker does not need to recover the original password.

Instead, they may use the hash directly in a technique known as
**pass-the-hash**.

This demonstrates an important point:

> A password hash can be valuable even when it has not been cracked.

### Cracking an NTLM Hash

If the hash is known to be NTLM, specify the appropriate format:

``` bash
john --format=nt \
     --wordlist=/usr/share/wordlists/rockyou.txt \
     ntlm.txt
```

The exact format name can vary by John version, so verify it with:

``` bash
john --list=formats | grep -iF "nt"
```

------------------------------------------------------------------------

## 18. Linux Password Hashes: `/etc/passwd` and `/etc/shadow`

Linux systems commonly separate account information from password
hashes.

### `/etc/passwd`

This file contains account information such as:

-   Username
-   User ID
-   Group ID
-   Home directory
-   Login shell

Example:

``` text
root:x:0:0::/root:/bin/bash
```

The `x` usually indicates that the password hash is stored elsewhere.

### `/etc/shadow`

This file stores password hashes and password-aging information.

Example:

``` text
root:$6$2nwjN454g.dv4HN/$m9Z/r2xVfweYVkrr.v5Ft8Ws3/YYksfNwq96UL1FX0OJjY1L6l.DS3KEVsZ9rOVLB/ldTeEL/OIhJZ4GMFMGA0:18576::::::
```

The password field begins with:

``` text
$6$
```

This commonly indicates SHA-512 crypt.

### Why `/etc/shadow` Is Protected

Password hashes are sensitive. If an attacker obtains them, they can
attempt offline cracking without repeatedly interacting with the login
service.

------------------------------------------------------------------------

## 19. Understanding Linux Shadow Format

A typical shadow entry looks like:

``` text
username:password_hash:last_change:min:max:warn:inactive:expire:reserved
```

For example:

``` text
root:$6$salt$hash:18576::::::
```

The important part is:

``` text
$6$salt$hash
```

This includes:

-   Algorithm identifier
-   Salt
-   Password hash

### Salt

A salt is a random value added to the password before hashing.

Conceptually:

``` text
Password + Salt
       |
       v
Hashing algorithm
       |
       v
Password hash
```

### Why Salts Matter

Without salts, two users with the same password would normally have the
same hash.

With unique salts:

``` text
User A: password + saltA -> hashA
User B: password + saltB -> hashB
```

Salts make precomputed lookup tables much less useful.

------------------------------------------------------------------------

## 20. Unshadowing

John expects password data in a particular format.

To crack Linux shadow hashes, combine the relevant `/etc/passwd` and
`/etc/shadow` data using:

``` bash
unshadow local_passwd local_shadow > unshadowed.txt
```

### What This Does

``` text
/etc/passwd
     +
 /etc/shadow
     |
     v
unshadow
     |
     v
unshadowed.txt
```

The resulting file contains the account information and password hash in
a format John can process.

### Example Input

`local_passwd`:

``` text
root:x:0:0::/root:/bin/bash
```

`local_shadow`:

``` text
root:$6$2nwjN454g.dv4HN/$m9Z/r2xVfweYVkrr.v5Ft8Ws3/YYksfNwq96UL1FX0OJjY1L6l.DS3KEVsZ9rOVLB/ldTeEL/OIhJZ4GMFMGA0:18576::::::
```

Command:

``` bash
unshadow local_passwd local_shadow > unshadowed.txt
```

### Why Two Files?

Think of it like joining two halves of a record:

-   `/etc/passwd` tells John who the account belongs to.
-   `/etc/shadow` tells John the password hash and related password
    data.

------------------------------------------------------------------------

## 21. Cracking a Shadow Hash

After unshadowing, run John:

``` bash
john --wordlist=/usr/share/wordlists/rockyou.txt \
     unshadowed.txt
```

If necessary, specify the format:

``` bash
john --wordlist=/usr/share/wordlists/rockyou.txt \
     --format=sha512crypt \
     unshadowed.txt
```

### Format Prefixes in Shadow Hashes

The `$6$` identifier commonly represents SHA-512 crypt.

Other common identifiers include:

  Prefix   Common Meaning
  -------- ----------------
  `$1$`    MD5 crypt
  `$5$`    SHA-256 crypt
  `$6$`    SHA-512 crypt
  `$2b$`   bcrypt

The exact supported formats should be checked against the installed John
version.

------------------------------------------------------------------------

## 22. Single Crack Mode

John has a mode called **Single Crack mode**.

Instead of relying only on a large external wordlist, it uses
information associated with the username and account.

Example username:

``` text
Markus
```

Possible password guesses:

``` text
Markus
Markus1
Markus2
markus
MArkus
MARKUS
Markus!
Markus123
```

### Why This Works

People often create passwords using:

-   Their name
-   Their username
-   Their birthday
-   Their company
-   Their pet's name
-   A familiar word plus a number or symbol

Single Crack mode tries to exploit these habits.

------------------------------------------------------------------------

## 23. Word Mangling

**Word mangling** means transforming a base word into multiple likely
password variations.

Starting word:

``` text
markus
```

Possible mutations:

``` text
Markus
MARKUS
Markus1
Markus123
markus!
Markus@
Markus2024
```

### Common Mangling Operations

-   Change capitalization
-   Add numbers
-   Add symbols
-   Reverse the word
-   Duplicate characters
-   Add prefixes or suffixes
-   Replace letters with numbers
-   Combine words

### Analogy: A Word Blender

Imagine putting the word `markus` into a blender that follows rules:

``` text
markus
  |
  +--> Markus
  +--> MARKUS
  +--> Markus1
  +--> markus!
  +--> Markus123
```

The blender does not generate every possible password. It generates
passwords that are likely to be used by a human.

------------------------------------------------------------------------

## 24. GECOS Information

On Unix-like systems, the **GECOS** field stores general account
information.

A typical `/etc/passwd` entry looks like:

``` text
username:x:UID:GID:GECOS:home:shell
```

The fifth field is the GECOS field.

It may contain:

-   Full name
-   Office information
-   Telephone information
-   Other account details

Example:

``` text
mike:x:1000:1000:Mike Smith:/home/mike:/bin/bash
```

John can use information such as:

``` text
Mike
Smith
MikeSmith
mike
```

to generate likely password candidates.

### Security Lesson

Personal information is often a poor password ingredient because it is
predictable and may be publicly available.

------------------------------------------------------------------------

## 25. Using Single Crack Mode

The general syntax is:

``` bash
john --single --format=[format] hashes.txt
```

Example:

``` bash
john --single --format=raw-sha256 hashes.txt
```

### Required File Format

For Single Crack mode, John needs the username associated with the hash.

Instead of:

``` text
1efee03cdcb96d90ad48ccc7b8666033
```

use:

``` text
mike:1efee03cdcb96d90ad48ccc7b8666033
```

### Why Add the Username?

John uses the username as a source of password ideas.

``` text
mike
  |
  v
mike1
Mike
mike123
M1ke
```

Without the username, John loses an important source of contextual
information.

------------------------------------------------------------------------

## 26. Showing Cracked Passwords

After John finishes or pauses, display recovered passwords with:

``` bash
john --show hashes.txt
```

For a specific format:

``` bash
john --show --format=raw-md5 hashes.txt
```

This is useful because John may save cracked passwords in its pot file
and avoid repeating work.

### Mental Model

Think of John's pot file as a notebook:

``` text
Hash -> Recovered password
```

Once a password has been recovered, John can remember it.

------------------------------------------------------------------------

## 27. Restoring an Interrupted Session

If a cracking session is interrupted, John can often resume it.

Start a session with a name:

``` bash
john --session=mycrack \
     --wordlist=/usr/share/wordlists/rockyou.txt \
     hashes.txt
```

Restore it with:

``` bash
john --restore=mycrack
```

### Why Sessions Matter

Large cracking jobs may take a long time. A named session helps you
continue without starting from the beginning.

------------------------------------------------------------------------

## 28. Common Mistakes

### Mistake 1: Treating a Hash as Encryption

Incorrect idea:

``` text
hash -> decrypt -> password
```

Correct idea:

``` text
candidate password -> hash -> compare
```

### Mistake 2: Assuming Hash Length Proves the Algorithm

A 32-character hexadecimal string is not automatically MD5.

Always consider the context.

### Mistake 3: Using the Wrong Format

A correct hash with the wrong John format will usually fail.

Check:

``` bash
john --list=formats
```

### Mistake 4: Forgetting to Unshadow

For Linux shadow hashes, combine the passwd and shadow files first:

``` bash
unshadow local_passwd local_shadow > unshadowed.txt
```

### Mistake 5: Using an Incomplete Wordlist

A password may not exist in the wordlist.

Failure to crack a hash does not prove that the password is strong.

### Mistake 6: Ignoring Password Context

A username such as `mike` may make these guesses more likely:

``` text
Mike
mike1
Mike123
mike!
```

### Mistake 7: Confusing NTLM with MD5

Both may look like 32 hexadecimal characters, but they are different
formats.

### Mistake 8: Forgetting That Cracking Can Be Resource-Intensive

Cracking speed depends on:

-   Algorithm
-   Hardware
-   Wordlist size
-   Password complexity
-   Hash format
-   Rules
-   Number of guesses

------------------------------------------------------------------------

## 29. A Complete Mental Workflow

When you encounter a password hash, follow this sequence.

### Step 1: Understand the Source

Ask:

``` text
Where did this hash come from?
```

Possibilities include:

-   Linux shadow file
-   Windows SAM
-   Active Directory database
-   Application database
-   A file checksum
-   A challenge or lab file

### Step 2: Identify the Likely Format

Use:

-   Context
-   Hash prefixes
-   Hash length
-   Hash-identification tools
-   John's supported formats

### Step 3: Choose a Strategy

Start with:

-   A dictionary attack
-   A relevant wordlist
-   A format-specific command

If appropriate, try:

-   Single Crack mode
-   Mangling rules
-   Brute force
-   Mask-based attacks

### Step 4: Run John

Example:

``` bash
john --format=raw-md5 \
     --wordlist=/usr/share/wordlists/rockyou.txt \
     hashes.txt
```

### Step 5: Display Results

``` bash
john --show hashes.txt
```

### Step 6: Interpret Failure Correctly

If John fails:

-   The format may be wrong.
-   The wordlist may be incomplete.
-   The password may be too complex.
-   The hash may not be crackable with the chosen strategy.
-   The hash may not be what you thought it was.

------------------------------------------------------------------------

## 30. A Compact Command Reference

### Start John

``` bash
john
```

### Dictionary Attack

``` bash
john --wordlist=/path/to/wordlist.txt hashes.txt
```

### Specify a Format

``` bash
john --format=raw-md5 \
     --wordlist=/path/to/wordlist.txt \
     hashes.txt
```

### List Formats

``` bash
john --list=formats
```

### Search Formats

``` bash
john --list=formats | grep -iF "md5"
```

### Show Cracked Passwords

``` bash
john --show hashes.txt
```

### Single Crack Mode

``` bash
john --single --format=raw-sha256 hashes.txt
```

### Unshadow Linux Password Files

``` bash
unshadow local_passwd local_shadow > unshadowed.txt
```

### Crack Unshadowed Data

``` bash
john --wordlist=/usr/share/wordlists/rockyou.txt unshadowed.txt
```

### Start a Named Session

``` bash
john --session=mycrack \
     --wordlist=/path/to/wordlist.txt \
     hashes.txt
```

### Restore a Session

``` bash
john --restore=mycrack
```

------------------------------------------------------------------------

## 31. Long-Term Memory Cheatsheet

Remember these five ideas:

### 1. Hashes Are Fingerprints

``` text
Input -> Fixed-length fingerprint
```

### 2. Hashing Is Not Encryption

``` text
Encryption -> Reversible with a key
Hashing -> Designed to be one-way
```

### 3. Cracking Means Guessing

``` text
Guess -> Hash -> Compare
```

### 4. Context Identifies the Format

``` text
Linux shadow -> crypt formats
Windows password hash -> NTLM
Raw 32-character hash -> Could be MD5, NTLM, or something else
```

### 5. John Automates the Search

``` text
John + Wordlist + Correct Format -> Possible Password
```

------------------------------------------------------------------------

## 32. Final Takeaway

The most important concept is this:

> **You do not crack a hash by reversing it. You crack it by finding an
> input that produces the same hash.**

John the Ripper makes this process efficient by combining:

-   Hash-format support
-   Wordlists
-   Password-mangling rules
-   Optimized guessing
-   Session management
-   Result storage

If you remember the following chain, you will understand most beginner
hash-cracking tasks:

``` text
Identify the hash
       |
       v
Choose the correct format
       |
       v
Choose a wordlist or cracking strategy
       |
       v
Generate password guesses
       |
       v
Hash each guess
       |
       v
Compare with the target
       |
       v
Recover the password if a match is found
```

> Use these techniques only on systems, accounts, and data for which you
> have explicit authorization.
