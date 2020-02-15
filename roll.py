#!/usr/bin/env python3

import random

def roll(ndice, dsize):
    dsum = 0
    for i in range(ndice):
        dsum += random.randint(1,dsize)
    return(dsum)

def main():
    import sys
    
    ndice = int(sys.argv[1])
    dsize = int(sys.argv[2])
    print(roll(ndice, dsize))

if __name__ == "__main__":
    main()
