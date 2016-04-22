
#!/usr/bin/env sh

TARGET="dco-node[137-144]"
clush -w $TARGET -l root "sudo ~/helpers/killall.sh $i"
sleep 30

