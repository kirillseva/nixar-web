angular
  .module \app
  .service do
      * \content
      * ->
          data =
              * text: \maximum
                descr: 'Calculate maximum number in numeric list'
              * text: \file
                descr: 'Read content of the file'
              * text: \minimum
                descr: 'Calculate minimum number of the list'
              * text: \columns
                descr: 'Extract one or few columns from table like text'
              * text: \split
                descr: 'Split text file into table like text'
              * text: \remove
                descr: 'Remove substring from the string'
              * text: \at
                descr: 'Get concrete line'
              * text: \drop
                descr: 'Drop one or few lines'
              * text: \take
                descr: 'Take one or few lines'
              * text: \last
                descr: 'Get last line'
              * text: \tail
                descr: 'Skip first line and return other'
              * text: \sort
                descr: 'Sort lines by text'
              * text: \concat
                descr: 'Concat lines into one line'
              * text: \fs
                descr: 'Search files and directories by mask'
              * text: \sum
                descr: 'Calculate sum of numbers of all lines'
              * text: \unique
                descr: 'Get only unique lines'
              * text: \filter
                descr: 'Filter by regexp'
              * text: \match
                descr: 'Find matches'
              * text: \average
                descr: 'Calculate average of number from all lines'
              * text: \map
                descr: 'Transform the line'
              * text: \find
                descr: 'Find first line by regexp'
              * text: \replace
                descr: 'Replace substring into another substring in line'
              * text: \length
                descr: 'Length of characters in line'
              * text: \lower
                descr: 'Transform text to lowercase'
              * text: \upper
                descr: 'Transform text to uppercase'
              * text: \trim
                descr: 'Trim first and last space character'
              * text: \count
                descr: 'Return count of lines'
              * text: \head
                descr: 'Get only first line'
              * text: \reverse
                descr: 'First line goes to last line, last line goes to first line'
          by-text = (a,b)-> 
            | a.text > b.text => -1
            | a.text < b.text => 1
            | _ => 0
          data.sort by-text