## SWE3025

We will use a Docker image for the first homework assignment
(If you have not used Docker before, it would be a good chance to get used to it). 
Docker offers a platform to deliver varying software in `containers`. 
A container is an isolated process running on the host, 
communicating with another container via a well-defined channel. 
It differs from VM (virtual machine) in that Docker does not 
consume much hardware resources (e.g., no guest OS), 
enabling one to efficiently run services efficiently.


### Docker Installation

For Windows WSL-Ubuntu,
there are a series of phases to install Docker for WSL appropriately.
For more information (i.e., confirming pre-requisites), you may want to visit:
https://altis.com.au/installing-docker-on-ubuntu-bash-for-windows/
```
$ sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu (lsb_release -cs) stable"
$ sudo apt update
$ sudo apt-get install docker-ce
$ sudo usermod -aG docker [user_id]
```
Note that TCP endpoint is turned off by default at the latest version of Docker.
To activate it, right-click the Docker icon in your taskbar and choose Settings, 
check the box of `Expose daemon on tcp://localhost:2375 without TLS`.

Or if you have difficulty in installing Docker in the Windows WSL environment, 
it might be simple to install it in Ubuntu. 
The command of *usermod* allows one to run docker without *sudo*.
```
$ curl -fsSL https://get.docker.com/ | sudo sh
$ sudo usermod -aG docker [user_id]
```


### Build the image

With the given `Dockerfile` in the current directory, build your own image. 
This will take a while.
```
$ docker build -t swe3025 .  
[+] Building 112.6s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                                          0.0s
 => => transferring dockerfile: 579B                                                                                          0.0s
 => [internal] load .dockerignore                                                                                             0.0s
 => => transferring context: 2B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                               2.5s
 => [1/6] FROM docker.io/library/ubuntu:18.04@sha256:8aa9c2798215f99544d1ce7439ea9c3a6dfd82de607da1cec3a8a2fae005931b         1.1s
 => => resolve docker.io/library/ubuntu:18.04@sha256:8aa9c2798215f99544d1ce7439ea9c3a6dfd82de607da1cec3a8a2fae005931b         0.0s
 => => sha256:0c5227665c11379f79e9da3d3e4f1724f9316b87d259ac0131628ca1b923a392 25.69MB / 25.69MB                              0.5s
 => => sha256:8aa9c2798215f99544d1ce7439ea9c3a6dfd82de607da1cec3a8a2fae005931b 1.33kB / 1.33kB                                0.0s
 => => sha256:0779371f96205678dbcaa3ef499be2e5f262c8b09aadc11754bf3daf9f35e03e 424B / 424B                                    0.0s
 => => sha256:3941d3b032a8168d53508410a67baad120a563df67a7959565a30a1cb2114731 2.30kB / 2.30kB                                0.0s
 => => extracting sha256:0c5227665c11379f79e9da3d3e4f1724f9316b87d259ac0131628ca1b923a392                                     0.5s
 => [2/6] RUN apt-get -y update && apt-get install -y     git     texinfo     byacc     flex     bison     automake     au  100.9s
 => [3/6] RUN pip install pyelftools                                                                                          1.9s
 => [4/6] RUN git clone https://github.com/longld/peda.git ~/peda                                                             1.4s
 => [5/6] RUN echo "source ~/peda/peda.py" >> ~/.gdbinit                                                                      0.6s
 => [6/6] RUN echo "[SWE3025] Your docker image is ready!"                                                                    0.6s
 => exporting to image                                                                                                        3.6s
 => => exporting layers                                                                                                       3.6s
 => => writing image sha256:db877af0e119f26ea186ec1bd203cc0aff948ca48e1493233ae290211662d6a3                                  0.0s
 => => naming to docker.io/library/swe3025                                                                                    0.0s
```

Now you see your own `swe3025` docker image. The image ID looks different in your machine.
```
$ docker images
REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
swe3025                  latest    db877af0e119   38 seconds ago   700MB
```

Once complete, run your container for the first time.
Here `-it` option represents `interactive` mode using `/bin/bash`. 
You should be able to see the container id (e.g., 9622fd5a60f8) when running the container.
By typing `exit` or with a `CTRL+D` key, you can exit the container.
However, all changes made will be gone because an `--rm` option 
will remove all jobs you've done upon exiting the container.
```
$ docker run --rm -it swe3025 /bin/bash
hw1@9622fd5a60f8:/$ exit
```

More practically, let us run our docker image without the `--rm` option.
Now you will see a new container id (e.g., d8a574ada8a3).
We have added a new user `hw1` and a default password of `swe3025hw!`; and `sudo` has been enabled.
Note that we will turn off ASLR (i.e., randomize_va_space).
```
$ docker run --privileged -it swe3025 /bin/bash
hw1@47d66468dcc4:/$ cd ~
hw1@47d66468dcc4:~$ sudo sysctl -w kernel.randomize_va_space=0
hw1@47d66468dcc4:~$ sudo cat /proc/sys/kernel/randomize_va_space
0
hw1@47d66468dcc4:~$ ls -l
total 4
drwxr-xr-x 4 root root 4096 Mar 30 00:58 peda
```

If you want to keep running your container when getting out of the shell,
press `CTRL + p + q` in order (one by one). You can check that the docker image is 
still running with `docker ps`.
```
$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
47d66468dcc4   swe3025   "/bin/bash"   13 minutes ago   Up 13 minutes             relaxed_greider
```

If you want to go back to the container, use `docker exec` as follow (container id should be given). 
Your changes will be valid as long as the container is running.
```
$ docker exec -it 47d66468dcc4 bash
hw1@47d66468dcc4:/$ cd ~
hw1@47d66468dcc4:~$ git clone https://github.com/SecAI-Lab/SWE3025/
hw1@47d66468dcc4:~$ cd SWE3025
hw1@47d66468dcc4:~/SWE3025$ vi vul.c
hw1@47d66468dcc4:~/SWE3025$ gcc -fno-stack-protector -z execstack -no-pie -o vul vul.c
hw1@47d66468dcc4:~/SWE3025$ ls -l
total 16
drwxr-xr-x 4 root root 4096 Mar 30 00:58 peda
-rwxr-xr-x 1 root root 7444 Apr  6 13:20 vul
-rw-r--r-- 1 root root  340 Apr  6 13:19 vul.c
root@d8a574ada8a3:~$ file vul
vul: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[sha1]=4aa2fbd352ab5a6982e5238fca333f5b8021f56b, not stripped
```

You can find general command line references for Docker here:
https://docs.docker.com/engine/reference/commandline/docker/



### Practice your own exploit with a buffer overflow

Recall `vul.c` in class. The small program contains a vulnerability (i.e., buffer overflow).
In this setting, we assume that both stack canary and NX do not exist just like back in 90's.
It is noted that the PEDA plugin has been installed/enabled for gdb by default.

```
// gcc -fno-stack-protector -z execstack -no-pie -o vul vul.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void vul(char* name) {
        char buf[64] = {};
        strcpy(buf, name);
}

int main(int argc, char* argv[]) {
        if (argc < 2) {
                printf ("Usage: %s [Your name]\n", argv[0]);
                exit(-1);
        }

        vul(argv[1]);
        return 0;
}
```

You may practice yourself by writing an exploit (named `exp.py`) in python 
to leverage the above vulnerability to *obtain a shellcode*.
Choose a working shellcode for `x86-64` like `http://shell-storm.org/shellcode/files/shellcode-806.html`
Note that the shellcode in class was for `x86`, thus you should use another for `x86-64`!


### Homework Assignments
* Analyze two programs `find_key1` and `find_key2`
* You must submit a single zipped file via iCampus. The submission file name should be your student ID
with the file extension of .zip.
* The submission must contain four files: a single PDF report that answers all questions with proper
descriptions, and three python scripts with the file extension of .py. The script name should be exp1.py
that produces payload1, exp2.py that produces payload2, and ret2libc.py that emits payload3.
* Each script will be run with python3.7 or higher version for evaluation. Thus, there is no need to submit
payload data. Note that any answer without well-description may be degraded.
* The source of the executable binaries is purposefully unavailable.
* The deadline for the homework is midnight (11:59 PM) on Apr. 9th (Friday), 2023.
* Last but not least, cheating (copying, retyping, outsourcing, submitting copies of others) will bring about
failing this course.

