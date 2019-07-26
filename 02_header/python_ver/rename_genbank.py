#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul  9 14:21:47 2018

@author: Jasmine
"""

def rename_genbank(annotation_file,fasta):
    '''
    (string, string) -> file
    *strings must include file extention (ie .csv)
    *have script and files in the same folder
    
    Takes a csv with all the species information and a FASTA file
    replacing the original file names with Genbank formatted file names
    
    Takes a file that has the columns ordered as:
    Herbarium # (no space),collection #, Hebarium # with space, Species, 
    Herbarium # = key
    '''
    #Open given files
    with open (annotation_file, "r") as annotation:
        annotation_dict = {}
        print(annotation.readline()) #show header and skip header
        for line in annotation:
            line = line.strip()
            line = line.split(",")
            if line: #test whether it is an empty line
                annotation_dict[line[0]] = line[1:4] #makes first row key and other 2 rows values
            else:
                continue

    ofile = open (input("outfile name:"), "w")
 
    with open(fasta) as fasta_file:
        for line in fasta_file:
            if line.startswith(">"): # if it is a header line
                line = line.replace(">","")
                line = line.strip().split("|")
                if line[0] in annotation_dict:
                    columns = annotation_dict[line[0]]
                    ofile.write(">"+columns[1]+"|"+columns[2]+"("+columns[0]+")\n")   
                ## 0 = collection # 1 = herbarium # (with space), 2 = species
                else:
                    ofile.write("\n")
                    print("error:"+line[0])
            else:
                ofile.write(line)    
    
    ofile.close()
    
    return