# hash package for R
# Thanks to Christopher Brown for this handy package
# author: Srikanth KS
library("hash")
packageVersion("hash")
R.Version()$version.string

# helper libraries
library("pryr")
library("microbenchmark")
library("peakRAM")

# create a dict starting with empty
adict <- hash()

# create a few KV pairs
adict[["hello"]] <- 1L
adict[["world"]] <- iris[1:2,]

# recall an existing value for a key
adict[["world"]]

# recalling non-existing key returns NULL
adict[["hi"]]

# non-character key will be coerced, but it might not be a good practice
adict[100] <- 1000

# assigning NULL value is not possible
adict[["nothing"]] <- NULL

# gets keys, values, length
keys(adict)   # returns a character vector
values(adict) # returns a named list
length(adict) # returns a positive integer

# delete a KV pair
del("100", adict)

# check for key existence, helpful for assertions
has.key(c("hello", "100"), adict)

# constructing a hash object with keys and values
alph_dict <- hash( letters, 1:26 )

# invert a dict, there might be corecion issues
# to be used when one is sure
inverted_alph_dict <- invert(alph_dict)

# hash is an S4 object built on top of an environment
class(adict)
str(adict)
ls(unclass(adict))
unclass(adict)[["hello"]]

# making a copy of the hash
# since hash is a reference class object, we need a explicit copy

alph_dict2 <- copy(alph_dict)
identical(keys(alph_dict), keys(alph_dict2))
identical(values(alph_dict), values(alph_dict2))

# the copy will at a different address location
address(alph_dict)
address(alph_dict2)

# lets make time and memory comparisions
number_hash <- hash()
for(i in 1:1e5){
  number_hash[[as.character(i)]] = i
}

number_list <- as.list(1:1e5)
names(number_list) <- as.character(1:1e5)

# the size comparision does not make sense
# hash object, essentially an environment, is little more than a hash map
object.size(number_list)
object.size(number_hash)

key_sample <- sample(as.character(1:1e5), 1e3)

# hash object timing
# takes median value of 3.17 milliseconds on my computer
microbenchmark(
  for(akey in key_sample){
    number_hash[[akey]]
  }
)

# list object timing
# takes median value of 410.86 milliseconds on my computer
microbenchmark(
  for(akey in key_sample){
    number_list[[akey]]
  }
)

# hash object memory profile
# shows 0, must be negligible
peakRAM(
  for(akey in key_sample){
    number_hash[[akey]]
  }
)

# list object memory profile
# shows 0, must be negligible
peakRAM(
  for(akey in key_sample){
    number_list[[akey]]
  }
)

# finally, clearing a hash object
clear(number_hash)
is.empty(number_hash)

# clear the clutter
rm(adict
   , akey
   , alph_dict
   , alph_dict2
   , i
   , inverted_alph_dict
   , key_sample
   , number_hash
   , number_list
   )
detach("package:hash", unload = TRUE)
detach("package:pryr", unload = TRUE)
detach("package:microbenchmark", unload = TRUE)
detach("package:peakRAM", unload = TRUE)
