led1 = 3
led2 = 6

local led={}
led[0]="OFF"
led[1]="OFF"

title={}
questions={}
answers={}
correctanswers={}

buf = [[
          <a href="?pin=CREATETEST"><button><b>Create Test</b></button></a>
      ]]

local function createTest()
  buf = [[
              <div style="width: 40%; margin: 0 auto;">
                <h1><u>Test time</u></h1>
                <h3>Write your questions and answers!</h3>
                
                <form method="POST" action="STARTTEST">
                  <p>Test's title: <input sytle="width:300px" type="text" name="title" required/></p>

                  <p>1) Pergunta:<input style="width:600px" type="text" name="question1" pattern=".{1,}" required/></p>
                  <p>a) <input type="radio" name="correctanswer1" value="a11" required> <input style="width:600px" type="text" name="answer11" pattern=".{1,}" required/></p>
                  <p>b) <input type="radio" name="correctanswer1" value="a12"> <input style="width:600px" type="text" name="answer12" pattern=".{1,}" required/></p>
                  <p>c) <input type="radio" name="correctanswer1" value="a13"> <input style="width:600px" type="text" name="answer13" pattern=".{1,}" required/></p>

                  <p>2) Pergunta: <input style="width:600px" type="text" name="question2" pattern=".{1,}" required/></p>
                  <p>a) <input type="radio" name="correctanswer2" value="a21" required> <input style="width:600px" type="text" name="answer21" pattern=".{1,}" required/></p>
                  <p>b) <input type="radio" name="correctanswer2" value="a22"> <input style="width:600px" type="text" name="answer22" pattern=".{1,}" required/></p>
                  <p>c) <input type="radio" name="correctanswer2" value="a23"> <input style="width:600px" type="text" name="answer23" pattern=".{1,}" required/></p>

                  <p>3) Pergunta: <input style="width:600px" type="text" name="question3" pattern=".{1,}" required/></p>
                  <p>a) <input type="radio" name="correctanswer3" value="a31" required> <input style="width:600px" type="text" name="answer31" pattern=".{1,}" required/></p>
                  <p>b) <input type="radio" name="correctanswer3" value="a32"> <input style="width:600px" type="text" name="answer32" pattern=".{1,}" required/></p>
                  <p>c) <input type="radio" name="correctanswer3" value="a33"> <input style="width:600px" type="text" name="answer33" pattern=".{1,}" required/></p>

                  <input type="submit" value="Start test!"/>
                </form>

                <p>
            </div>
        ]]
end

local function startTest()
  buf = [[
          <div style="width: 40%; margin: 0 auto;">
            <h1><u>Test time</u></h1>
            <h3>Answer the following questions</h3>

            <h4> $TITLE </h4>
            
            <form method="POST" action="RESULTS">
              <p>1) Question: $QUESTION1</p>

              <input type="radio" name="answer1" value="$ANSWER11" required> $ANSWER11
              <input type="radio" name="answer1" value="$ANSWER12"> $ANSWER12
              <input type="radio" name="answer1" value="$ANSWER13"> $ANSWER13

              <p>2) Question: $QUESTION2</p>

              <input type="radio" name="answer2" value="$ANSWER21" required> $ANSWER21
              <input type="radio" name="answer2" value="$ANSWER22"> $ANSWER22
              <input type="radio" name="answer2" value="$ANSWER23"> $ANSWER23

              <p>3) Question: $QUESTION3</p>
              
              <input type="radio" name="answer3" value="$ANSWER31" required> $ANSWER31
              <input type="radio" name="answer3" value="$ANSWER32"> $ANSWER32
              <input type="radio" name="answer3" value="$ANSWER33"> $ANSWER33
              <br>
              <br>
              <input type="submit" value="Show results"/>
            </form>

            <p>
          </div>

        ]]
end

local function finishTest()
  buf = [[
          <div style="width: 40%; margin: 0 auto;">
            <h1><u>Results</u></h1>
            <h3>Check your results</h3>

            <h4> $TITLE </h4>
            
            <p> Question: $QUESTION1</p>
            <p> Correct Answer: $CORRECTANSWER1</p>
            <p> Your Answer: $ANSWER1</p>

            <p> Question: $QUESTION2</p>
            <p> Correct Answer: $CORRECTANSWER2</p>
            <p> Your Answer: $ANSWER2</p>

            <p> Question: $QUESTION3</p>
            <p> Correct Answer: $CORRECTANSWER3</p>
            <p> Your Answer: $ANSWER3</p>
            
          </div>

        ]]
end

local actions = {
  CREATETEST = createTest,
}

srv = net.createServer(net.TCP)

function receiver(sck, request)

  -- analisa pedido para encontrar valores enviados
  local _, _, method, path, vars = string.find(request, "([A-Z]+) ([^?]+)%?([^ ]+) HTTP")

  -- se nÃ£o conseguiu casar, tenta sem variaveis
  if(method == nil) then
    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
  end

  local _GET = {}
  local _POST = {}

  if(method == "POST") then
    for k, v in string.gmatch(request, "title=([^&]+)") do
      if(v ~= nil) then
        print("titulo aqui")
        v = string.gsub(v, "+", " ")
        table.insert(title, v)
      end
    end
    for k, v in string.gmatch(request, "question(%d+)=([^&]+)") do
      if(v ~= nil) then
        v = string.gsub(v, "+", " ")
        table.insert(questions, v)
      end
    end
    for k, v in string.gmatch(request, "answer(%d+)=([^&]+)") do
      if(v ~= nil) then
        v = string.gsub(v, "+", " ")
        if v == "a11" or v == "a12" or v == "a13" or v == "a21" or v == "a22" or v == "a23" or v == "a31" or v == "a32" or v == "a33" then table.insert(correctanswers, v)
        else table.insert(answers, v) end
      end
    end
    
    if correctanswers[1] == "a11" then correctanswers[1] = answers[1]
    elseif correctanswers[1] == "a12" then correctanswers[1] = answers[2]
    elseif correctanswers[1] == "a13" then correctanswers[1] = answers[3] end

    if correctanswers[2] == "a21" then correctanswers[2] = answers[4]
    elseif correctanswers[2] == "a22" then correctanswers[2] = answers[5]
    elseif correctanswers[2] == "a23" then correctanswers[2] = answers[6] end

    if correctanswers[3] == "a31" then correctanswers[3] = answers[7]
    elseif correctanswers[3] == "a32" then correctanswers[3] = answers[8]
    elseif correctanswers[3] == "a33" then correctanswers[3] = answers[9] end

    if(path == "/RESULTS") then
      finishTest()
    else
      startTest()
    end

  elseif(method == "GET") then
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end

    local action = actions[_GET.pin]
    if action then action() end

  end

  print(request)
  local vals = {
    QUESTION1 = questions[1],
    ANSWER11 = answers[1],
    ANSWER12 = answers[2],
    ANSWER13 = answers[3],
    QUESTION2 = questions[2],
    ANSWER21 = answers[4],
    ANSWER22 = answers[5],
    ANSWER23 = answers[6],
    QUESTION3 = questions[3],
    ANSWER31 = answers[7],
    ANSWER32 = answers[8],
    ANSWER33 = answers[9],
    ANSWER1 = answers[10],
    ANSWER2 = answers[11],
    ANSWER3 = answers[12],
    CORRECTANSWER1 = correctanswers[1],
    CORRECTANSWER2 = correctanswers[2],
    CORRECTANSWER3 = correctanswers[3],
    TITLE = title[1]
  }

  buf = string.gsub(buf, "$(%w+)", vals)
  sck:send(buf, function() print("respondeu") sck:close() end)
end

if srv then
  srv:listen(80,"192.168.0.66", function(conn)
      print("estabeleceu conexao")
      conn:on("receive", receiver)
    end)
end

addr, port = srv:getaddr()
print(addr, port)
print("servidor inicializado.")
