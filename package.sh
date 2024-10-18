


function pepe() {
    function ana() {
        echo "ana"
    }

    declare -f
}

pepe
ana

source internal/load.sh

echo "function ___PACKAGED_SCRIPT() {" > ./bin/trsh
echo "log.red \"pepe\"" >> ./bin/trsh
echo "}" >> ./bin/trsh

echo "function ___PACKAGED_TRSH() {" >> ./bin/trsh
load.package "$PWD" >> ./bin/trsh
echo "}" >> ./bin/trsh

echo "___PACKAGED_TRSH" >> ./bin/trsh
echo "___PACKAGED_SCRIPT" >> ./bin/trsh

