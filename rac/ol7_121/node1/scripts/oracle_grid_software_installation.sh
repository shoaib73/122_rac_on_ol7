. /vagrant_config/install.env

echo "******************************************************************************"
echo "Unzip grid software." `date`
echo "******************************************************************************"
mkdir -p ${SOFTWARE_DIR}
cd ${SOFTWARE_DIR}
unzip -oq "/vagrant_software/${GRID_SOFTWARE}"
cd grid

# Optional cluster verification.
#${GRID_HOME}/runcluvfy.sh stage -pre crsinst -n "${NODE1_HOSTNAME},${NODE2_HOSTNAME}"

echo "******************************************************************************"
echo "Do grid software-only installation." `date`
echo "******************************************************************************"
./runInstaller -ignorePrereq -waitforcompletion -silent \
        -responseFile ${SOFTWARE_DIR}/grid/response/grid_install.rsp \
        SELECTED_LANGUAGES=${ORA_LANGUAGES} \
        oracle.install.option=CRS_CONFIG \
        ORACLE_BASE=${ORACLE_BASE} \
        ORACLE_HOME=${GRID_HOME} \
        oracle.install.asm.OSDBA=dba \
        oracle.install.asm.OSASM=dba \
        oracle.install.crs.config.gpnp.scanName=${SCAN_NAME} \
        oracle.install.crs.config.gpnp.scanPort=${SCAN_PORT} \
        oracle.install.crs.config.clusterName=${CLUSTER_NAME} \
        oracle.install.crs.config.gpnp.configureGNS=false \
        oracle.install.crs.config.clusterNodes=${NODE1_FQ_HOSTNAME}:${NODE1_FQ_VIPNAME},${NODE2_FQ_HOSTNAME}:${NODE2_FQ_VIPNAME} \
        oracle.install.crs.config.networkInterfaceList=${NET_DEVICE1}:${PUBLIC_SUBNET}:1,${NET_DEVICE2}:${PRIVATE_SUBNET}:2 \
        oracle.install.crs.config.useIPMI=false \
        oracle.install.crs.config.storageOption=ASM_STORAGE \
        oracle.install.asm.SYSASMPassword=${SYS_PASSWORD} \
        oracle.install.asm.diskGroup.name=DATA \
        oracle.install.asm.diskGroup.redundancy=EXTERNAL \
        oracle.install.asm.diskGroup.disksWithFailureGroupNames=/dev/oracleasm/asm-disk1,,/dev/oracleasm/asm-disk2,,/dev/oracleasm/asm-disk3,,/dev/oracleasm/asm-disk4, \
        oracle.install.asm.diskGroup.disks=/dev/oracleasm/asm-disk1,/dev/oracleasm/asm-disk2,/dev/oracleasm/asm-disk3,/dev/oracleasm/asm-disk4 \
        oracle.install.asm.diskGroup.diskDiscoveryString=/dev/oracleasm/* \
        oracle.install.asm.monitorPassword=${SYS_PASSWORD}

scp ${GRID_HOME}/cv/rpm/cvuqdisk-1.0.9-1.rpm oracle@${NODE2_HOSTNAME}:/tmp
