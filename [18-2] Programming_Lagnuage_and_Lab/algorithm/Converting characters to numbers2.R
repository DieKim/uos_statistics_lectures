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

#일단 함수하나 만들었다는 가정하에 아래 함수 

word_to_num = function(word)
{
  #1단계 단어 쪼개기, 연산자 정의
  wsplit = strsplit(tolower(word)[[1]], " ")[[1]]
  operators = list(plus = "+", minus = "-", multiplication = "*", division = "/")
  #2단계 연산자 기준으로 쪼개기
  if (sum(wsplit %in% names(operators)) < 1) {   #연산자 없다면
    result_num = word_to_num1000(word)   #결과값은 앞의 함수값과 같음
    result = result_num   #result를 return할거임
  } else if (sum(wsplit %in% names(operators)) > 0) {   #연산자 있다면
    oper_ind = which(wsplit %in% names(operators))   #연산자 몇번째에 있니
    oper = operators[wsplit[oper_ind]]   #oper은 연산자
    wsplit2 = strsplit(tolower(word)[[1]], paste(paste("", wsplit[oper_ind], ""), collapse = "|"))[[1]]   #연산자 기준으로 쪼갬
    #3단계 쪼갠거 방만들기?
    num = vector(mode = "list", length = length(wsplit2))   #빈공간
    for (i in 1:length(wsplit2)) {
      num[[i]] = word_to_num1000(wsplit2[i])
    }
    # 연산자 계산
    if (length(oper_ind) == 1) {
      result_num = Reduce(unlist(oper), sapply(num, "[[", 2))
      result = list(word, result_num)
    } else {
      num = sapply(num, "[[", 2)
      tmp = paste(num, unlist(oper))
      result_tmp = paste(paste(tmp[-length(tmp)], collapse = " "), num[length(num)])
      result_num = eval(parse(text = result_tmp))
      result = list(word, result_num)
    }
  }
  return(result)
}

word_to_num("thirty one plus forty five")
word_to_num("thirty one")
word_to_num("thirty one plus forty five minus one")
word_to_num("one hundred forty five minus sixty multiplication zero")
word_to_num("one hundred forty five division five minus one thousand")
word_to_num("one hundred forty five division five minus one thousand one division four")
