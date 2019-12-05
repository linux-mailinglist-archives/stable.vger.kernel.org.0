Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962FE1143D8
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfLEPnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 10:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfLEPnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 10:43:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FA6206DB;
        Thu,  5 Dec 2019 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575560619;
        bh=wR/73kkZuBII+DhjHbfUJ/acwjPZO0PIekOe19ziukg=;
        h=Date:From:To:Cc:Subject:From;
        b=LAAOqqAgLRspBzSn8oiggAEOdI7w51uBasju/uqnIkX2mDqJtmzSvW/tGOlWuN4L7
         CZavjrNO6gf6W3F+b/R/QGZM6GDIof+H9Dk45ozPHjKhZT2cugvrr5UXhbZHp4dw0O
         ck2ilcmGh4PdWSIdAZeUsJMHzQTi/ZuzNeY/v2OI=
Date:   Thu, 5 Dec 2019 16:43:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.206
Message-ID: <20191205154337.GA753689@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.206 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/hid/uhid.txt                         |    2 
 Makefile                                           |    2 
 arch/arm/Kconfig.debug                             |   28 +++++------
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |    8 ---
 arch/arm/mach-ks8695/board-acs5k.c                 |    2 
 arch/arm64/kernel/smp.c                            |    1 
 arch/microblaze/Makefile                           |   12 ++--
 arch/microblaze/boot/Makefile                      |    4 -
 arch/openrisc/kernel/entry.S                       |    2 
 arch/openrisc/kernel/head.S                        |    2 
 arch/powerpc/boot/dts/bamboo.dts                   |    4 +
 arch/powerpc/kernel/prom.c                         |    6 +-
 arch/powerpc/mm/fault.c                            |   17 +++----
 arch/powerpc/mm/ppc_mmu_32.c                       |    4 -
 arch/powerpc/platforms/pseries/dlpar.c             |    4 +
 arch/powerpc/xmon/xmon.c                           |    2 
 arch/s390/kvm/kvm-s390.c                           |   17 +++++--
 arch/um/Kconfig.debug                              |    1 
 crypto/crypto_user.c                               |   37 ++++++++-------
 drivers/acpi/acpi_lpss.c                           |    7 --
 drivers/acpi/apei/ghes.c                           |   30 ++++++------
 drivers/block/drbd/drbd_main.c                     |    1 
 drivers/block/drbd/drbd_nl.c                       |    6 +-
 drivers/block/drbd/drbd_receiver.c                 |   19 +++++++
 drivers/block/drbd/drbd_state.h                    |    2 
 drivers/char/hw_random/stm32-rng.c                 |    8 +++
 drivers/clk/samsung/clk-exynos5420.c               |    6 ++
 drivers/hid/hid-core.c                             |   51 ++++++++++++++++++---
 drivers/infiniband/hw/qib/qib_sdma.c               |    4 +
 drivers/infiniband/ulp/srp/ib_srp.c                |    1 
 drivers/input/serio/gscps2.c                       |    4 -
 drivers/input/serio/hp_sdc.c                       |    4 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |    1 
 drivers/misc/mei/bus.c                             |    9 ++-
 drivers/mtd/mtdcore.h                              |    2 
 drivers/mtd/mtdpart.c                              |   35 ++++++++++++--
 drivers/mtd/ubi/build.c                            |    2 
 drivers/mtd/ubi/kapi.c                             |    2 
 drivers/net/can/c_can/c_can.c                      |   26 ++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   15 ++++--
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    4 +
 drivers/net/ethernet/cadence/macb.c                |   12 ++--
 drivers/net/ethernet/sfc/ef10.c                    |   29 ++++++++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |    4 +
 drivers/net/macvlan.c                              |    3 -
 drivers/net/slip/slip.c                            |    1 
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    4 -
 drivers/net/wireless/mwifiex/debugfs.c             |   14 ++---
 drivers/net/wireless/mwifiex/scan.c                |   18 ++++---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    3 -
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |    9 ++-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   16 +++---
 drivers/platform/x86/hp-wmi.c                      |    6 +-
 drivers/power/avs/smartreflex.c                    |    3 -
 drivers/pwm/core.c                                 |    1 
 drivers/pwm/pwm-samsung.c                          |    1 
 drivers/regulator/palmas-regulator.c               |    5 +-
 drivers/regulator/tps65910-regulator.c             |    4 +
 drivers/scsi/csiostor/csio_init.c                  |    2 
 drivers/scsi/libsas/sas_expander.c                 |   29 +++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c                      |   18 +++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   48 +++----------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |    3 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    5 +-
 drivers/tty/serial/max310x.c                       |    7 --
 drivers/usb/serial/ftdi_sio.c                      |    3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 ++
 drivers/xen/xen-pciback/pci_stub.c                 |    3 -
 fs/btrfs/delayed-ref.c                             |    3 -
 fs/gfs2/bmap.c                                     |    2 
 fs/ocfs2/journal.c                                 |    6 --
 fs/xfs/xfs_ioctl32.c                               |    6 ++
 fs/xfs/xfs_rtalloc.c                               |    4 -
 include/linux/gpio/consumer.h                      |    2 
 include/linux/netdevice.h                          |    2 
 include/linux/reset-controller.h                   |    2 
 include/net/sock.h                                 |    2 
 lib/genalloc.c                                     |    5 +-
 net/core/neighbour.c                               |   13 +++--
 net/core/net_namespace.c                           |    3 -
 net/core/sock.c                                    |    2 
 net/decnet/dn_dev.c                                |    2 
 net/openvswitch/datapath.c                         |   17 +++++--
 net/sched/sch_mq.c                                 |    2 
 net/sched/sch_mqprio.c                             |    3 -
 net/sched/sch_multiq.c                             |    2 
 net/sched/sch_prio.c                               |    2 
 net/tipc/link.c                                    |    2 
 net/tipc/netlink_compat.c                          |    8 ++-
 net/vmw_vsock/af_vsock.c                           |    7 ++
 scripts/gdb/linux/symbols.py                       |    3 -
 sound/core/compress_offload.c                      |    2 
 sound/soc/kirkwood/kirkwood-i2s.c                  |    8 +--
 93 files changed, 492 insertions(+), 270 deletions(-)

Aditya Pakki (1):
      net/net_namespace: Check the return value of register_pernet_subsys()

Alexander Shiyan (1):
      serial: max310x: Fix tx_empty() callback

Alexander Usyskin (1):
      mei: bus: prefix device names on bus with the bus name

Anatoliy Glagolev (1):
      scsi: qla2xxx: deadlock by configfs_depend_item

Andy Shevchenko (1):
      net: dev: Use unsigned integer as an argument to left-shift

Arnd Bergmann (1):
      ARM: ks8695: fix section mismatch warning

Bart Van Assche (1):
      RDMA/srp: Propagate ib_post_send() failures to the SCSI mid-layer

Benjamin Herrenschmidt (1):
      powerpc/44x/bamboo: Fix PCI range

Bert Kenward (1):
      sfc: initialise found bitmap in efx_ef10_mtd_probe

Bob Peterson (1):
      gfs2: take jdata unstuff into account in do_grow

Boris Brezillon (2):
      mtd: Check add_mtd_device() ret code
      mtd: Remove a debug trace in mtdpart.c

Brian Norris (1):
      mwifiex: debugfs: correct histogram spacing, formatting

Candle Sun (1):
      HID: core: check whether Usage Page item is after Usage ID items

Christophe Leroy (4):
      powerpc/book3s/32: fix number of bats in p/v_block_mapped()
      powerpc/xmon: fix dump_segments()
      powerpc/prom: fix early DEBUG messages
      powerpc/mm: Make NULL pointer deferences explicit on bad page faults.

Dan Carpenter (2):
      block: drbd: remove a stray unlock in __drbd_send_protocol()
      IB/qib: Fix an error code in qib_sdma_verbs_send()

Darrick J. Wong (1):
      xfs: require both realtime inodes to mount

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock subqueues

Edward Cree (1):
      sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Eric Biggers (1):
      crypto: user - support incremental algorithm dumps

Eric Dumazet (1):
      net: fix possible overflow in __sk_mem_raise_allocated()

Eugen Hristev (1):
      media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Fabio Estevam (1):
      ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication

Geert Uytterhoeven (3):
      pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
      pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10
      openrisc: Fix broken paths to arch/or32

Gen Zhang (1):
      powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property()

Greg Kroah-Hartman (1):
      Linux 4.4.206

Gustavo A. R. Silva (1):
      tipc: fix memory leak in tipc_nl_compat_publ_dump

Hans de Goede (2):
      ACPI / LPSS: Ignore acpi_device_fix_up_power() return value
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer

Helge Deller (2):
      parisc: Fix serio address output
      parisc: Fix HP SDC hpa address output

Hoang Le (1):
      tipc: fix skb may be leaky in tipc_link_input

Huang Shijie (1):
      lib/genalloc.c: use vzalloc_node() to allocate the bitmap

Ilya Leoshkevich (1):
      scripts/gdb: fix debugging modules compiled with hot/cold partitioning

James Morse (1):
      ACPI / APEI: Switch estatus pool to use vmalloc memory

James Smart (1):
      scsi: lpfc: Fix dif and first burst use in write commands

Jeroen Hofstee (2):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open

Johannes Berg (1):
      decnet: fix DN_IFREQ_SIZE

John Garry (2):
      scsi: libsas: Support SATA PHY connection rate unmatch fixing during discovery
      scsi: libsas: Check SMP PHY control function result

John Rutherford (1):
      tipc: fix link name length check

Josef Bacik (1):
      btrfs: only track ref_heads in delayed_ref_updates

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Junxiao Bi (1):
      ocfs2: clear journal dirty flag after shutdown journal

Kangjie Lu (5):
      drivers/regulator: fix a missing check of return value
      regulator: tps65910: fix a missing check of return value
      net: stmicro: fix a missing check of clk_prepare
      atl1e: checking the status of atl1e_write_phy_reg
      tipc: fix a missing check of genlmsg_put

Konstantin Khlebnikov (2):
      net/core/neighbour: tell kmemleak about hash tables
      net/core/neighbour: fix kmemleak minimal reference count for hash tables

Krzysztof Kozlowski (1):
      gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Kyle Roeschley (2):
      ath6kl: Only use match sets when firmware supports it
      ath6kl: Fix off by one error in scan completion

Lars Ellenberg (1):
      drbd: reject attach of unsuitable uuids even if connected

Lepton Wu (1):
      VSOCK: bind to random port for VMADDR_PORT_ANY

Lionel Debieve (1):
      hwrng: stm32 - fix unbalanced pm_runtime_enable

Luc Van Oostenryck (1):
      drbd: fix print_st_err()'s prototype to match the definition

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Marek Szyprowski (1):
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume

Masahiro Yamada (2):
      microblaze: adjust the help to the real behavior
      microblaze: move "... is ready" messages to arch/microblaze/Makefile

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Michael Mueller (1):
      KVM: s390: unregister debug feature on failing arch init

Nick Bowler (1):
      xfs: Align compat attrlist_by_handle with native implementation.

Olof Johansson (1):
      lib/genalloc.c: include vmalloc.h

Pan Bian (5):
      mwifiex: fix potential NULL dereference and use after free
      rtl818x: fix potential use after free
      ubi: Put MTD device after it is not used
      ubi: Do not drop UBI device reference before using
      staging: rtl8192e: fix potential use after free

Paolo Abeni (3):
      openvswitch: fix flow command message size
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Peter Hutterer (1):
      HID: doc: fix wrong data structure reference for UHID_OUTPUT

Randy Dunlap (1):
      reset: fix reset_control_ops kerneldoc comment

Richard Weinberger (1):
      um: Make GCOV depend on !KCOV

Ross Lagerwall (1):
      xen/pciback: Check dev_data before using it

Russell King (1):
      ASoC: kirkwood: fix external clock probe defer

Suzuki K Poulose (1):
      arm64: smp: Handle errors reported by the firmware

Thomas Meyer (1):
      PM / AVS: SmartReflex: NULL check before some freeing functions is not needed

Uwe Kleine-König (2):
      ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed
      pwm: Clear chip_data in pwm_put()

Varun Prakash (1):
      scsi: csiostor: fix incorrect dma device in case of vport

Xiaojun Sang (1):
      ASoC: compress: fix unsigned integer overflow check

