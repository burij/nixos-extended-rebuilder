 # Lua Light Wings
Personal set of useful functions with beautiful syntax to extend Lua Language to my needs, based on [Meelua](https://github.com/burij/meelua).

## Quickstart

```
git clone https://github.com/burij/lua-light-wings.git
cd lua-light-wings
```

## Modules
### llw-core.lua

```
msg(x)
-- console output, can handle tables
```

```
is_any(x)
is_function(x)
is_boolean(x)
is_number(x)
is_string(x)
is_table(x)
is_list(x)
is_dictionary(x)
is_path(x)
is_url(x)
is_email(x)
-- raises error, in case the variable is not of the right type
```

```
globalize(x)
-- loads content of a module to a global space
is_dictionary(x)
```

```
map(x, y)
-- calls function on every element of a table
is_table(x)
is_function(y)
```

```
filter(x, y)
-- filters table elements based on predicate function
is_table(x)
is_function(y)
```

```
reduce(x, y, var)
-- reduces table to single value using accumulator function
is_table(x)
is_function(y)
```


### llw-extended-lib.lua
Unsorted collection of helper functions, will not be documented, read the code to use.


# License
This project is licensed under the MIT License. See the LICENSE file for more details.
