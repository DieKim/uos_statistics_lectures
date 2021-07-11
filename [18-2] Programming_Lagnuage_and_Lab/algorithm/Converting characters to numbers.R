
word = "seven"

### simple example for 0-9 ###
word_to_num001 = function(word)
{
  out = NULL
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                     six = 6, seven = 7, eight = 8, nine = 9)
  if (word %in% names(one_digits)){
    out = as.numeric(one_digits[word])
  }
  return(list(word, out))
}
word_to_num001("seven")  
word_to_num001("for")  

word = "sixty one"

### simple example for 1 - 99 ###
word_to_num010 = function(word)
{
  wsplit = strsplit(tolower(word)," ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                    six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
               sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                    sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  out = 0
  length_of_word = length(wsplit)
  for (i in 1:length_of_word) {
    if (wsplit[i] %in% names(doubles)) {
      temp = as.numeric(doubles[wsplit[i]])
    }
    out = out + temp
  }
  return(list(word, out))
}

word_to_num010(word)
word_to_num010("twenty three")
word_to_num010("eighty four")
word_to_num010("ten")

########################
word = "one hundred sixty one"
### simple example for 1 - 999 ###
word_to_num100 = function(word)
{
  wsplit = strsplit(tolower(word)," ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                    six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
               sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                    sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  if (sum(!(wsplit %in% c(names(doubles), "hundred"))) > 0) {
    stop( paste0("Error:", word ) )
  }

  temp= rep(0, length(wsplit))
  for(i in 1:length(wsplit)){
    
    if (wsplit[i] %in% names(doubles)) {
      temp[i] = as.numeric(doubles[wsplit[i]])
    } else if (wsplit[i] == "hundred") {
      temp[i - 1] = temp[i - 1] * 100
    }
  }
  out = sum(temp)
  return(list(word, out))
}

word_to_num100("one hundred sixty one")
word_to_num100("five hundred forty one")
word_to_num100("five hundred fourty one")
word_to_num100("thirty one")
word_to_num100("twelve one")

word_to_num1000 = function(word)
{
  wsplit = strsplit(tolower(word), " ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                     six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
                sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                     sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  if (sum(!(wsplit %in% c(names(doubles), "hundred", "thousand"))) > 0) {
    stop(paste("Error:", word))
  }
  
  tmp = numeric(length(wsplit))
  cc = 0
  for (i in 1:length(wsplit)) {
    if (wsplit[i] %in% names(doubles)) {
      tmp[i] = as.numeric(doubles[wsplit[i]])
    } else if (wsplit[i] == "hundred") {
      tmp[i - 1] = tmp[i - 1] * 100
      cc = cc + 1
    } else if (wsplit[i] == "thousand") {
      tmp[i - 1] = tmp[i - 1] * 1000
      cc = cc + 1
    }
  }
  out = sum(tmp)
  
  if (sum(tmp %in% unlist(teens)) > 1 | sum(tmp %in% unlist(ten_digits)) > 1) {stop(paste("Error:", word))}
  if (sum(tmp %in% unlist(one_digits)) > (cc + 1)) {stop(paste("Error:", word))}
  if ((length(wsplit) > 1) & (out == 0)) {stop(paste("Error:", word))}
  return(list(word, out))
}

word_to_num1000("thirty one")
word_to_num1000(word = "one hundred thirty one")
word_to_num1000(word = "three thousand one hundred thirty one")
word_to_num1000(word = "twelve twelve twelve")
word_to_num1000(word = "thirteen twelve")
