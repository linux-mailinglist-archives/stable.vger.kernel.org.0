Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A04B882D
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiBPMwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:52:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiBPMvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:51:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D911654B;
        Wed, 16 Feb 2022 04:51:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD17CB81DD2;
        Wed, 16 Feb 2022 12:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48BAC004E1;
        Wed, 16 Feb 2022 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645015866;
        bh=NuQUFm+pFTAsFh6NllqkLthwSyAbwbApmQ8O3mv3Pjw=;
        h=From:To:Cc:Subject:Date:From;
        b=RsKOkWZd4oP8kyKN6KwBsI23RGJFId2+lV1ZUOLyeD/2YtNmho0dJzwyJz6LWr4Fr
         5ikyjKIBnq0i6vYxZtMV6MotwSCE6uMcPJKoRSHJYhAcn3mmK2Ypr6KDsYtEpJV88i
         UMsto4hbsr9+soYN3OFoOAaKZDKdgXCVbuT8sxy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.101
Date:   Wed, 16 Feb 2022 13:50:51 +0100
Message-Id: <16450158513590@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.101 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/arm/omap/omap.txt     |    3 
 Makefile                                                |    2 
 arch/arm/boot/dts/Makefile                              |    1 
 arch/arm/boot/dts/imx23-evk.dts                         |    1 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                     |    5 -
 arch/arm/boot/dts/imx7ulp.dtsi                          |    2 
 arch/arm/boot/dts/meson.dtsi                            |    8 -
 arch/arm/boot/dts/meson8.dtsi                           |   24 ++---
 arch/arm/boot/dts/meson8b.dtsi                          |   24 ++---
 arch/arm/boot/dts/omap3-beagle-ab4.dts                  |   47 +++++++++++
 arch/arm/boot/dts/omap3-beagle.dts                      |   33 -------
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts          |    4 
 arch/arm/mach-socfpga/Kconfig                           |    2 
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi   |    4 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi               |    2 
 arch/powerpc/include/asm/book3s/32/pgtable.h            |    1 
 arch/powerpc/include/asm/book3s/64/pgtable.h            |    2 
 arch/powerpc/include/asm/fixmap.h                       |    6 -
 arch/powerpc/include/asm/nohash/32/pgtable.h            |    1 
 arch/powerpc/include/asm/nohash/64/pgtable.h            |    1 
 arch/powerpc/mm/pgtable.c                               |    9 ++
 arch/riscv/Makefile                                     |    6 +
 arch/x86/events/intel/lbr.c                             |    3 
 arch/x86/kvm/svm/svm.c                                  |   16 +++
 arch/x86/kvm/vmx/evmcs.c                                |    1 
 arch/x86/kvm/vmx/evmcs.h                                |    4 
 arch/x86/kvm/vmx/vmx.c                                  |   25 +++++
 drivers/accessibility/speakup/speakup_dectlk.c          |    1 
 drivers/acpi/arm64/iort.c                               |   14 ++-
 drivers/acpi/ec.c                                       |   10 ++
 drivers/acpi/sleep.c                                    |   15 +--
 drivers/base/power/wakeup.c                             |   41 ++++++++-
 drivers/clocksource/timer-ti-dm-systimer.c              |    2 
 drivers/gpio/gpio-aggregator.c                          |   18 +++-
 drivers/gpio/gpio-sifive.c                              |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                 |    4 
 drivers/gpu/drm/drm_panel_orientation_quirks.c          |   12 ++
 drivers/gpu/drm/panel/panel-simple.c                    |    1 
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c             |    8 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                          |    2 
 drivers/hwmon/dell-smm-hwmon.c                          |   12 +-
 drivers/iommu/iommu.c                                   |    9 +-
 drivers/misc/eeprom/ee1004.c                            |    3 
 drivers/misc/fastrpc.c                                  |    9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                       |    8 +
 drivers/net/bonding/bond_3ad.c                          |    3 
 drivers/net/dsa/bcm_sf2.c                               |    7 +
 drivers/net/dsa/lantiq_gswip.c                          |   14 ++-
 drivers/net/dsa/mv88e6xxx/chip.c                        |   15 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c                  |    4 
 drivers/net/dsa/qca/ar9331.c                            |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c                |    3 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c        |    4 
 drivers/net/ethernet/intel/ice/ice_common.c             |    3 
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h          |    1 
 drivers/net/ethernet/intel/ice/ice_main.c               |   25 ++++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c       |   13 +--
 drivers/net/ethernet/mscc/ocelot.c                      |   11 +-
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c       |    2 
 drivers/net/mdio/mdio-aspeed.c                          |    1 
 drivers/net/phy/marvell.c                               |   17 ++--
 drivers/net/usb/ax88179_178a.c                          |   68 +++++++++-------
 drivers/net/veth.c                                      |   13 +--
 drivers/nvme/host/pci.c                                 |    3 
 drivers/nvme/host/tcp.c                                 |   10 ++
 drivers/phy/ti/phy-j721e-wiz.c                          |    1 
 drivers/phy/xilinx/phy-zynqmp.c                         |   11 +-
 drivers/scsi/lpfc/lpfc.h                                |   13 ++-
 drivers/scsi/lpfc/lpfc_attr.c                           |    4 
 drivers/scsi/lpfc/lpfc_init.c                           |    2 
 drivers/scsi/lpfc/lpfc_sli.c                            |    8 +
 drivers/scsi/myrs.c                                     |    3 
 drivers/scsi/pm8001/pm80xx_hwi.c                        |   16 +++
 drivers/scsi/pm8001/pm80xx_hwi.h                        |    6 +
 drivers/scsi/qedf/qedf_io.c                             |    1 
 drivers/scsi/qedf/qedf_main.c                           |    1 
 drivers/scsi/ufs/ufshcd-pltfrm.c                        |    7 +
 drivers/scsi/ufs/ufshci.h                               |    3 
 drivers/staging/fbtft/fbtft.h                           |    5 -
 drivers/target/iscsi/iscsi_target_tpg.c                 |    3 
 drivers/tty/n_tty.c                                     |    4 
 drivers/tty/vt/vt_ioctl.c                               |    3 
 drivers/usb/common/ulpi.c                               |   10 +-
 drivers/usb/dwc2/gadget.c                               |    2 
 drivers/usb/dwc3/gadget.c                               |   13 +++
 drivers/usb/gadget/composite.c                          |    3 
 drivers/usb/gadget/function/f_fs.c                      |   56 +++++++++----
 drivers/usb/gadget/function/f_uac2.c                    |    4 
 drivers/usb/gadget/function/rndis.c                     |    9 +-
 drivers/usb/gadget/legacy/raw_gadget.c                  |    2 
 drivers/usb/gadget/udc/renesas_usb3.c                   |    2 
 drivers/usb/serial/ch341.c                              |    1 
 drivers/usb/serial/cp210x.c                             |    2 
 drivers/usb/serial/ftdi_sio.c                           |    3 
 drivers/usb/serial/ftdi_sio_ids.h                       |    3 
 drivers/usb/serial/option.c                             |    2 
 fs/nfs/callback.h                                       |    2 
 fs/nfs/callback_proc.c                                  |    2 
 fs/nfs/callback_xdr.c                                   |   18 ++--
 fs/nfs/client.c                                         |    2 
 fs/nfs/dir.c                                            |   20 ++--
 fs/nfs/nfs4_fs.h                                        |    3 
 fs/nfs/nfs4client.c                                     |    5 -
 fs/nfs/nfs4namespace.c                                  |   19 ++--
 fs/nfs/nfs4proc.c                                       |   18 ++--
 fs/nfs/nfs4state.c                                      |    3 
 fs/nfs/nfs4xdr.c                                        |    9 --
 fs/nfsd/nfs3proc.c                                      |    5 +
 fs/nfsd/nfs4proc.c                                      |    5 -
 fs/nfsd/trace.h                                         |   14 +--
 include/linux/nfs_fs.h                                  |    4 
 include/linux/suspend.h                                 |   15 ---
 include/net/dst_metadata.h                              |   14 +++
 include/uapi/linux/netfilter/nf_conntrack_common.h      |    2 
 kernel/events/core.c                                    |   16 ++-
 kernel/power/main.c                                     |    5 -
 kernel/power/process.c                                  |    2 
 kernel/power/snapshot.c                                 |   21 +---
 kernel/power/suspend.c                                  |    2 
 kernel/trace/trace_events_hist.c                        |    3 
 net/can/isotp.c                                         |   27 ++++--
 net/ipv4/ipmr.c                                         |    2 
 net/ipv6/ip6mr.c                                        |    2 
 net/netfilter/nf_conntrack_netlink.c                    |    3 
 net/sched/sch_api.c                                     |    2 
 net/tipc/name_distr.c                                   |    2 
 scripts/Makefile.extrawarn                              |    1 
 security/integrity/ima/ima_fs.c                         |    2 
 security/integrity/ima/ima_policy.c                     |    8 +
 security/integrity/ima/ima_template.c                   |   10 +-
 security/integrity/integrity_audit.c                    |    2 
 virt/kvm/eventfd.c                                      |    8 -
 133 files changed, 766 insertions(+), 355 deletions(-)

Adam Ford (1):
      usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

Alexander Stein (1):
      arm64: dts: imx8mq: fix lcdif port node

Amadeusz Sławiński (1):
      PM: hibernate: Remove register_nosave_region_late()

Amelie Delaunay (1):
      usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

Andi Kleen (1):
      x86/perf: Avoid warning for Arch LBR without XSAVE

Antoine Tenart (2):
      net: do not keep the dst cache when uncloning an skb dst and its metadata
      net: fix a memleak when uncloning an skb dst and its metadata

Armin Wolf (1):
      hwmon: (dell-smm) Speed up setting of fan speed

Aurelien Jarno (1):
      riscv: fix build with binutils 2.38

Brian Norris (1):
      drm/rockchip: vop: Correct RK3399 VOP register fields

Cameron Williams (1):
      USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Christoph Niedermaier (1):
      drm/panel: simple: Assign data from panel_dpi_probe() correctly

Christophe Leroy (1):
      powerpc/fixmap: Fix VM debug warning on unmap

Chuck Lever (2):
      NFSD: Clamp WRITE offsets
      NFSD: Fix offset type in I/O trace points

Colin Foster (1):
      net: mscc: ocelot: fix mutex lock error during ethtool stats read

Dan Carpenter (1):
      ice: fix an error code in ice_cfg_phy_fec()

Dave Stevenson (1):
      drm/vc4: hdmi: Allow DBLCLK modes even if horz timing is odd.

Dongjin Kim (1):
      arm64: dts: meson-g12b-odroid-n2: fix typo 'dio2133'

Eric Dumazet (2):
      ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
      veth: fix races around rq->rx_notify_masked

Fabio Estevam (2):
      ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
      ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Fabrice Gasnier (1):
      usb: dwc2: drd: fix soft connect when gadget is unconfigured

Florian Westphal (1):
      netfilter: ctnetlink: disable helper autoassign

Geert Uytterhoeven (1):
      gpio: aggregator: Fix calling into sleeping GPIO controllers

Greg Kroah-Hartman (3):
      Revert "usb: dwc2: drd: fix soft connect when gadget is unconfigured"
      usb: gadget: rndis: check size of RNDIS_MSG_SET command
      Linux 5.10.101

Hou Wenlong (1):
      KVM: eventfd: Fix false positive RCU usage warning

Huacai Chen (1):
      drm/amdgpu: Set a suitable dev_info.gart_page_size

Jakob Koschel (2):
      vt_ioctl: fix array_index_nospec in vt_setactivate
      vt_ioctl: add array_index_nospec to VT_ACTIVATE

James Clark (1):
      perf: Always wake the parent event

James Smart (2):
      scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled
      scsi: lpfc: Reduce log messages seen after firmware download

Jann Horn (2):
      net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup
      usb: raw-gadget: fix handling of dual-direction-capable endpoints

Jesse Brandeburg (1):
      ice: fix IPIP and SIT TSO offload

Jiasheng Jiang (1):
      mmc: sdhci-of-esdhc: Check for error num after setting mask

Jisheng Zhang (1):
      net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Joel Stanley (1):
      net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE

Johan Hovold (2):
      USB: serial: cp210x: add NCR Retail IO box id
      USB: serial: cp210x: add CPI Bulk Coin Recycler id

John Garry (1):
      scsi: pm8001: Fix bogus FW crash for maxcpus=1

Jon Maloy (1):
      tipc: rate limit warning for received illegal binding update

Jonas Malaco (1):
      eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX

Kishon Vijay Abraham I (1):
      phy: ti: Fix missing sentinel for clk_div_table

Kiwoong Kim (1):
      scsi: ufs: Treat link loss as fatal error

Krzysztof Kozlowski (1):
      ARM: socfpga: fix missing RESET_CONTROLLER

Linus Walleij (1):
      ARM: dts: Fix boot regression on Skomer

Louis Peens (1):
      nfp: flower: fix ida_idx not being released

Mahesh Bandewar (1):
      bonding: pair enable_port with slave_arr_updates

Martin Blumenstingl (3):
      ARM: dts: meson: Fix the UART compatible strings
      ARM: dts: meson8: Fix the UART device-tree schema validation
      ARM: dts: meson8b: Fix the UART device-tree schema validation

Mathias Krause (1):
      misc: fastrpc: avoid double fput() on failed usercopy

Nathan Chancellor (1):
      Makefile.extrawarn: Move -Wunaligned-access to W=1

NeilBrown (1):
      NFS: change nfs_access_get_cached to only report the mask

Niklas Cassel (1):
      gpio: sifive: use the correct register to read output values

Olga Kornievskaia (4):
      NFSv4 only print the label when its queried
      NFSv4 remove zero number of fs_locations entries error check
      NFSv4 expose nfs_parse_server_name function
      NFSv4 handle port presence in fs_location server string

Oliver Hartkopp (2):
      can: isotp: fix potential CAN frame reception race in isotp_rcv()
      can: isotp: fix error path in isotp_sendmsg() to unlock wait queue

Pavel Hofman (1):
      usb: gadget: f_uac2: Define specific wTerminalType

Pavel Parkhomenko (2):
      net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
      net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs

Pawel Dembicki (1):
      USB: serial: option: add ZTE MF286D modem

Rafael J. Wysocki (2):
      PM: s2idle: ACPI: Fix wakeup interrupts handling
      ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE

Raju Rangoju (1):
      net: amd-xgbe: disable interrupts during pci removal

Raymond Jay Golo (1):
      drm: panel-orientation-quirks: Add quirk for the 1Netbook OneXPlayer

Rob Herring (1):
      ARM: dts: imx7ulp: Fix 'assigned-clocks-parents' typo

Robert Hancock (1):
      phy: xilinx: zynqmp: Fix bus width setting for SGMII

Robert-Ionut Alexa (1):
      dpaa2-eth: unregister the netdev before disconnecting from the PHY

Roberto Sassu (1):
      ima: Allow template selection with ima_template[_fmt]= after ima_hash=

Robin Murphy (1):
      ACPI/IORT: Check node revision for PMCG resources

Sagi Grimberg (1):
      nvme-tcp: fix bogus request completion when failing to send AER

Samuel Mendoza-Jonas (1):
      ixgbevf: Require large buffers for build_skb on 82599VF

Samuel Thibault (1):
      speakup-dectlk: Restore pitch setting

Saurav Kashyap (2):
      scsi: qedf: Add stag_work to all the vports
      scsi: qedf: Fix refcount issue when LOGO is received during TMF

Sean Anderson (2):
      usb: ulpi: Move of_node_put to ulpi_dev_release
      usb: ulpi: Call of_node_put correctly

Sean Christopherson (2):
      KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode
      KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS blocking shadow

Song Liu (1):
      perf: Fix list corruption in perf_cgroup_switch()

Stefan Berger (2):
      ima: Remove ima_policy file before directory
      ima: Do not print policy rule with inactive LSM labels

Stephan Brunner (1):
      USB: serial: ch341: add support for GW Instek USB2.0-Serial devices

Szymon Heidrich (1):
      USB: gadget: validate interface OS descriptor requests

TATSUKAWA KOSUKE (立川 江介) (1):
      n_tty: wake up poll(POLLRDNORM) on receiving data

Tom Zanussi (1):
      tracing: Propagate is_signed to expression

Tong Zhang (1):
      scsi: myrs: Fix crash in error case

Tony Lindgren (1):
      ARM: dts: Fix timer regression for beagleboard revision c

Trond Myklebust (2):
      NFS: Fix initialisation of nfs_client cl_flags field
      NFSv4.1: Fix uninitialised variable in devicenotify

Udipto Goswami (2):
      usb: f_fs: Fix use-after-free for epfile
      usb: dwc3: gadget: Prevent core from processing stale TRBs

Uwe Kleine-König (1):
      staging: fbtft: Fix error path in fbtft_driver_module_init()

Victor Nogueira (1):
      net: sched: Clarify error message when qdisc kind is unknown

Vijayanand Jitta (1):
      iommu: Fix potential use-after-free during probe

Vitaly Kuznetsov (2):
      KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
      KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS

Vladimir Oltean (6):
      net: dsa: mv88e6xxx: don't use devres for mdiobus
      net: dsa: ar9331: register the mdiobus under devres
      net: dsa: bcm_sf2: don't use devres for mdiobus
      net: dsa: felix: don't use devres for mdiobus
      net: dsa: lantiq_gswip: don't use devres for mdiobus
      net: dsa: mv88e6xxx: fix use-after-free in mv88e6xxx_mdios_unregister

Wu Zheng (1):
      nvme-pci: add the IGNORE_DEV_SUBNQN quirk for Intel P4500/P4600 SSDs

Xiaoke Wang (3):
      integrity: check the return value of audit_log_start()
      nfs: nfs4clinet: check the return value of kstrdup()
      scsi: ufs: ufshcd-pltfrm: Check the return value of devm_kstrdup()

ZouMingzhe (1):
      scsi: target: iscsi: Make sure the np under each tpg is unique

