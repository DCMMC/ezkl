#wget https://trusted-setup-halo2kzg.s3.eu-central-1.amazonaws.com/perpetual-powers-of-tau-2
#./ezkl -K=15 --max-rotations=128 --scale=4 --bits=10 forward -D input.json -M network.onnx --output 2lin.json

# Single proof -> single proof we are going to feed into aggregation circuit. (Mock)-verifies + verifies natively as sanity check
./ezkl -K=15  --max-rotations=128  --scale=4 --bits=10 prove --transcript=poseidon --strategy=accum -D 2lin.json -M network.onnx --proof-path 2l.pf --params-path=perpetual-powers-of-tau-26  --vk-path=2l.vk

# Aggregate -> generates aggregate proof and also (mock)-verifies + verifies natively as sanity check
./ezkl -K=26  --max-rotations=128  --scale=4 --bits=10 aggregate --app-logrows=15 --transcript=evm -M network.onnx --aggregation-snarks=2l.pf --aggregation-vk-paths 2l.vk --vk-path aggr_2l.vk --proof-path aggr_2l.pf --params-path=perpetual-powers-of-tau-26

# Generate verifier code -> create the EVM verifier code 
./ezkl -K=26   --max-rotations=128 --scale=4 --bits=10 create-evm-verifier-aggr --deployment-code-path aggr_2l.code --params-path=perpetual-powers-of-tau-26 --vk-path aggr_2l.vk

# Verify (EVM) -> 
./ezkl -K=26  --max-rotations=128 --scale=4 --bits=10 verify-evm --proof-path aggr_2l.pf --deployment-code-path aggr_2l.code

