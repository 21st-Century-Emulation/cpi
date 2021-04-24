docker build -q -t cpi .
docker run --rm --name cpi -d -p 8080:8080 cpi

RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"id":"abcd", "opcode":128,"state":{"a":74,"b":1,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":true,"zero":true,"auxCarry":true,"parity":true,"carry":true},"programCounter":1,"stackPointer":2,"cycles":0}}' \
  http://localhost:8080/api/v1/execute?operand1=64`
EXPECTED='{"id":"abcd", "opcode":128,"state":{"a":74,"b":1,"c":0,"d":5,"e":15,"h":10,"l":20,"flags":{"sign":false,"zero":false,"auxCarry":true,"parity":true,"carry":false},"programCounter":1,"stackPointer":2,"cycles":7}}'

docker kill cpi

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mCPI Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mCPI Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi