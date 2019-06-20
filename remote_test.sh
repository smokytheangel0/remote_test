

cargo clean
cargo test --no-run --target=armv7-unknown-linux-gnueabihf
project=$(pwd)
project=$(basename $project)
inBOX_d=$(ls target/armv7-unknown-linux-gnueabihf/debug/deps/$project-*.d)
inBOX_d=$(basename $inBOX_d)
inBOX=${inBOX_d:0:(-2)}
ssh raspberry_pi "cd /home/pi; if [ ! -d '$project' ]; then /home/pi/.cargo/bin/cargo new $project; fi;"
ssh raspberry_pi "cd /home/pi/$project; /home/pi/.cargo/bin/cargo clean; /home/pi/.cargo/bin/cargo test --no-run"
outBOX_d=$(ssh raspberry_pi "ls /home/pi/$project/target/debug/deps/$project-*.d")
outBOX_d=$(basename $outBOX_d)
outBOX=${outBOX_d:0:(-2)}
scp target/armv7-unknown-linux-gnueabihf/debug/deps/$inBOX raspberry_pi:/home/pi/$project/target/debug/deps/.
scp target/armv7-unknown-linux-gnueabihf/debug/deps/$inBOX_d raspberry_pi:/home/pi/$project/target/debug/deps/.

ssh raspberry_pi "mv /home/pi/$project/target/debug/deps/$inBOX /home/pi/$project/target/debug/deps/$outBOX; mv /home/pi/$project/target/debug/deps/$inBOX_d /home/pi/$project/target/debug/deps/$outBOX_d;"
ssh raspberry_pi "chmod +x /home/pi/$project/target/debug/deps/*;"

echo $(ssh raspberry_pi "cd /home/pi/$project; /home/pi/.cargo/bin/cargo test")
