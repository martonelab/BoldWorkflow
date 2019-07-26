#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  5 09:13:10 2018

@author: Jasmine

original code taken from crayhottommy
https://gist.github.com/crazyhottommy/a59df92b48e6ad3f4630#file-change_fasta_header-py
"""
anno_file = input("anotation file name:")
with open (anno_file, "r") as annotation:
    anotation_dict = {}
    for line in annotation:
        line = line.split(",")
        if line: #test whether it is an empty line
            anotation_dict[line[0]] = line[1:]
        else:
            continue

# really should not parse the fasta file by myself. there are
# many parsers already there. you can use module from Biopython
ofile = open (input("outfile name:"), "w")

with open (input("FASTA file to change:"), "r") as myfasta:
    for line in myfasta:
        if line.startswith (">"):
            line = line[1:] # skip the ">" character
            for [i] in anotation_dict:
                if line.startswith(anotation_dict[i]):
                    new_line = ">" + str(anotation_dict[0])
                    ofile.write ( new_line + "\n")
                else:
                    ofile.write ( ">"+ "".join(line) + "\n")
        else:
            ofile.write(line +"\n")


ofile.close() # always remember to close the file.
