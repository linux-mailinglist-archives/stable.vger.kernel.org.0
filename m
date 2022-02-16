Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CC54B881E
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiBPMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:51:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiBPMvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:51:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A451F2A520A;
        Wed, 16 Feb 2022 04:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9A3CB81EDB;
        Wed, 16 Feb 2022 12:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC64FC004E1;
        Wed, 16 Feb 2022 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645015853;
        bh=6YohNW+zR04oxarjAL64pQuCAKOlHpJ34l5jk4vY0pg=;
        h=From:To:Cc:Subject:Date:From;
        b=g/YGOX/PIEubu6HOIICNtyRs1BSdCA8VdnbIhhx/Oz9hIV+vgXoeG5mT747QPmhbG
         2OIh34EbyfP0J3T6xFzfU82p2pC0/Et25fG1UxiZH3AwUXlt+7wcoFB8fLDSCMZRi3
         ROnI6M50x9f6evFdnB0oLllwJrYgbGjHh3HSWZlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.180
Date:   Wed, 16 Feb 2022 13:50:46 +0100
Message-Id: <164501584693121@kroah.com>
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

I'm announcing the release of the 5.4.180 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/kernel.rst             |   21 ++++
 Makefile                                                |    2 
 arch/arm/boot/dts/imx23-evk.dts                         |    1 
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                     |    5 -
 arch/arm/boot/dts/meson.dtsi                            |    8 -
 arch/arm/mach-socfpga/Kconfig                           |    2 
 arch/riscv/Makefile                                     |    6 +
 arch/x86/kvm/vmx/evmcs.h                                |    4 
 drivers/acpi/arm64/iort.c                               |   14 ++-
 drivers/acpi/ec.c                                       |   10 ++
 drivers/acpi/sleep.c                                    |   15 +--
 drivers/base/power/wakeup.c                             |   41 ++++++++-
 drivers/gpu/drm/drm_panel_orientation_quirks.c          |   12 ++
 drivers/hwmon/dell-smm-hwmon.c                          |   12 +-
 drivers/misc/eeprom/ee1004.c                            |    3 
 drivers/misc/fastrpc.c                                  |    9 +-
 drivers/mmc/host/sdhci-of-esdhc.c                       |    8 +
 drivers/net/bonding/bond_3ad.c                          |    3 
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c                |    3 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c       |   13 +--
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c |   12 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c       |    2 
 drivers/net/phy/marvell.c                               |   17 ++--
 drivers/net/phy/mdio-aspeed.c                           |    1 
 drivers/net/usb/ax88179_178a.c                          |   68 +++++++++-------
 drivers/net/veth.c                                      |   13 +--
 drivers/nvme/host/multipath.c                           |   12 +-
 drivers/nvme/host/tcp.c                                 |   10 ++
 drivers/scsi/lpfc/lpfc.h                                |   13 ++-
 drivers/scsi/lpfc/lpfc_attr.c                           |    4 
 drivers/scsi/myrs.c                                     |    3 
 drivers/scsi/qedf/qedf_io.c                             |    1 
 drivers/staging/fbtft/fbtft.h                           |    5 -
 drivers/target/iscsi/iscsi_target_tpg.c                 |    3 
 drivers/tty/n_tty.c                                     |    4 
 drivers/tty/vt/vt_ioctl.c                               |    5 -
 drivers/usb/common/ulpi.c                               |   10 +-
 drivers/usb/dwc2/gadget.c                               |    2 
 drivers/usb/dwc3/gadget.c                               |   13 +++
 drivers/usb/gadget/composite.c                          |    3 
 drivers/usb/gadget/function/f_fs.c                      |   56 +++++++++----
 drivers/usb/gadget/function/f_uac2.c                    |    4 
 drivers/usb/gadget/function/rndis.c                     |    9 +-
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
 fs/nfs/nfs4_fs.h                                        |    3 
 fs/nfs/nfs4client.c                                     |    5 -
 fs/nfs/nfs4namespace.c                                  |    4 
 fs/nfs/nfs4state.c                                      |    3 
 fs/nfs/nfs4xdr.c                                        |    9 --
 fs/nfsd/nfs3proc.c                                      |    5 +
 fs/nfsd/nfs4proc.c                                      |    5 -
 fs/nfsd/trace.h                                         |   14 +--
 include/linux/suspend.h                                 |   15 ---
 include/net/dst_metadata.h                              |   14 +++
 init/Kconfig                                            |   10 ++
 kernel/bpf/syscall.c                                    |    3 
 kernel/events/core.c                                    |    4 
 kernel/power/main.c                                     |    5 -
 kernel/power/process.c                                  |    2 
 kernel/power/snapshot.c                                 |   21 +---
 kernel/power/suspend.c                                  |    2 
 kernel/seccomp.c                                        |   10 ++
 kernel/sysctl.c                                         |   29 +++++-
 net/bridge/br_device.c                                  |    6 -
 net/ipv4/ipmr.c                                         |    2 
 net/ipv6/ip6mr.c                                        |    2 
 net/sched/sch_api.c                                     |    2 
 net/tipc/name_distr.c                                   |    2 
 security/integrity/ima/ima_fs.c                         |    2 
 security/integrity/ima/ima_policy.c                     |    8 +
 security/integrity/ima/ima_template.c                   |   10 +-
 security/integrity/integrity_audit.c                    |    2 
 tools/perf/util/probe-event.c                           |    3 
 82 files changed, 495 insertions(+), 206 deletions(-)

Adam Ford (1):
      usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

Amadeusz Sławiński (1):
      PM: hibernate: Remove register_nosave_region_late()

Amelie Delaunay (1):
      usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

Antoine Tenart (2):
      net: do not keep the dst cache when uncloning an skb dst and its metadata
      net: fix a memleak when uncloning an skb dst and its metadata

Armin Wolf (1):
      hwmon: (dell-smm) Speed up setting of fan speed

Aurelien Jarno (1):
      riscv: fix build with binutils 2.38

Cameron Williams (1):
      USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Chuck Lever (2):
      NFSD: Clamp WRITE offsets
      NFSD: Fix offset type in I/O trace points

Daniel Borkmann (1):
      bpf: Add kconfig knob for disabling unpriv bpf by default

Eric Dumazet (2):
      ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path
      veth: fix races around rq->rx_notify_masked

Fabio Estevam (2):
      ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
      ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Greg Kroah-Hartman (2):
      usb: gadget: rndis: check size of RNDIS_MSG_SET command
      Linux 5.4.180

Jakob Koschel (2):
      vt_ioctl: fix array_index_nospec in vt_setactivate
      vt_ioctl: add array_index_nospec to VT_ACTIVATE

James Smart (1):
      scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled

Jann Horn (1):
      net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Jiasheng Jiang (1):
      mmc: sdhci-of-esdhc: Check for error num after setting mask

Jisheng Zhang (1):
      net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Joel Stanley (1):
      net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE

Johan Hovold (2):
      USB: serial: cp210x: add NCR Retail IO box id
      USB: serial: cp210x: add CPI Bulk Coin Recycler id

Jon Maloy (1):
      tipc: rate limit warning for received illegal binding update

Jonas Malaco (1):
      eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX

Kees Cook (1):
      seccomp: Invalidate seccomp mode to catch death failures

Krzysztof Kozlowski (1):
      ARM: socfpga: fix missing RESET_CONTROLLER

Louis Peens (1):
      nfp: flower: fix ida_idx not being released

Mahesh Bandewar (1):
      bonding: pair enable_port with slave_arr_updates

Martin Blumenstingl (1):
      ARM: dts: meson: Fix the UART compatible strings

Mathias Krause (1):
      misc: fastrpc: avoid double fput() on failed usercopy

Nikolay Aleksandrov (1):
      net: bridge: fix stale eth hdr pointer in br_dev_xmit

Olga Kornievskaia (3):
      NFSv4 only print the label when its queried
      NFSv4 remove zero number of fs_locations entries error check
      NFSv4 expose nfs_parse_server_name function

Pavel Hofman (1):
      usb: gadget: f_uac2: Define specific wTerminalType

Pavel Parkhomenko (2):
      net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs
      net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs

Pawel Dembicki (1):
      USB: serial: option: add ZTE MF286D modem

Prabhath Sajeepa (1):
      nvme: Fix parsing of ANA log page

Rafael J. Wysocki (2):
      PM: s2idle: ACPI: Fix wakeup interrupts handling
      ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE

Raju Rangoju (1):
      net: amd-xgbe: disable interrupts during pci removal

Raymond Jay Golo (1):
      drm: panel-orientation-quirks: Add quirk for the 1Netbook OneXPlayer

Roberto Sassu (1):
      ima: Allow template selection with ima_template[_fmt]= after ima_hash=

Robin Murphy (1):
      ACPI/IORT: Check node revision for PMCG resources

Sagi Grimberg (1):
      nvme-tcp: fix bogus request completion when failing to send AER

Samuel Mendoza-Jonas (1):
      ixgbevf: Require large buffers for build_skb on 82599VF

Saurav Kashyap (1):
      scsi: qedf: Fix refcount issue when LOGO is received during TMF

Sean Anderson (2):
      usb: ulpi: Move of_node_put to ulpi_dev_release
      usb: ulpi: Call of_node_put correctly

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

Tong Zhang (1):
      scsi: myrs: Fix crash in error case

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

Vitaly Kuznetsov (1):
      KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER

Xiaoke Wang (2):
      integrity: check the return value of audit_log_start()
      nfs: nfs4clinet: check the return value of kstrdup()

Zechuan Chen (1):
      perf probe: Fix ppc64 'perf probe add events failed' case

ZouMingzhe (1):
      scsi: target: iscsi: Make sure the np under each tpg is unique

