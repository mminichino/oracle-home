# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/bin:/home/oracle/oracle-scripts:/home/oracle/ansible-helper
export START_PATH=$PATH

function showoraenv()
{
echo -n "ORACLE_HOME     : $ORACLE_HOME"
if [ -d "$ORACLE_HOME" ]; then echo " (present)"; else echo ""; fi
echo -n "GRID_HOME       : $GRID_HOME"
if [ -d "$ORACLE_HOME" ]; then echo " (present)"; else echo ""; fi
echo -n "ORACLE_SID      : $ORACLE_SID"
RUNNING=$(ps -ef | grep -v grep | grep pmon_$ORACLE_SID)
if [ -n "$RUNNING" ]; then echo " (running)"; else echo ""; fi
echo "PATH            : $PATH"
echo "LD_LIBRARY_PATH : $LD_LIBRARY_PATH"
}

function db11()
{
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export OMS_HOME=/u08/server/oms
export AGENT_HOME=/u08/agent/core/12.1.0.4.0
export GRID_HOME=/u01/app/oracle/product/12.1.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db12()
{
export ORACLE_HOME=/u01/app/oracle/product/12.1.0/dbhome_1
export GRID_HOME=/u01/app/oracle/product/12.1.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function grid121()
{
export ORACLE_HOME=/u01/app/oracle/product/12.1.0/grid_1
export GRID_HOME=/u01/app/oracle/product/12.1.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export ORACLE_SID=+ASM1
}

function db121()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0/dbhome_1
export GRID_HOME=/u01/app/oracle/product/12.1.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db122()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=/opt/app/oracle/product/12.2.0/dbhome_1
export GRID_HOME=/opt/app/grid/product/19.3.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db183()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=/opt/app/oracle/product/18.3.0/dbhome_1
export GRID_HOME=/opt/app/grid/product/19.3.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db193()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=/opt/app/oracle/product/19.3.0/dbhome_1
export GRID_HOME=/opt/app/grid/product/19.3.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function asmenv()
{
export ORACLE_HOME=/opt/app/grid/product/19.3.0/grid_1
export ORACLE_SID=+ASM1
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function sasmenv()
{
export ORACLE_HOME=/opt/app/grid/product/19.3.0/grid_1
export ORACLE_SID=+ASM
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function omsenv()
{
export ORACLE_HOME=$OMS_HOME
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function agentenv()
{
export ORACLE_HOME=$AGENT_HOME
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function omsctl()
{
CUR_DIR_HOLD=$PWD
ulimit -n 4096
cd $OMS_HOME/bin
./emctl $@
cd $CUR_DIR_HOLD
}

function agentctl()
{
CUR_DIR_HOLD=$PWD
ulimit -n 4096
cd $AGENT_HOME/bin
./emctl $@
cd $CUR_DIR_HOLD
}

function setsid()
{
[ -z "$1" ] && echo $ORACLE_SID && return
export ORACLE_SID=$1
}

if [ -z "$PS1" ]; then
   return
fi

echo "Running instances:"
INSTANCELIST=$(ps -ef |grep _pmon_ | grep -v grep | grep -v sed | awk '{print $NF}' | sed -e 's/^ora_pmon_//' -e 's/^asm_pmon_//')

if [ -z "$INSTANCELIST" ]; then
   echo "  None"
else
   for ITEM in $INSTANCELIST; do echo "  $ITEM"; done
fi
echo ""

db193 db19c1
