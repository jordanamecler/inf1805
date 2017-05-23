led1 = 3
led2 = 6

local led={}
led[0]="OFF"
led[1]="OFF"

title={}
questions={}
answers={}

buf = [[
          <a href="?pin=CREATETEST"><button><b>Create Test</b></button></a>
      ]]

local function createTest()
  buf = [[
              <div style="width: 40%; margin: 0 auto;">
                <h1><u>Kahoot but better</u></h1>
                <h3>Write your questions! </h3>
                
                <form method="POST" action="STARTTEST">
                  <p>Test's title: <input sytle="width:300px" type="text" name="title"/></p>

                  <p>1) Pergunta:<input style="width:600px" type="text" name="question1"/></p>
                  <p>a) <input style="width:600px" type="text" name="answer11"/></p>
                  <p>b) <input style="width:600px" type="text" name="answer12"/></p>
                  <p>c) <input style="width:600px" type="text" name="answer13"/></p>

                  <p>2) Pergunta: <input style="width:600px" type="text" name="question2"/></p>
                  <p>a) <input style="width:600px" type="text" name="answer21"/></p>
                  <p>b) <input style="width:600px" type="text" name="answer22"/></p>
                  <p>c) <input style="width:600px" type="text" name="answer23"/></p>

                  <p>3) Pergunta: <input style="width:600px" type="text" name="question3"/></p>
                  <p>a) <input style="width:600px" type="text" name="answer31"/></p>
                  <p>b) <input style="width:600px" type="text" name="answer32"/></p>
                  <p>c) <input style="width:600px" type="text" name="answer33"/></p>

                  <input type="submit" value="Start test! uhul"/>
                </form>

                <p>
            </div>
        ]]
end

local function startTest()
  buf = [[
          <div style="width: 40%; margin: 0 auto;">
            <h1><u>Kahoot but better</u></h1>
            <h3>On ur marks, ready, steady, 1, 2, 3, jacareh, jabuti, go!!1! </h3>

            <h4>Test title</h4>
            
            <form method="POST" action="finished">
              <p>1) Pergunta: $QUESTION1</p>

              <input type="radio" name="answer1" value="$ANSWER11"> $ANSWER11
              <input type="radio" name="answer1" value="$ANSWER12"> $ANSWER12
              <input type="radio" name="answer1" value="$ANSWER13"> $ANSWER13

              <p>2) Pergunta: $QUESTION2</p>

              <input type="radio" name="answer2" value="$ANSWER21"> $ANSWER21
              <input type="radio" name="answer2" value="$ANSWER22"> $ANSWER22
              <input type="radio" name="answer2" value="$ANSWER23"> $ANSWER23

              <p>3) Pergunta: $QUESTION3</p>
              
              <input type="radio" name="answer3" value="$ANSWER31"> $ANSWER31
              <input type="radio" name="answer3" value="$ANSWER32"> $ANSWER32
              <input type="radio" name="answer3" value="$ANSWER33"> $ANSWER33
              <br>
              <br>
              <input type="submit" value="I WANT SOME ANSWERS"/>
            </form>

            <p>
          </div>

        ]]
end

local function finishTest()
end

local actions = {
  CREATETEST = createTest,
  STARTTEST = startTest,
  FINISHTEST = finishTest,
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
    for k, v in string.gmatch(request, "title(%d+)=([^&]+)") do
      if(v ~= nil) then
        table.insert(title, v)
      end
    end
    for k, v in string.gmatch(request, "question(%d+)=([^&]+)") do
      if(v ~= nil) then
        table.insert(questions, v)
      end
    end
    for k, v in string.gmatch(request, "answer(%d+)=([^&]+)") do
      if(v ~= nil) then
        table.insert(answers, v)
      end
    end
    startTest()

  elseif(method == "GET") then
    if (vars ~= nil)then
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end

    local action = actions[_GET.pin]
    if action then action() end

  end

  local vals = {
    QUESTION1 = questions[1],
    ANSWER11 = answers[1]
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
