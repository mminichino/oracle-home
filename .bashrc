# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/bin:/home/oracle/oracle-scripts:/home/oracle/ansible-helper
export START_PATH=$PATH
export HOME_PREFIX=/opt/app/oracle/product
export GRID_PREFIX=/opt/app/oracle/product
export DB_DIR=dbhome_1
export GRID_DIR=grid_1
export GRID_HOME=$GRID_PREFIX/19.3.0/$GRID_DIR

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
export ORACLE_HOME=$HOME_PREFIX/11.2.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db12()
{
export ORACLE_HOME=$HOME_PREFIX/12.1.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function grid121()
{
export ORACLE_HOME=$HOME_PREFIX/12.1.0/grid_1
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export ORACLE_SID=+ASM1
}

function db121()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=$HOME_PREFIX/12.1.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db122()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=$HOME_PREFIX/12.2.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db183()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=$HOME_PREFIX/18.3.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function db193()
{
[ -z "$1" ] && echo $ORACLE_SID
[ -n "$1" ] && export ORACLE_SID=$1
export ORACLE_HOME=$HOME_PREFIX/19.3.0/$DB_DIR
export PATH=$START_PATH:$ORACLE_HOME/bin:$GRID_HOME/bin:$ORACLE_HOME/OPatch
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
}

function asmenv()
{
export ORACLE_HOME=$GRID_HOME
export ORACLE_SID=+ASM1
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function sasmenv()
{
export ORACLE_HOME=$GRID_HOME
export ORACLE_SID=+ASM
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
}

function omsenv()
{
export OMS_HOME=$1
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$OMS_HOME/bin
}

function agentenv()
{
export AGENT_HOME=$1
export PATH=$START_PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$AGENT_HOME/bin
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

function runlist()
{
echo "Running instances:"
INSTANCELIST=$(ps -ef |grep _pmon_ | grep -v grep | grep -v sed | awk '{print $NF}' | sed -e 's/^ora_pmon_//' -e 's/^asm_pmon_//')

if [ -z "$INSTANCELIST" ]; then
   echo "  None"
else
   for ITEM in $INSTANCELIST
   do
      echo "  $ITEM"
      if [ -n "$(echo $ITEM | sed -e 's/^+.*$//')" ]; then
         export ORACLE_SID=$ITEM
      fi
   done
fi
}

# Check for interactive shell
if [ -z "$PS1" ]; then
   return
fi

echo ""
runlist

[ -z "$ORACLE_SID" ] && ORACLE_SID=prod

if [ -f /etc/oratab ]; then
   SID_HOME=$(grep ^$ORACLE_SID /etc/oratab | cut -f2 -d:)
   if [ -n "$SID_HOME" ]; then
      export HOME_PREFIX=$(dirname $(dirname $SID_HOME))
      export ORACLE_HOME=$SID_HOME
   fi
fi

HOST_GRID_HOME=$(dirname $(dirname $(ps -ef |grep evmd.bin | grep -v grep | awk '{print $NF}')2>/dev/null)2>/dev/null)
[ -n "$HOST_GRID_HOME" ] && export GRID_HOME=$HOST_GRID_HOME

db193 $ORACLE_SID

echo ""
showoraenv
echo ""
