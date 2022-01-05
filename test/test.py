#!/usr/bin/env python3

import argparse

def testfunc():
    a = [1,2,3]
    print(a)

def main():
    testfunc()
    args = parse_arguments()
    print(args.add)

def parse_arguments():
    parser = argparse.ArgumentParser(description="Parser template")
    parser.add_argument("-A", "--add", default=None, help="Add")
    return parser.parse_args()


if __name__ == "__main__":
    main()
