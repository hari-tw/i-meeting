{\rtf1\ansi\ansicpg1252\cocoartf1187
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720

\f0\fs26 \cf0 #!/bin/sh\
\
set -e\
set -u\
\
export DYLD_ROOT_PATH="$1"\
export IPHONE_SIMULATOR_ROOT="$1"\
export CFFIXED_USER_HOME="$2"\
\
"$IPHONE_SIMULATOR_ROOT"/usr/libexec/securityd}