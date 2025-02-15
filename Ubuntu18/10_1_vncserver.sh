#!/bin/bash

PROMPT="[${USER}@${HOSTNAME%%.*} ${PWD/#$HOME/~}]#"

echo " VNC 접속용 암호를 지정합니다 "
echo -e  "\033[1;34m${PROMPT} vnc4server \033[0m"
vnc4server

echo ""
echo ""

echo " VNC 실행 및 연결 "

echo ""
echo -e  "\033[1;34m${PROMPT} vncserver -kill :1 \033[0m"
vncserver -kill :1
echo ""
echo -e  "\033[1;34m${PROMPT} cat .vnc/xstartup \033[0m"
cat .vnc/xstartup
echo ""
echo -e  "\033[1;34m${PROMPT} mv .vnc/xstartup .vnc/xstartup.bak \033[0m"
mv .vnc/xstartup .vnc/xstartup.bak
echo ""
echo -e  "\033[1;34m${PROMPT} echo '#!/bin/bash  ' > .vnc/xstartup \033[0m"
echo '#!/bin/bash  ' > .vnc/xstartup
echo ""
echo -e  "\033[1;34m${PROMPT} echo 'startxfce4 &  ' >> .vnc/xstartup \033[0m"
echo 'startxfce4 &  ' >> .vnc/xstartup
echo ""
echo ""
echo -e  "\033[1;34m${PROMPT} cat .vnc/xstartup \033[0m"
cat .vnc/xstartup
echo ""
echo -e  "\033[1;34m${PROMPT} chmod +x .vnc/xstartup \033[0m"
chmod +x .vnc/xstartup
echo ""
echo ""
echo -e  "\033[1;34m${PROMPT} vnc4server \033[0m"
vnc4server

echo ""


echo " VNC 실행 확인 후 kill "
echo ""
echo -e  "\033[1;34m${PROMPT} vncserver -kill :1 \033[0m"
vncserver -kill :1
echo ""
echo -e  "\033[1;34m${PROMPT} exit \033[0m"
exit
echo ""
