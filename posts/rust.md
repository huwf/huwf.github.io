<!--
.. title: Rust
.. slug: rust
.. tags: rust
.. date: 2025-02-09 20:01:52 UTC+02:00
.. category: 
.. link: 
.. description: 
.. type: text
.. path: /posts/python/django
-->

I'm trying to learn rust. 
Here are summaries of some of the useful bits I've found.
Typically, the snippets are taken from [The Rust book](https://doc.rust-lang.org/book/),
or modified for my purposes where appropriate

## Interesting language stuff

With Python we can do `range(10)`  to get a generator of 0-9.
In rust, we can do similar with `..`

Note that we can specify whether to inclue the RHS or not with `..=`

```rust
    match hour_of_day {
        // 0-21
        0..22 => Some(5),
        // 22-23
        22..=23 => Some(0),
        _ => None,
    }
```


## Ownership and borrowing

This is difficult to get a handle on, here are some notes about it.
In particular, here is a chat with copilot concerning an exercise in rustlings.
The code was as follows:

```rust

#[cfg(test)]
mod tests {
    // TODO: Fix the compiler errors only by reordering the lines in the test.
    // Don't add, change or remove any line.
    #[test]
    fn move_semantics4() {
        let mut x = Vec::new();
        let y = &mut x;
        // `y` used here.
        y.push(42);
        // The mutable reference `y` is not used anymore,
        // therefore a new reference can be created.
        let z = &mut x;
        z.push(13);
        assert_eq!(x, [42, 13]);
    }
}


```

Answer from GitHub copilot:

In Rust, the scope of a mutable reference ends when the reference is no longer used and the next statement that requires a mutable reference is encountered. In your code, the scope of `y` ends after the `y.push(42)` call because `y` is not used anymore, allowing a new mutable reference `z` to be created.

Here is the code that compiles without additional scopes:

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn move_semantics4() {
        let mut x = Vec::new();
        let y = &mut x;
        y.push(42);
        let z = &mut x;
        z.push(13);
        assert_eq!(x, [42, 13]);
    }
}
```

In this code, the mutable reference `y` is no longer used after `y.push(42)`, so the borrow checker allows the creation of a new mutable reference `z`.

## Structs

There are three types of struct.

We can have a struct with field names defined, for example:

```rust
struct Colours {
    red: u8,
    green: u8,
    blue: u8
}

let red = Colours {red: 255, green: 0, blue: 0}

```

Alternatively, we can define a struct with only the field types expected, a tuple struct:
2
```rust
struct Colours {
    red: u8,
    green: u8,
    blue: u8
}

let green = Colours(0, 255, 0)

```

Finally, there is the unit struct, which doesn't contain any fields:

```rust
struct AlwaysEqual;

let subject = AlwaysEqual;
```

### Methods
We can define methods on structs, like an OO class (but no inheritance).

```rust
struct Rectangle {
    width: u32, height: u32
}

impl Rectangle {
    fn area(&self) -> u32{
        self.width * self.height
    }

    fn width(&self) -> bool {
        self.width > 0
    }    
}
```

The parameter `&self` is of type `Self`, which is an alias for the type of the struct that is in the impl block.
Note, `width()` is the same name as the field `width`. This is allowed.

We can also have associated functions, which are a part of the `impl`, but do not require an instance of the
struct to work with.
This seems to be like a static method.

```rust
impl Rectangle {

    fn square(size) -> Self{
        Self {width: size, height: size}
    }
}
```


### Ownership

Typically a struct should have all owned types, unless we use lifetimes (so e.g `String` instead of `&str`)

## Enums

An enum is a selection of possible values.
It has simialrities with a struct, but can be initialised with different parameters.
We define the possible kinds of thing this enum could be. For example, an IP address enum could be:

```rust
enum IpAddrKind {
    V4, V6
}
```

We can define the enum as having parameters required for initialisation - and they do not have to
be the same for each variant.

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

Then we can get a specific type of the enum with e.g `Message::Quit`, or `Message::Move{x: 3, y: 4}`.

Like with structs, we can also define methods on them too

```rust
impl Message {
    fn call(&self) {
        // Do stuff here
    }
}

let m = Message::Quit;
m.call();
```



## Pattern matching

This is an important aspect of rust, and is an elegant alternative to enormous `if/elif/else` blocks.
For example, suppose we have different possible types of messages we can receive from an enum, we can perform different operations depending on the type.

```rust
struct Message {
    Resize {width: u64, height: u64 },
    Quit
}

fn process(message: Message) {
    match message {
        Message::Resize => resize(width, height),
        ...
        Message::Quit => quit()
    }
}

```

## `if/while let` and `Option` enum

There is a similar construct to pattern matching for assigning variable values, `if let` syntax.

```rust
let config_max = Some(3u8);
if let Some(max) = config_max {
    println!("Matched {:?}!", max);
} else{
    println!("Didn't match config_max");
}

```
This example uses the `Option` enum, which is rust's alternative to null values.
`Option` either returns `Some` if there is a value, or `None` if there is not.
This is pretty similar to null values, but it requires that they are explicitly handled by the code.

Similarly, it is also possible to do this in a while loop, e.g for every item in a vector:

```rust
        while let Some(Some(integer)) = optional_integers.pop() {
            assert_eq!(integer, cursor);
            cursor -= 1;
        }

```

We can access the value in `Some` by calling `unwrap`.
It seems like this isn't great practice, but will find out more about this later.


## Data structures

There are some standard data structures which are useful to know about.

### Hash maps

Get hash maps from `std::collections::HashMap`. Adding a value:

```rust
use std::collections:: HashMap;

let mut mappy = HashMap::new();
mappy.insert(String::from("Hello"), 42)
```

Alternatively, a useful thing is to only insert if a key isn't present:
This allows us to interact with the value as well:

```rust
let x = mappy.entry(String::from("Hello")).or_insert(42);
// May need to dereference x sometimes
x += 1;
```
