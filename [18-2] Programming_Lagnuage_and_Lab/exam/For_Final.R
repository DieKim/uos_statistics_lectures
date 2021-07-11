#���� 5,6,7 Ư�� 6�� ����
#���Ϸ��� ���Ͼ�?�ּڰ�?
#Ŭ�����͸� = K-means 
#���� ���ڷ� ��ȯ ������
#�ι��� ... ����,����,+,-�� �ν��� �� �ְ� 

### ���� ���ڷ� ��ȯ�ϱ� ###

word_number100 = function(word){
  ### 1�ܰ� : �ܾ� �ɰ��� ���� �����
  wsplit = strsplit(tolower(word)," ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                                    six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
               sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                    sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  ### 2�ܰ� : �������  
  if(sum(!(wsplit %in% c(doubles, "hundred")))>0){
    stop( paste0("Error:", word))
  }
  ### 3�ܰ� : ���� ���� ��ȯ�ϱ�
  temp = rep(0,length(wsplit)) # ��ĭ
  for(i in length(wsplit) ){
      if(wsplit %in% names(doubles)){
      temp[i] = as.numeric(doubles[wsplit[i]])
    }else if(wsplit[i] == "hundred"){
      temp[i-1] = temp[i-1]*100
    }
  }
   out = sum(temp)
   return(list(out, word))
}

word_number1000 = function(word){
  #1�ܰ� �ܾ� �ɰ���
  wsplit = strsplit(tolower(word), " ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                    six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
               sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                    sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  #2�ܰ� �������
  if(sum(!(wsplit %in% c(names(doubles), "hundred", "thousand")))>0){
    stop ( paste0("Error:", word) )
  }
  #3�ܰ� ��ȯ�ϱ�
  temp = rep(0,length(wsplit))# ��ĭ�����
  cc = 0   # �������
  for(i in 1:length(wsplit)){
    if(wsplit[i] %in% names(doubles)){   # names(doubles)�� ������ �ִ�?
      temp[i] = as.numeric(doubles[wsplit[i]])   # ������ �ִٸ� doubles[wsplit[i]]�� ���ڷ� ��ȯ����
    }else if(wsplit[i] == "hundred"){
      temp[i-1] = temp[i-1]*100
      cc = cc + 1
    }else if(wsplit[i] == "thousand"){
      temp[i-1] = temp[i-1]*1000
      cc = cc + 1
    }
    
  }
  out = sum(temp)
  returm(list(out,word))
}

word = "two thousand three hundred twenty two"
Fun1 = function(word){
  wsplit = strsplit(tolower(word)," ")[[1]]
  one_digits = list(zero = 0, one = 1, two = 2, three = 3, four = 4, five = 5,
                    six = 6, seven = 7, eight = 8, nine = 9)
  teens = list(eleven = 11, twelve = 12, thirteen = 13, fourteen = 14, fifteen = 15,
               sixteen = 16, seventeen = 17, eighteen = 18, nineteen = 19)
  ten_digits = list(ten = 10, twenty = 20, thirty = 30, forty = 40, fifty = 50,
                    sixty = 60, seventy = 70, eighty = 80, ninety = 90)
  doubles = c(one_digits, teens, ten_digits)
  
  if(sum(!(wsplit %in% c(names(doubles), "hundred", "thousand")))>0){
    stop( paste0 ("Error:", word))
  }
  
  temp = rep(0,length(wsplit))
  cc= 0
  for(i in 1:length(wsplit)){
    if(wsplit[i] %in% names(doubles)){
      temp[i] = as.numeric(doubles[wsplit[i]])
    }else if(wsplit[i] == "hundred"){
      temp[i-1] = temp[i-1]*100
      cc = cc + 1
    }else if(wsplit[i] %in% "thousand"){
      temp[i-1] = temp[i-1]*1000
      cc = cc + 1
    }
  }
  out = sum(temp)
  return(list(out, word))
}
Fun1(word)

word_to_num = function(word)
{
  #1�ܰ� �ܾ� �ɰ���, ������ ����
  wsplit = strplit(tolower(word)[[1]]," ")[[1]]
  operators = list(plus = "+", minus = "-", multiplication = "*", division = "/")

  #2�ܰ� ������ �������� �ɰ���
  if (sum(wsplit %in% names(operators)) < 1) {   #������ ���ٸ�
    result_num = word_to_num1000(word)   #������� ���� �Լ����� ����
    result = result_num   #result�� return�Ұ���
  } else if (sum(wsplit %in% names(operators)) > 0) {   #������ �ִٸ�
    oper_ind = which(wsplit %in% names(operators))   #������ ���°�� �ִ�
    oper = operators[wsplit[oper_ind]]   #oper�� ������
    wsplit2 = strsplit(tolower(word)[[1]], paste(paste("", wsplit[oper_ind], ""), collapse = "|"))[[1]]   #������ �������� �ɰ�
    #3�ܰ� �ɰ��� �游���?
    num = vector(mode = "list", length = length(wsplit2))   #�����
    for (i in 1:length(wsplit2)) {
      num[[i]] = word_to_num1000(wsplit2[i])
    }
    # ������ ���
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


