Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7741143E3
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 16:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbfLEPoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 10:44:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfLEPoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 10:44:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DB81206DB;
        Thu,  5 Dec 2019 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575560644;
        bh=LtcrAPFlRy19na1EkmNe9w8nJw+47/3pSogAKXI8pgo=;
        h=Date:From:To:Cc:Subject:From;
        b=yodPuVcN5/vlEtAdvqIwZ99Rm7CLAmYe9qOFsVS0wnp3PUrW8NiDK5ICFd2KscaJn
         b5Rq6iGD1otINSvyfO6ZAvswtNo8LOx07oVV2WNjCuFfhLx8npYetOWJHCzpj2h/lC
         sTSuxlR9eYI5lWV7vpmeAot7q2v8jhVGKNZm2Nb8=
Date:   Thu, 5 Dec 2019 16:44:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.206
Message-ID: <20191205154402.GA753819@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.206 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/hid/uhid.txt                         |    2=20
 Makefile                                           |    2=20
 arch/arm/Kconfig.debug                             |   28 +++++------
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi        |    8 ---
 arch/arm/mach-ks8695/board-acs5k.c                 |    2=20
 arch/arm64/kernel/head.S                           |   26 ++++++++++
 arch/arm64/kernel/smp.c                            |    6 ++
 arch/microblaze/Makefile                           |   12 ++--
 arch/microblaze/boot/Makefile                      |    4 -
 arch/openrisc/kernel/entry.S                       |    2=20
 arch/openrisc/kernel/head.S                        |    2=20
 arch/powerpc/boot/dts/bamboo.dts                   |    4 +
 arch/powerpc/include/asm/cputable.h                |    1=20
 arch/powerpc/include/asm/reg.h                     |    2=20
 arch/powerpc/kernel/cputable.c                     |   10 ++--
 arch/powerpc/kernel/prom.c                         |    6 +-
 arch/powerpc/mm/fault.c                            |   17 +++---
 arch/powerpc/mm/ppc_mmu_32.c                       |    4 -
 arch/powerpc/platforms/83xx/misc.c                 |   17 ++++++
 arch/powerpc/platforms/powernv/eeh-powernv.c       |    8 +--
 arch/powerpc/platforms/powernv/pci-ioda.c          |    4 -
 arch/powerpc/platforms/powernv/pci.c               |    4 -
 arch/powerpc/platforms/pseries/dlpar.c             |    4 +
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    1=20
 arch/powerpc/xmon/xmon.c                           |    2=20
 arch/s390/kvm/kvm-s390.c                           |   17 +++++-
 arch/s390/mm/gup.c                                 |    9 ++-
 arch/um/Kconfig.debug                              |    1=20
 arch/x86/mm/gup.c                                  |    9 +++
 crypto/crypto_user.c                               |   37 ++++++++------
 drivers/acpi/acpi_lpss.c                           |    7 --
 drivers/acpi/apei/ghes.c                           |   30 ++++++------
 drivers/base/platform.c                            |    3 +
 drivers/block/drbd/drbd_main.c                     |    1=20
 drivers/block/drbd/drbd_nl.c                       |   43 ++++++++++++-----
 drivers/block/drbd/drbd_receiver.c                 |   52 ++++++++++++++++=
+++--
 drivers/block/drbd/drbd_state.h                    |    2=20
 drivers/char/hw_random/stm32-rng.c                 |    8 +++
 drivers/clk/at91/clk-main.c                        |    7 ++
 drivers/clk/at91/sckc.c                            |   20 ++++++--
 drivers/clk/samsung/clk-exynos5420.c               |    6 ++
 drivers/crypto/mxc-scc.c                           |   12 ++--
 drivers/hid/hid-core.c                             |   51 ++++++++++++++++=
++--
 drivers/hid/intel-ish-hid/ishtp-hid.c              |    2=20
 drivers/infiniband/hw/qib/qib_sdma.c               |    4 +
 drivers/infiniband/ulp/srp/ib_srp.c                |    1=20
 drivers/input/serio/gscps2.c                       |    4 -
 drivers/input/serio/hp_sdc.c                       |    4 -
 drivers/iommu/amd_iommu.c                          |    8 ++-
 drivers/md/dm-flakey.c                             |   33 ++++++++-----
 drivers/media/platform/atmel/atmel-isc.c           |    8 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    1=20
 drivers/misc/mei/bus.c                             |    9 ++-
 drivers/mtd/mtdcore.h                              |    2=20
 drivers/mtd/mtdpart.c                              |   35 ++++++++++++--
 drivers/mtd/nand/sunxi_nand.c                      |    2=20
 drivers/mtd/ubi/build.c                            |    2=20
 drivers/mtd/ubi/kapi.c                             |    2=20
 drivers/net/can/c_can/c_can.c                      |   26 ++++++++++
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   15 ++++--
 drivers/net/dsa/bcm_sf2.c                          |    7 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    4 +
 drivers/net/ethernet/cadence/macb.c                |   14 ++---
 drivers/net/ethernet/freescale/fec_main.c          |   13 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    8 +--
 drivers/net/ethernet/sfc/ef10.c                    |   29 ++++++++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |    4 +
 drivers/net/macvlan.c                              |    3 -
 drivers/net/slip/slip.c                            |    1=20
 drivers/net/wan/fsl_ucc_hdlc.c                     |    1=20
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    4 -
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   14 ++---
 drivers/net/wireless/marvell/mwifiex/scan.c        |   18 ++++---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    3 -
 drivers/pinctrl/pinctrl-xway.c                     |   39 ++++++++++-----
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                |    9 ++-
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                |   16 +++---
 drivers/platform/x86/hp-wmi.c                      |    6 +-
 drivers/power/avs/smartreflex.c                    |    3 -
 drivers/pwm/core.c                                 |    1=20
 drivers/pwm/pwm-bcm-iproc.c                        |    1=20
 drivers/pwm/pwm-berlin.c                           |    1=20
 drivers/pwm/pwm-clps711x.c                         |    4 -
 drivers/pwm/pwm-samsung.c                          |    1=20
 drivers/regulator/palmas-regulator.c               |    5 +-
 drivers/regulator/tps65910-regulator.c             |    4 +
 drivers/scsi/csiostor/csio_init.c                  |    2=20
 drivers/scsi/libsas/sas_expander.c                 |   29 +++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c                      |   18 +++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   48 +++-------------=
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                 |    3 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    5 +-
 drivers/tty/serial/max310x.c                       |    7 --
 drivers/usb/serial/ftdi_sio.c                      |    3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 ++
 drivers/vfio/vfio_iommu_spapr_tce.c                |   10 +---
 drivers/watchdog/meson_gxbb_wdt.c                  |    4 -
 drivers/xen/xen-pciback/pci_stub.c                 |    3 -
 fs/btrfs/delayed-ref.c                             |    3 -
 fs/gfs2/bmap.c                                     |    2=20
 fs/ocfs2/journal.c                                 |    6 --
 fs/xfs/xfs_ioctl32.c                               |   40 ++++++++++++++--
 fs/xfs/xfs_rtalloc.c                               |    4 -
 include/linux/genalloc.h                           |   13 ++---
 include/linux/gpio/consumer.h                      |    2=20
 include/linux/netdevice.h                          |    2=20
 include/linux/reset-controller.h                   |    2=20
 include/linux/swap.h                               |    6 --
 include/net/sctp/structs.h                         |    3 +
 include/net/sock.h                                 |    2=20
 lib/genalloc.c                                     |   25 ++++++----
 mm/internal.h                                      |   10 ++++
 net/core/neighbour.c                               |   13 +++--
 net/core/net_namespace.c                           |    3 -
 net/core/sock.c                                    |    2=20
 net/decnet/dn_dev.c                                |    2=20
 net/ipv4/ip_tunnel.c                               |    8 ++-
 net/mac80211/sta_info.c                            |    3 -
 net/openvswitch/datapath.c                         |   17 +++++-
 net/sched/sch_mq.c                                 |    3 -
 net/sched/sch_mqprio.c                             |    4 -
 net/sched/sch_multiq.c                             |    2=20
 net/sched/sch_prio.c                               |    2=20
 net/sctp/associola.c                               |    1=20
 net/sctp/endpointola.c                             |    1=20
 net/sctp/input.c                                   |    4 -
 net/sctp/transport.c                               |    3 -
 net/tipc/link.c                                    |    2=20
 net/tipc/netlink_compat.c                          |    8 ++-
 net/vmw_vsock/af_vsock.c                           |    7 ++
 scripts/gdb/linux/symbols.py                       |    3 -
 sound/core/compress_offload.c                      |    2=20
 sound/soc/kirkwood/kirkwood-i2s.c                  |    8 +--
 133 files changed, 828 insertions(+), 393 deletions(-)

Aaron Ma (1):
      iommu/amd: Fix NULL dereference bug in match_hid_uid

Aditya Pakki (1):
      net/net_namespace: Check the return value of register_pernet_subsys()

Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Alexander Shiyan (2):
      serial: max310x: Fix tx_empty() callback
      pwm: clps711x: Fix period calculation

Alexander Usyskin (1):
      mei: bus: prefix device names on bus with the bus name

Alexandre Belloni (1):
      clk: at91: avoid sleeping early

Alexey Kardashevskiy (2):
      vfio/spapr_tce: Get rid of possible infinite loop
      powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_=
freeze_status

Alexey Skidanov (1):
      lib/genalloc.c: fix allocation of aligned buffer from non-aligned chu=
nk

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

Boris Brezillon (3):
      mtd: rawnand: sunxi: Write pageprog related opcodes to WCMD_SET
      mtd: Check add_mtd_device() ret code
      mtd: Remove a debug trace in mtdpart.c

Brian Norris (1):
      mwifiex: debugfs: correct histogram spacing, formatting

Candle Sun (1):
      HID: core: check whether Usage Page item is after Usage ID items

Christophe Leroy (5):
      powerpc/book3s/32: fix number of bats in p/v_block_mapped()
      powerpc/xmon: fix dump_segments()
      powerpc/prom: fix early DEBUG messages
      powerpc/mm: Make NULL pointer deferences explicit on bad page faults.
      powerpc/83xx: handle machine check caused by watchdog timer

Chuhong Yuan (2):
      net: fec: add missed clk_disable_unprepare in remove
      net: fec: fix clock count mis-match

Dan Carpenter (2):
      block: drbd: remove a stray unlock in __drbd_send_protocol()
      IB/qib: Fix an error code in qib_sdma_verbs_send()

Darrick J. Wong (1):
      xfs: require both realtime inodes to mount

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock sub=
queues

Edward Cree (1):
      sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Eric Biggers (1):
      crypto: user - support incremental algorithm dumps

Eric Dumazet (1):
      net: fix possible overflow in __sk_mem_raise_allocated()

Eugen Hristev (3):
      clk: at91: fix update bit maps on CFG_MOR write
      media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
      media: atmel: atmel-isc: fix asd memory allocation

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Fabio Estevam (2):
      ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication
      crypto: mxc-scc - fix build warnings on ARM64

Geert Uytterhoeven (3):
      pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
      pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10
      openrisc: Fix broken paths to arch/or32

Gen Zhang (1):
      powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property=
()

Greg Kroah-Hartman (1):
      Linux 4.9.206

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
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on op=
en

Johannes Berg (1):
      decnet: fix DN_IFREQ_SIZE

John Garry (2):
      scsi: libsas: Support SATA PHY connection rate unmatch fixing during =
discovery
      scsi: libsas: Check SMP PHY control function result

John Rutherford (1):
      tipc: fix link name length check

Josef Bacik (1):
      btrfs: only track ref_heads in delayed_ref_updates

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Junxiao Bi (1):
      ocfs2: clear journal dirty flag after shutdown journal

Kangjie Lu (6):
      drivers/regulator: fix a missing check of return value
      regulator: tps65910: fix a missing check of return value
      net: stmicro: fix a missing check of clk_prepare
      net: dsa: bcm_sf2: Propagate error value from mdio_write
      atl1e: checking the status of atl1e_write_phy_reg
      tipc: fix a missing check of genlmsg_put

Konstantin Khlebnikov (2):
      net/core/neighbour: tell kmemleak about hash tables
      net/core/neighbour: fix kmemleak minimal reference count for hash tab=
les

Krzysztof Kozlowski (1):
      gpiolib: Fix return value of gpio_to_desc() stub if !GPIOLIB

Kyle Roeschley (2):
      ath6kl: Only use match sets when firmware supports it
      ath6kl: Fix off by one error in scan completion

Lars Ellenberg (3):
      drbd: ignore "all zero" peer volume sizes in handshake
      drbd: reject attach of unsuitable uuids even if connected
      drbd: do not block when adjusting "disk-options" while IO is frozen

Leon Romanovsky (1):
      net/mlx5: Continue driver initialization despite debugfs failure

Lepton Wu (1):
      VSOCK: bind to random port for VMADDR_PORT_ANY

Lionel Debieve (1):
      hwrng: stm32 - fix unbalanced pm_runtime_enable

Luc Van Oostenryck (1):
      drbd: fix print_st_err()'s prototype to match the definition

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Maciej Kwiecien (1):
      sctp: don't compare hb_timer expire date before starting it

Marek Szyprowski (1):
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/r=
esume

Martin Schiller (1):
      pinctrl: xway: fix gpio-hog related boot issues

Masahiro Yamada (2):
      microblaze: adjust the help to the real behavior
      microblaze: move "... is ready" messages to arch/microblaze/Makefile

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Michael Ellerman (1):
      powerpc/pseries: Fix node leak in update_lmb_associativity_index()

Michael Mueller (1):
      KVM: s390: unregister debug feature on failing arch init

Nick Bowler (2):
      xfs: Align compat attrlist_by_handle with native implementation.
      xfs: Fix bulkstat compat ioctls on x32 userspace.

Olof Johansson (1):
      lib/genalloc.c: include vmalloc.h

Pan Bian (6):
      mwifiex: fix potential NULL dereference and use after free
      rtl818x: fix potential use after free
      ubi: Put MTD device after it is not used
      ubi: Do not drop UBI device reference before using
      HID: intel-ish-hid: fixes incorrect error handling
      staging: rtl8192e: fix potential use after free

Paolo Abeni (3):
      openvswitch: fix flow command message size
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Peter Hutterer (1):
      HID: doc: fix wrong data structure reference for UHID_OUTPUT

Qian Cai (1):
      drivers/base/platform.c: kmemleak ignore a known leak

Randy Dunlap (1):
      reset: fix reset_control_ops kerneldoc comment

Richard Weinberger (1):
      um: Make GCOV depend on !KCOV

Ross Lagerwall (1):
      xen/pciback: Check dev_data before using it

Russell King (1):
      ASoC: kirkwood: fix external clock probe defer

Steve Capper (1):
      arm64: mm: Prevent mismatched 52-bit VA support

Suzuki K Poulose (1):
      arm64: smp: Handle errors reported by the firmware

Sweet Tea (1):
      dm flakey: Properly corrupt multi-page bios.

Thomas Meyer (1):
      PM / AVS: SmartReflex: NULL check before some freeing functions is no=
t needed

Uwe Kleine-K=F6nig (3):
      pwm: bcm-iproc: Prevent unloading the driver module while in use
      ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed
      pwm: Clear chip_data in pwm_put()

Varun Prakash (1):
      scsi: csiostor: fix incorrect dma device in case of vport

Vlastimil Babka (1):
      mm, gup: add missing refcount overflow checks on x86 and s390

Wei Yang (1):
      vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA=
 is n

Wen Yang (1):
      net/wan/fsl_ucc_hdlc: Avoid double free in ucc_hdlc_probe()

Xiaojun Sang (1):
      ASoC: compress: fix unsigned integer overflow check

Xin Long (1):
      sctp: cache netns in sctp_ep_common

Xingyu Chen (1):
      watchdog: meson: Fix the wrong value of left time

wenxu (1):
      ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3pJb8ACgkQONu9yGCS
aT4Xxg/+MFYhoMqs7t23Ex9dnojsVYn8mAgBleqqyHAWVLLkP0+g/PEBp/6hevju
J3Hv1BeqR7JF2gPktIQpvMJn438hxgADdQIOQf2arVGA1xblAWr6R05MMWgfmaHv
9AgXv6/q3Jb/Wi3lZDRGvBZ6KnnNBa/ITHnXZt5y9UFNDaUnMC/r+cLWMUAnzhRu
aiIeN+rc/XmcPqQbPpPDw5XeWAf3z5CH03acQprCUSsc650rdTY6h5jvqHhqOGGl
GxW5m1A1RO/P/NYYY7O2db43EOBbWwR1cNogUgkmHV5yl0TO79VrU59ATj00w7Fo
x67zA0Q+cId6yyqJHXaaf+wiLkGGsDveqEUIe9uJioTlvIcxClezatqKeP9g4S7C
gCgy/y6Q5RTyfjyQjxmxa/tLfQS7dQOL+Tjgw2VLUyFgsmkEDjQVC7u+LmbVfHCQ
af8VZpFhAQAYCNM5mxk/TW1p4azzlIMaggy4nQyzPiDjAaUPVEezNU6e7lrMhqla
EssPMgJdtu/l6HnGKzQmVy2hWM3sQmxalWO1d4DY1PwQzSQNOcocSp9WS9X9PRKf
tC0ndEs6i6Ml2R8ws4WnThFhLq3fMAWEQ1rPwzS+d04tscvoMEKbTDZ7Eqgn6JW+
R0ksoHfxXqBZrOtBnWxw8K9HSJwgk2Vw8WNrs0teKhBgZNMC/ZQ=
=cuNu
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
