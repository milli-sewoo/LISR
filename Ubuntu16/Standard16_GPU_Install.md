# 다산데이타 Ubuntu 16.04  설치 표준안 (2018.09)
다산데이터 출고 장비에 설치되는 리눅스 (Ubuntu) 의 설치 표준안 입니다.  
별도의 요청사항이 없는 경우 기본적으로 아래 절차에 따라 설치한 후 출고 하고 있습니다.  
보완이 필요한 점이나 새로운 아이디어를 제보해 주시면 적극 반영하겠습니다 :)  

감사합니다.  

![Dasandata Logo](http://www.dasandata.co.kr/dasanlogo.jpg)

## #목차
[1. Cuda install 사전 작업](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-1-cuda-install-%EC%82%AC%EC%A0%84-%EC%9E%91%EC%97%85)  

[2. Cudnn Install                         ](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-2-cudnn-install)

[3. Deep Learning Package Install (python-PIP, tensorflow](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-3-deep-learning-package-install-python-pip-tensorflow)  

[4. Deep Learning Package Install 2 (python-PIP, PyTorch)](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-4-deep-learning-package-install-2-python-pip-pytorch)  

[5. GPU Burning Test                                           ](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-5-gpu-burning-test)

[6. GPU Job Scheduler                                           ](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-6-gpu-job-scheduler)

[7. history 저장 (차후 설치기록 참고용](https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard16_GPU_Install.md#-7-history-%EC%A0%80%EC%9E%A5-%EC%B0%A8%ED%9B%84-%EC%84%A4%EC%B9%98%EA%B8%B0%EB%A1%9D-%EC%B0%B8%EA%B3%A0%EC%9A%A9)


[1]: https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard_Install_Ubuntu.md#-1-%EA%B8%B0%EB%B3%B8-%EC%9C%A0%ED%8B%B8-%EC%84%A4%EC%B9%98--%EC%8B%9C%EA%B0%84-%EB%8F%99%EA%B8%B0%ED%99%94  
[2]: https://github.com/dasandata/LISR/blob/master/Ubuntu16/Standard_Install_Ubuntu.md#-2-profile-%EC%84%A4%EC%A0%95---console-color--alias  

***

## # 범례(변수).
- <내용>: 상황에 따라 변경이 필요한 내용을 표현 합니다.  
- ${변수명} : 반복되어 사용되는 부분이 있을 때 사용되는 변수 입니다.  

## # 팁.
- 명령을 실행시킬때, 명령어 박스 단위로 복사하여 터미널에 붙여 넣으면 됩니다.  
- 박스가 분리되어 있는 경우 분리된 단위로 복사하여 붙여 넣어야 합니다.  

## # 리눅스 설치시 IP 와 HOSTNAME 은 수동으로 미리 설정 한다.
\# 처음 설치 할때부터 고정 IP를 설정하고 HOSTNAME을 정의 하는 것을 권장 합니다.  

### # 터미널을 통해 리눅스가 새로 설치된 장비에 로그인 합니다.

#### # Windows 에서 리눅스 접속 (putty) / X11 Forwading / 파일 송수신 (winscp)
\#  
\# putty (SSH Terminal - X11 Forwarding Enable)  
\# https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html  
\#  
\# Xming (X11 Forward - Windows Application)  
\# https://sourceforge.net/projects/xming/  
\#  
\# 파일 전송 winscp  
\# https://winscp.net/eng/download.php  
\#  
#### # 리눅스 터미널 에서.
```bash
ssh <사용자 계정>@<IP 주소>
```

### # 관리자(root) 로 전환.
```bash
# sudo -i
# 또는
# su -
```
### # sudo -i 와 su - 의 차이점
\# 1. sudo -i 는 sudo 권한이 있는 사용자가, 사용자의 암호를 사용해서 root 권한으로 명령을 실행 하는 것 입니다.  
\# root 의 패스워드를 몰라도 root 권한의 명령을 수행할 수 있습니다.  
\#  
\# 2. su -    는 sudo 권한과 관계 없이 root 의 암호를 사용해서 root 계정으로 전환 하는 것 입니다.    
\# 'su - ' 의 경우 재접속 없이 다른 사용자 계정으로 전환 할 수 있는 명령 이며 아래와 같이 실행 합니다.    
\# ex) su  -  <다른 사용자 계정이름>   

***

### # [1. Cuda install 사전 작업](#목차)

##### # nouveau disable
```bash
systemctl  get-default
systemctl  set-default  multi-user.target

lsmod  | grep  nouveau  

echo  "
blacklist nouveau
options nouveau modeset=0
"   >> /etc/modprobe.d/blacklist.conf

tail   /etc/modprobe.d/blacklist.conf

update-initramfs -u  
update-grub2  
```

##### # 사전작업 적용을 위한 재부팅
```bash
reboot  
```

##### # nouveau 가 비활성 화 되었는지 확인.
```bash
lsmod  | grep  nouveau
```

***

##### # Cuda-repo (Cuda 저장소) 설치
```bash
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

dpkg -i  cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

cat /etc/apt/sources.list.d/cuda.list
```

##### # Cuda-repo 에서 설치가능한 패키지 목록 확인.

```bash
apt-get update
apt-cache  search   cuda  
```

##### # 쿠다 샘플 컴파일에 필요한 라이브러리 설치 ( libGLU.so libX11.so libXi.so libXmu.so 등)

```bash
apt-get install -y  libglu1-mesa  libxi-dev  libxmu-dev  libglu1-mesa-dev  libgl1-mesa-glx  libgles2-mesa-dev freeglut3-dev  build-essential  libx11-dev  libxmu-dev   


ln -s /usr/lib/x86_64-linux-gnu/libGLU.so    /usr/lib/libGLU.so
ll    /usr/lib/libGLU.so

ln -s /usr/lib/x86_64-linux-gnu/libGL.so      /usr/lib/libGL.so
ll   /usr/lib/libGL.so

ln -s /usr/lib/x86_64-linux-gnu/libX11.so     /usr/lib/libX11.so
ll  /usr/lib/libX11.so

ln -s /usr/lib/x86_64-linux-gnu/libXi.so        /usr/lib/libXi.so
ll  /usr/lib/libXi.so

ln -s /usr/lib/x86_64-linux-gnu/libXmu.so    /usr/lib/libXmu.so
ll /usr/lib/libXmu.so

```

##### # Cuda 8.0 / 9.0 / 9.1 설치  

```bash
apt-get install -y  cuda-8-0   cuda-9-0  cuda-9-1  
```

##### # Nvidia Driver 동작 확인.  

```bash
ll /usr/local/ | grep cuda

nvidia-smi -L

nvidia-smi    
```

##### # Cuda 9.0 환경변수 Profile 에 추가

```bash
cat << EOF >> /etc/profile
### ADD Cuda 9.0 PATH
export PATH=/usr/local/cuda-9.0/bin:/usr/local/cuda-9.0/include:\$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:/usr/local/cuda/extras/CUPTI/:\$LD_LIBRARY_PATH
export CUDA_HOME=/usr/local/cuda-9.0
export CUDA_INC_DIR=/usr/local/cuda-9.0/include
### add end.
EOF
```

##### # Cuda 8.0 환경변수 Profile 에 추가

```bash
cat << EOF >> /etc/profile
### ADD Cuda 8.0 PATH
export PATH=/usr/local/cuda-8.0/bin:/usr/local/cuda-8.0/include:\$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:/usr/local/cuda/extras/CUPTI/:\$LD_LIBRARY_PATH
export CUDA_HOME=/usr/local/cuda-8.0
export CUDA_INC_DIR=/usr/local/cuda-8.0/include
### add end.
EOF
```


##### # 추가 확인

```bash
tail  /etc/profile
source /etc/profile
source .bashrc
```

#### # Cuda 컴파일러 동작 확인.
```bash
ll /usr/local/ | grep cuda

which nvcc

nvcc -V
```

#### # Cuda 9.0 샘플 컴파일
```bash
cp -r  /usr/local/cuda-9.0/samples/   ~/NVIDIA_CUDA-9.0_Samples
cd ~/NVIDIA_CUDA-9.0_Samples

time make -j$(grep process /proc/cpuinfo | wc -l)

# Finished building CUDA samples  마지막 메세지

```

#### # Cuda 9.0 샘플 테스트
```bash
cd ~

./NVIDIA_CUDA-9.0_Samples/bin/x86_64/linux/release/deviceQuery

./NVIDIA_CUDA-9.0_Samples/bin/x86_64/linux/release/p2pBandwidthLatencyTest

./NVIDIA_CUDA-9.0_Samples/bin/x86_64/linux/release/nbody  --help

./NVIDIA_CUDA-9.0_Samples/bin/x86_64/linux/release/nbody  -benchmark  -numdevices=2 or 3 or 4
```

#### # Cuda 8.0 샘플 컴파일
```bash
grep "nvidia-367" -r /usr/local/cuda-8.0/samples/ -l
sed -i "s/nvidia-367/nvidia-410/g"    `grep "nvidia-367" -r /usr/local/cuda-8.0/samples/ -l`

cp -r  /usr/local/cuda-8.0/samples/   ~/NVIDIA_CUDA-8.0_Samples
cd ~/NVIDIA_CUDA-8.0_Samples

time make -j$(grep process /proc/cpuinfo | wc -l)  

# Finished building CUDA samples  마지막 메세지

```

#### # Cuda 8.0 샘플 테스트
```bash
cd ~

./NVIDIA_CUDA-8.0_Samples/bin/x86_64/linux/release/deviceQuery

./NVIDIA_CUDA-8.0_Samples/bin/x86_64/linux/release/p2pBandwidthLatencyTest

./NVIDIA_CUDA-8.0_Samples/bin/x86_64/linux/release/nbody  --help

./NVIDIA_CUDA-8.0_Samples/bin/x86_64/linux/release/nbody  -benchmark  -numdevices=2 or 3 or 4
```

### # [2. Cudnn install](#목차)

\# https://developer.nvidia.com/rdp/cudnn-download
\# 위 사이트에서 다운로드 (로그인 필요)
\# Cuda9.0 용 7버전 다운 받습니다.  /root/cudnn7 폴더 안에

```bash
cd ~
mkdir /root/cudnn7
cd  /root/cudnn7

pwd
ll

tar xvzf cudnn-9.0-linux-x64-v7.tgz
tar xvzf cudnn-9.0-linux-x64-v7.1.tgz
tar xvzf cudnn-9.0-linux-x64-v7.3.1.20.tgz
tar xvzf cudnn-9.0-linux-x64-v7.4.1.5.tgz

ls -l cuda/include/
ls -l cuda/lib64/

chmod  a+r  cuda/include/*
chmod  a+r  cuda/lib64/*

cp  -rp  cuda/include/cudnn.h  /usr/local/cuda-9.0/include/
cp  -rp  cuda/lib64/libcudnn*  /usr/local/cuda-9.0/lib64/
ls -l /usr/local/cuda-9.0/lib64/libcudnn*

cd ~
```

\# https://developer.nvidia.com/rdp/cudnn-download
\# 위 사이트에서 다운로드 (로그인 필요)
\# Cuda8.0 용  5,6,7 버젼을 모두 다운 받습니다.

```bash
mkdir cudnn
cd cudnn
pwd
ll

# 5,6,7 버젼 순서로 압축 해제 합니다.
tar xvzf cudnn-8.0-linux-x64-v5.0.tgz  
tar xvzf cudnn-8.0-linux-x64-v6.0.tgz   
tar xvzf cudnn-8.0-linux-x64-v7.0.tgz

ls -l cuda/include/
ls -l cuda/lib64/

chmod  a+r  cuda/include/*
chmod a+r  cuda/lib64/*

cp  -rp  cuda/include/cudnn.h  /usr/local/cuda-8.0/include/
cp  -rp  cuda/lib64/libcudnn*  /usr/local/cuda-8.0/lib64/
ls -l /usr/local/cuda-8.0/lib64/libcudnn*

cd ~
```

### # [3. Deep Learning Package Install (python-PIP, tensorflow)](#목차)
```bash
cd ~


python3 -V
which  python3

```

#### # pip Check

```bash

pip3   -V  
which pip3
```

#### # ADD  package install

```bash

pip3   install --upgrade pip


pip3   -V  
which pip3

### pip 와 pip3 버젼 확인 후 pip가 phyhon3 로 바뀌었으면 아래 명령 실행 . (Ubuntu18)
### perl -pi -e 's/python3/python/'   /usr/local/bin/pip
### cat /usr/local/bin/pip


*** pip 설치전에 dns (/etc/resolv.conf) 값이 1.1.1.1 이 맞는지 확인 합니다. (속도 차이가 큽니다.)
cat /etc/resolv.conf

pip3 install  numpy   scipy  nose  matplotlib  pandas  keras


# For CUDA 9.0
pip3 install  --upgrade tensorflow-gpu==1.6

# For CUDA 8.0
pip3 install  --upgrade tensorflow-gpu==1.4

# tensorflow  test  package
cd ~
git clone https://github.com/aymericdamien/TensorFlow-Examples.git
ll  TensorFlow-Examples/


python3      TensorFlow-Examples/examples/1_Introduction/helloworld.py    
python3      TensorFlow-Examples/examples/1_Introduction/basic_operations.py

## 아래 항목도 테스트 필요 (문서에 기록은 남기지 않아도 됨)
python3  TensorFlow-Examples/examples/3_NeuralNetworks/neural_network.py
python3  TensorFlow-Examples/examples/3_NeuralNetworks/gan.py
python3  TensorFlow-Examples/examples/3_NeuralNetworks/dcgan.py
python3  TensorFlow-Examples/examples/5_DataManagement/tensorflow_dataset_api.py

```

### # [4. Deep Learning Package Install 2 (python-PIP, PyTorch)](#목차)
\# 홈페이지 주소 링크 http://pytorch.org/

```bash

#pip3 install
pip3 install torch torchvision

# 테스트

git clone https://github.com/pytorch/examples/

cd ~

python3     examples/regression/main.py

```

### # [5. GPU Burning Test](#목차)

```bash
cd
pwd
git clone https://github.com/wilicc/gpu-burn

cd gpu-burn
make

# ./gpu-burn 60  # 60sec
./gpu_burn $((60 * 1))   # 1min
```

### # [6. GPU Job Scheduler](#목차)

\# 설치문서 분리 - (링크) Install Slurm for Ubuntu 16.04

\# https://github.com/dasandata/LISR/blob/master/Ubuntu16/Slurm/Install_Slurm_Ubuntu16.04.md


### # [7. history 저장 (차후 설치기록 참고용)](#목차)

```bash
# 모든 root 사용자를 로그아웃 한 다음 다시 로그인 하여 작업

logout

history  > dasan_install_history.txt
tail dasan_install_history.txt
```
