Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B51143E9
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfLEPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 10:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfLEPo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 10:44:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC7BD22525;
        Thu,  5 Dec 2019 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575560668;
        bh=7wN1VoqadmYzjdK+OPHs25Uf5Sb2d+SsQNARx3g8v2Y=;
        h=Date:From:To:Cc:Subject:From;
        b=KcmoI3itFxgTJTASKB0q9yL4MBup9yOP9wPc2FXAqwVkU124CPNk6ePUzpaQLYC1p
         OGJxswf2+kuFa0s0NfIu2ckbJq6CKsPqnNK2BWczSFmnbArm9N0ig4VDTowvy+YSFs
         oxDH9AmGnSkyI5zQqJuMiNdfP3kz0/hLBeHVwD64=
Date:   Thu, 5 Dec 2019 16:44:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.158
Message-ID: <20191205154426.GA753965@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.158 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/hid/uhid.txt                             |    2=20
 Makefile                                               |    2=20
 arch/arm/Kconfig.debug                                 |   28=20
 arch/arm/boot/dts/gemini-sq201.dts                     |   37 -
 arch/arm/boot/dts/imx53-voipac-dmm-668.dtsi            |    8=20
 arch/arm/mach-ks8695/board-acs5k.c                     |    2=20
 arch/arm/mach-omap1/Makefile                           |    2=20
 arch/arm/mach-omap1/include/mach/usb.h                 |    2=20
 arch/arm64/kernel/head.S                               |   26=20
 arch/arm64/kernel/smp.c                                |    6=20
 arch/microblaze/Makefile                               |   12=20
 arch/microblaze/boot/Makefile                          |    4=20
 arch/openrisc/kernel/entry.S                           |    2=20
 arch/openrisc/kernel/head.S                            |    2=20
 arch/powerpc/boot/dts/bamboo.dts                       |    4=20
 arch/powerpc/include/asm/cputable.h                    |    1=20
 arch/powerpc/include/asm/reg.h                         |    2=20
 arch/powerpc/kernel/cputable.c                         |   10=20
 arch/powerpc/kernel/prom.c                             |    6=20
 arch/powerpc/mm/fault.c                                |   17=20
 arch/powerpc/mm/ppc_mmu_32.c                           |    4=20
 arch/powerpc/perf/isa207-common.c                      |   25=20
 arch/powerpc/perf/isa207-common.h                      |    4=20
 arch/powerpc/platforms/83xx/misc.c                     |   17=20
 arch/powerpc/platforms/powernv/eeh-powernv.c           |    8=20
 arch/powerpc/platforms/powernv/pci-ioda.c              |    4=20
 arch/powerpc/platforms/powernv/pci.c                   |    4=20
 arch/powerpc/platforms/pseries/dlpar.c                 |    4=20
 arch/powerpc/platforms/pseries/hotplug-memory.c        |    1=20
 arch/powerpc/xmon/xmon.c                               |    2=20
 arch/s390/kvm/kvm-s390.c                               |   17=20
 arch/s390/mm/gup.c                                     |    9=20
 arch/um/Kconfig.debug                                  |    1=20
 arch/x86/kernel/cpu/intel_rdt_ctrlmondata.c            |    4=20
 arch/x86/kvm/vmx.c                                     |   14=20
 arch/x86/xen/xen-asm_64.S                              |    2=20
 crypto/crypto_user.c                                   |   37 -
 drivers/acpi/acpi_lpss.c                               |    7=20
 drivers/acpi/apei/ghes.c                               |   32 -
 drivers/base/platform.c                                |    3=20
 drivers/block/drbd/drbd_main.c                         |    1=20
 drivers/block/drbd/drbd_nl.c                           |   43 +
 drivers/block/drbd/drbd_receiver.c                     |   52 +
 drivers/block/drbd/drbd_state.h                        |    2=20
 drivers/bluetooth/hci_bcm.c                            |   22=20
 drivers/char/hw_random/stm32-rng.c                     |    8=20
 drivers/clk/at91/clk-generated.c                       |   28=20
 drivers/clk/at91/clk-main.c                            |    7=20
 drivers/clk/at91/sckc.c                                |   20=20
 drivers/clk/meson/gxbb.c                               |    1=20
 drivers/clk/samsung/clk-exynos5420.c                   |    6=20
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c                   |    2=20
 drivers/clk/ti/clk-dra7-atl.c                          |    6=20
 drivers/clocksource/timer-fttmr010.c                   |   73 +-
 drivers/crypto/mxc-scc.c                               |   12=20
 drivers/crypto/stm32/stm32-hash.c                      |    2=20
 drivers/gpu/ipu-v3/ipu-pre.c                           |    6=20
 drivers/hid/hid-core.c                                 |   51 +
 drivers/hid/intel-ish-hid/ishtp-hid.c                  |    2=20
 drivers/infiniband/hw/qib/qib_sdma.c                   |    4=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c        |    2=20
 drivers/infiniband/sw/rxe/rxe_hw_counters.c            |    2=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                  |    6=20
 drivers/infiniband/ulp/srp/ib_srp.c                    |    1=20
 drivers/input/serio/gscps2.c                           |    4=20
 drivers/input/serio/hp_sdc.c                           |    4=20
 drivers/iommu/amd_iommu.c                              |    8=20
 drivers/mailbox/mailbox-test.c                         |   14=20
 drivers/md/dm-flakey.c                                 |   33 -
 drivers/media/platform/atmel/atmel-isc.c               |   12=20
 drivers/media/platform/stm32/stm32-dcmi.c              |   17=20
 drivers/media/v4l2-core/v4l2-ctrls.c                   |    1=20
 drivers/misc/mei/bus.c                                 |    9=20
 drivers/mmc/host/meson-gx-mmc.c                        |   73 ++
 drivers/mtd/mtdcore.h                                  |    2=20
 drivers/mtd/mtdpart.c                                  |   35 -
 drivers/mtd/nand/atmel/nand-controller.c               |    2=20
 drivers/mtd/nand/atmel/pmecc.c                         |   21=20
 drivers/mtd/nand/sunxi_nand.c                          |    2=20
 drivers/mtd/spi-nor/spi-nor.c                          |    2=20
 drivers/mtd/ubi/build.c                                |    2=20
 drivers/mtd/ubi/kapi.c                                 |    2=20
 drivers/net/can/c_can/c_can.c                          |   26=20
 drivers/net/can/rx-offload.c                           |   96 ++-
 drivers/net/can/usb/peak_usb/pcan_usb.c                |   15=20
 drivers/net/dsa/bcm_sf2.c                              |    7=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c        |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c      |   78 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c         |    5=20
 drivers/net/ethernet/cadence/macb.h                    |    6=20
 drivers/net/ethernet/cadence/macb_main.c               |   18=20
 drivers/net/ethernet/cadence/macb_ptp.c                |    5=20
 drivers/net/ethernet/freescale/fec_main.c              |   13=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |    2=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/main.c         |    8=20
 drivers/net/ethernet/sfc/ef10.c                        |   29=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c      |    4=20
 drivers/net/ethernet/ti/cpts.c                         |    4=20
 drivers/net/macvlan.c                                  |    3=20
 drivers/net/slip/slip.c                                |    1=20
 drivers/net/vxlan.c                                    |   13=20
 drivers/net/wan/fsl_ucc_hdlc.c                         |    1=20
 drivers/net/wireless/ath/ath6kl/cfg80211.c             |    4=20
 drivers/net/wireless/intel/iwlwifi/dvm/main.c          |   17=20
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   19=20
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |    5=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |    4=20
 drivers/net/wireless/marvell/mwifiex/debugfs.c         |   14=20
 drivers/net/wireless/marvell/mwifiex/scan.c            |   18=20
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c     |    3=20
 drivers/pci/msi.c                                      |   22=20
 drivers/pinctrl/pinctrl-xway.c                         |   39 -
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                    |    9=20
 drivers/pinctrl/sh-pfc/pfc-sh7734.c                    |   16=20
 drivers/pinctrl/stm32/pinctrl-stm32.c                  |   26=20
 drivers/platform/x86/hp-wmi.c                          |   10=20
 drivers/power/avs/smartreflex.c                        |    3=20
 drivers/pwm/core.c                                     |    1=20
 drivers/pwm/pwm-bcm-iproc.c                            |    1=20
 drivers/pwm/pwm-berlin.c                               |    1=20
 drivers/pwm/pwm-clps711x.c                             |    4=20
 drivers/pwm/pwm-pca9685.c                              |    1=20
 drivers/pwm/pwm-samsung.c                              |    1=20
 drivers/regulator/palmas-regulator.c                   |    5=20
 drivers/regulator/tps65910-regulator.c                 |    4=20
 drivers/reset/core.c                                   |    1=20
 drivers/scsi/csiostor/csio_init.c                      |    2=20
 drivers/scsi/libsas/sas_expander.c                     |   29=20
 drivers/scsi/lpfc/lpfc.h                               |    6=20
 drivers/scsi/lpfc/lpfc_attr.c                          |    4=20
 drivers/scsi/lpfc/lpfc_bsg.c                           |    6=20
 drivers/scsi/lpfc/lpfc_els.c                           |    4=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                       |    2=20
 drivers/scsi/lpfc/lpfc_init.c                          |    7=20
 drivers/scsi/lpfc/lpfc_scsi.c                          |   18=20
 drivers/scsi/lpfc/lpfc_sli.c                           |    2=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                     |   48 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                     |    3=20
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c           |    5=20
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c           |    7=20
 drivers/tty/serial/8250/8250_core.c                    |   26=20
 drivers/tty/serial/8250/8250_fsl.c                     |   23=20
 drivers/tty/serial/8250/8250_of.c                      |    5=20
 drivers/tty/serial/max310x.c                           |    7=20
 drivers/usb/serial/ftdi_sio.c                          |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                      |    7=20
 drivers/vfio/vfio_iommu_spapr_tce.c                    |   10=20
 drivers/watchdog/meson_gxbb_wdt.c                      |    4=20
 drivers/watchdog/sama5d4_wdt.c                         |    4=20
 drivers/xen/xen-pciback/pci_stub.c                     |    3=20
 fs/btrfs/delayed-ref.c                                 |    3=20
 fs/ceph/super.c                                        |   11=20
 fs/exec.c                                              |    2=20
 fs/exofs/super.c                                       |   37 -
 fs/ext4/inode.c                                        |   15=20
 fs/ext4/super.c                                        |   21=20
 fs/f2fs/file.c                                         |    2=20
 fs/gfs2/bmap.c                                         |    2=20
 fs/ocfs2/journal.c                                     |    6=20
 fs/xfs/xfs_ioctl32.c                                   |   40 +
 fs/xfs/xfs_rtalloc.c                                   |    4=20
 include/linux/blktrace_api.h                           |    8=20
 include/linux/compat.h                                 |    2=20
 include/linux/futex.h                                  |   44 -
 include/linux/genalloc.h                               |   13=20
 include/linux/gpio/consumer.h                          |    2=20
 include/linux/netdevice.h                              |    2=20
 include/linux/reset-controller.h                       |    2=20
 include/linux/sched.h                                  |    3=20
 include/linux/sched/mm.h                               |    6=20
 include/linux/sched/task.h                             |    2=20
 include/linux/serial_8250.h                            |    4=20
 include/linux/swap.h                                   |    6=20
 include/net/sctp/structs.h                             |    3=20
 include/net/sock.h                                     |    2=20
 init/main.c                                            |    1=20
 kernel/Makefile                                        |    3=20
 kernel/bpf/syscall.c                                   |    6=20
 kernel/exit.c                                          |   30=20
 kernel/fork.c                                          |   45 -
 kernel/futex.c                                         |  511 ++++++++++++=
+++--
 kernel/futex_compat.c                                  |  202 ------
 lib/genalloc.c                                         |   25=20
 lib/radix-tree.c                                       |    2=20
 mm/internal.h                                          |   10=20
 net/bridge/netfilter/ebt_dnat.c                        |   19=20
 net/core/neighbour.c                                   |   13=20
 net/core/net_namespace.c                               |    3=20
 net/core/sock.c                                        |    2=20
 net/decnet/dn_dev.c                                    |    2=20
 net/ipv4/ip_tunnel.c                                   |    8=20
 net/mac80211/sta_info.c                                |    3=20
 net/openvswitch/datapath.c                             |   17=20
 net/psample/psample.c                                  |    2=20
 net/sched/sch_mq.c                                     |    3=20
 net/sched/sch_mqprio.c                                 |    4=20
 net/sched/sch_multiq.c                                 |    2=20
 net/sched/sch_prio.c                                   |    2=20
 net/sctp/associola.c                                   |    1=20
 net/sctp/endpointola.c                                 |    1=20
 net/sctp/input.c                                       |    4=20
 net/sctp/transport.c                                   |    3=20
 net/smc/smc_core.c                                     |    4=20
 net/tipc/link.c                                        |    2=20
 net/tipc/netlink_compat.c                              |   15=20
 net/vmw_vsock/af_vsock.c                               |    7=20
 net/xfrm/xfrm_state.c                                  |    2=20
 samples/vfio-mdev/mtty.c                               |   26=20
 scripts/gdb/linux/symbols.py                           |    3=20
 security/apparmor/apparmorfs.c                         |    1=20
 sound/core/compress_offload.c                          |    2=20
 sound/soc/codecs/msm8916-wcd-analog.c                  |    4=20
 sound/soc/kirkwood/kirkwood-i2s.c                      |    8=20
 sound/soc/stm/stm32_i2s.c                              |   29=20
 virt/kvm/kvm_main.c                                    |    2=20
 216 files changed, 2022 insertions(+), 1028 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP1: fix USB configuration for device-only setups

Aaron Ma (1):
      iommu/amd: Fix NULL dereference bug in match_hid_uid

Aditya Pakki (2):
      net/netlink_compat: Fix a missing check of nla_parse_nested
      net/net_namespace: Check the return value of register_pernet_subsys()

Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Al Viro (1):
      exofs_mount(): fix leaks on failure exits

Alexander Shiyan (2):
      serial: max310x: Fix tx_empty() callback
      pwm: clps711x: Fix period calculation

Alexander Usyskin (1):
      mei: bus: prefix device names on bus with the bus name

Alexandre Belloni (2):
      clk: at91: avoid sleeping early
      clk: at91: generated: set audio_pll_allowed in at91_clk_register_gene=
rated()

Alexandre Torgue (1):
      pinctrl: stm32: fix memory leak issue

Alexey Kardashevskiy (2):
      vfio/spapr_tce: Get rid of possible infinite loop
      powerpc/powernv/eeh/npu: Fix uninitialized variables in opal_pci_eeh_=
freeze_status

Alexey Skidanov (1):
      lib/genalloc.c: fix allocation of aligned buffer from non-aligned chu=
nk

Anatoliy Glagolev (1):
      scsi: qla2xxx: deadlock by configfs_depend_item

Andrea Righi (1):
      kprobes/x86/xen: blacklist non-attachable xen interrupt functions

Andy Shevchenko (1):
      net: dev: Use unsigned integer as an argument to left-shift

Arnd Bergmann (2):
      ARM: ks8695: fix section mismatch warning
      y2038: futex: Move compat implementation into futex.c

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

Chao Yu (1):
      f2fs: fix to dirty inode synchronously

Chris Coulson (1):
      apparmor: delete the dentry in aafs_remove() to avoid a leak

Christophe Leroy (5):
      powerpc/book3s/32: fix number of bats in p/v_block_mapped()
      powerpc/xmon: fix dump_segments()
      powerpc/prom: fix early DEBUG messages
      powerpc/mm: Make NULL pointer deferences explicit on bad page faults.
      powerpc/83xx: handle machine check caused by watchdog timer

Chuhong Yuan (2):
      net: fec: add missed clk_disable_unprepare in remove
      net: fec: fix clock count mis-match

Colin Ian King (1):
      clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18

Dan Carpenter (2):
      block: drbd: remove a stray unlock in __drbd_send_protocol()
      IB/qib: Fix an error code in qib_sdma_verbs_send()

Darrick J. Wong (1):
      xfs: require both realtime inodes to mount

Darwin Dingel (1):
      serial: 8250: Rate limit serial port rx interrupts during input overr=
uns

Doug Berger (1):
      net: bcmgenet: reapply manual settings to the PHY

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock sub=
queues

Edward Cree (1):
      sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe

Eric Biggers (1):
      crypto: user - support incremental algorithm dumps

Eric Dumazet (1):
      net: fix possible overflow in __sk_mem_raise_allocated()

Eugen Hristev (5):
      clk: at91: fix update bit maps on CFG_MOR write
      media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
      media: atmel: atmel-isc: fix asd memory allocation
      media: atmel: atmel-isc: fix INIT_WORK misplacement
      watchdog: sama5d4: fix WDD value to be always set to max

Fabien Dessenne (1):
      mailbox: mailbox-test: fix null pointer if no mmio

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Fabio Estevam (2):
      ARM: dts: imx53-voipac-dmm-668: Fix memory node duplication
      crypto: mxc-scc - fix build warnings on ARM64

Florian Westphal (1):
      bridge: ebtables: don't crash when using dnat target in output chains

Gal Pressman (1):
      RDMA/vmw_pvrdma: Use atomic memory allocation in create AH

Geert Uytterhoeven (3):
      pinctrl: sh-pfc: sh7264: Fix PFCR3 and PFCR0 register configuration
      pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10
      openrisc: Fix broken paths to arch/or32

Gen Zhang (1):
      powerpc/pseries/dlpar: Fix a missing check in dlpar_parse_cc_property=
()

Greg Kroah-Hartman (3):
      Revert "KVM: nVMX: reset cache/shadows when switching loaded VMCS"
      kvm: properly check debugfs dentry before using it
      Linux 4.14.158

Gustavo A. R. Silva (1):
      tipc: fix memory leak in tipc_nl_compat_publ_dump

Hans de Goede (5):
      ACPI / LPSS: Ignore acpi_device_fix_up_power() return value
      staging: rtl8723bs: Drop ACPI device ids
      staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input si=
ze

Harini Katakam (1):
      net: macb: Fix SUBNS increment and increase resolution

He Zhe (1):
      serial: 8250: Fix serial8250 initialization crash

Helge Deller (2):
      parisc: Fix serio address output
      parisc: Fix HP SDC hpa address output

Hoang Le (1):
      tipc: fix skb may be leaky in tipc_link_input

Huang Shijie (1):
      lib/genalloc.c: use vzalloc_node() to allocate the bitmap

Hugues Fruchet (1):
      media: stm32-dcmi: fix DMA corruption when stopping streaming

Ilya Leoshkevich (1):
      scripts/gdb: fix debugging modules compiled with hot/cold partitioning

James Morse (2):
      ACPI / APEI: Don't wait to serialise with oops messages when panic()i=
ng
      ACPI / APEI: Switch estatus pool to use vmalloc memory

James Smart (3):
      scsi: lpfc: Fix kernel Oops due to null pring pointers
      scsi: lpfc: Fix dif and first burst use in write commands
      scsi: lpfc: Enable Management features for IF_TYPE=3D6

Jan Kara (1):
      blktrace: Show requests without sector

Jeff Layton (1):
      ceph: return -EINVAL if given fsc mount option on kernel w/o support

Jeroen Hofstee (3):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on op=
en
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on =
error

Jerome Brunet (1):
      mmc: meson-gx: make sure the descriptor is stopped on errors

Jim Mattson (1):
      kvm: vmx: Set IA32_TSC_AUX for legacy mode guests

Johannes Berg (1):
      decnet: fix DN_IFREQ_SIZE

John Garry (2):
      scsi: libsas: Support SATA PHY connection rate unmatch fixing during =
discovery
      scsi: libsas: Check SMP PHY control function result

John Rutherford (1):
      tipc: fix link name length check

Jonathan Bakker (1):
      Bluetooth: hci_bcm: Handle specific unknown packets after firmware lo=
ading

Josef Bacik (1):
      btrfs: only track ref_heads in delayed_ref_updates

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Junxiao Bi (1):
      ocfs2: clear journal dirty flag after shutdown journal

Kangjie Lu (7):
      drivers/regulator: fix a missing check of return value
      regulator: tps65910: fix a missing check of return value
      net: (cpts) fix a missing check of clk_prepare
      net: stmicro: fix a missing check of clk_prepare
      net: dsa: bcm_sf2: Propagate error value from mdio_write
      atl1e: checking the status of atl1e_write_phy_reg
      tipc: fix a missing check of genlmsg_put

Karsten Graul (1):
      net/smc: prevent races between smc_lgr_terminate() and smc_conn_free()

Kishon Vijay Abraham I (1):
      reset: Fix memory leak in reset_control_array_put()

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

Linus Walleij (1):
      ARM: dts: Fix up SQ201 flash access

Lionel Debieve (2):
      crypto: stm32/hash - Fix hmac issue more than 256 bytes
      hwrng: stm32 - fix unbalanced pm_runtime_enable

Luc Van Oostenryck (1):
      drbd: fix print_st_err()'s prototype to match the definition

Luca Ceresoli (1):
      net: macb: fix error format in dev_err()

Luca Coelho (1):
      iwlwifi: move iwl_nvm_check_version() into dvm

Lucas Stach (1):
      gpu: ipu-v3: pre: don't trigger update if buffer address doesn't chan=
ge

Maciej Kwiecien (1):
      sctp: don't compare hb_timer expire date before starting it

Madhavan Srinivasan (1):
      powerpc/perf: Fix unit_sel/cache_sel checks

Marc Kleine-Budde (5):
      can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avo=
id skb mem leak
      can: rx-offload: can_rx_offload_offload_one(): do not increase the sk=
b_queue beyond skb_queue_len_max
      can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_erro=
rs on queue overflow or OOM
      can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propa=
gate error value in case of errors
      can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error

Marek Szyprowski (1):
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/r=
esume

Martin Blumenstingl (1):
      clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate

Martin Schiller (1):
      pinctrl: xway: fix gpio-hog related boot issues

Masahiro Yamada (2):
      microblaze: adjust the help to the real behavior
      microblaze: move "... is ready" messages to arch/microblaze/Makefile

Matthew Wilcox (Oracle) (1):
      idr: Fix idr_alloc_u32 on 32-bit systems

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Michael Ellerman (1):
      powerpc/pseries: Fix node leak in update_lmb_associativity_index()

Michael Mueller (1):
      KVM: s390: unregister debug feature on failing arch init

Ming Lei (1):
      PCI/MSI: Return -ENOSPC from pci_alloc_irq_vectors_affinity()

Miquel Raynal (1):
      mtd: rawnand: atmel: Fix spelling mistake in error message

Nathan Chancellor (1):
      vfio-mdev/samples: Use u8 instead of char for handle functions

Nick Bowler (2):
      xfs: Align compat attrlist_by_handle with native implementation.
      xfs: Fix bulkstat compat ioctls on x32 userspace.

Nikolay Aleksandrov (1):
      net: psample: fix skb_over_panic

Olivier Moysan (3):
      ASoC: stm32: i2s: fix dma configuration
      ASoC: stm32: i2s: fix 16 bit format support
      ASoC: stm32: i2s: fix IRQ clearing

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

Parav Pandit (1):
      IB/rxe: Make counters thread safe

Paul Thomas (1):
      net: macb driver, check for SKBTX_HW_TSTAMP

Peng Sun (2):
      bpf: decrease usercnt if bpf_map_new_fd() fails in bpf_map_get_fd_by_=
id()
      bpf: drop refcount if bpf_map_new_fd() fails in map_create()

Peter Hutterer (1):
      HID: doc: fix wrong data structure reference for UHID_OUTPUT

Peter Ujfalusi (1):
      clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Petr Machata (1):
      vxlan: Fix error path in __vxlan_dev_create()

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

Steffen Klassert (1):
      xfrm: Fix memleak on xfrm state destroy

Stephan Gerhold (1):
      ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Steve Capper (1):
      arm64: mm: Prevent mismatched 52-bit VA support

Suzuki K Poulose (1):
      arm64: smp: Handle errors reported by the firmware

Sweet Tea (1):
      dm flakey: Properly corrupt multi-page bios.

Tao Ren (1):
      clocksource/drivers/fttmr010: Fix invalid interrupt register access

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Thomas Gleixner (11):
      futex: Move futex exit handling into futex code
      futex: Replace PF_EXITPIDONE with a state
      exit/exec: Seperate mm_release()
      futex: Split futex_mm_release() for exit/exec
      futex: Set task::futex_state to DEAD right after handling futex exit
      futex: Mark the begin of futex exit explicitly
      futex: Sanitize exit state handling
      futex: Provide state handling for exec() as well
      futex: Add mutex around futex exit
      futex: Provide distinct return value when owner is exiting
      futex: Prevent exit livelock

Thomas Meyer (1):
      PM / AVS: SmartReflex: NULL check before some freeing functions is no=
t needed

Uwe Kleine-K=F6nig (3):
      pwm: bcm-iproc: Prevent unloading the driver module while in use
      ARM: debug-imx: only define DEBUG_IMX_UART_PORT if needed
      pwm: Clear chip_data in pwm_put()

Varun Prakash (1):
      scsi: csiostor: fix incorrect dma device in case of vport

Vasundhara Volam (2):
      bnxt_en: Return linux standard errors in bnxt_ethtool.c
      bnxt_en: query force speeds before disabling autoneg mode.

Vlastimil Babka (1):
      mm, gup: add missing refcount overflow checks on s390

Wei Yang (1):
      vmscan: return NODE_RECLAIM_NOSCAN in node_reclaim() when CONFIG_NUMA=
 is n

Wen Yang (2):
      net/wan/fsl_ucc_hdlc: Avoid double free in ucc_hdlc_probe()
      mtd: rawnand: atmel: fix possible object reference leak

Xiaochen Shen (1):
      x86/resctrl: Prevent NULL pointer dereference when reading mondata

Xiaojun Sang (1):
      ASoC: compress: fix unsigned integer overflow check

Xin Long (1):
      sctp: cache netns in sctp_ep_common

Xingyu Chen (1):
      watchdog: meson: Fix the wrong value of left time

Yang Tao (1):
      futex: Prevent robust futex exit race

Yi Wang (1):
      fork: fix some -Wmissing-prototypes warnings

Yunsheng Lin (1):
      net: hns3: Change fw error code NOT_EXEC to NOT_SUPPORTED

huijin.park (1):
      mtd: spi-nor: cast to u64 to avoid uint overflows

wenxu (1):
      ip_tunnel: Make none-tunnel-dst tunnel port work with lwtunnel


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3pJdoACgkQONu9yGCS
aT7/LhAAmzjboKiIo9tli1IRV5ywJUxlb1MBalAKIHmaU8YByV9FB/hu5sVSiuED
CQWieeJg3a/W1jJlXs3PXu9dOn/UU5vywrmT5B8UKTWjssRW2DUytZ8y2uw7aM+R
rxOvH/stozmFVBh+4FHVEsY6MeXfd7EOCjFSt65xA/Y7IggKQ29QnRTfQDE4+z/n
ie08gsmlGPR2KuNpShSRT1tTsRkCNhn2Ca0yMFN9dGE9j+2hrw2l9Paz38/4VnNg
b0xMrSBaCDWrCjo2DUiLCcwSbTcODyxz0cJIlXmRTkTpSv+VrE6OnvamxgmjAWTo
S82dpIAASNBTlSbtwUd7M90sqSg9S7Egiu0OrXZAF0eI5ZCsG4tdDcYsrPc5fQzg
6UHIwpcVG1JLvPo1ysiaEf9U+SDusiFrOzKFotCndO2dAhU6YYqMRIWguGQvxdZJ
zGKoVVrd2ivbLwCB1hYg6utB3EzOG24L6hb5dPCF3zflaHBRaee4MdRnfTesP9R9
AUe+i3006hJuIabAAnxQMJ6JHtfdtqoYur4BJDZLmgverKgGcOmNHas3ybUAVENo
PWYGqFCETF+teu6jGiQYalRWJdnrLF87MnTg9PNMu05OSXqiaOpG5KL9x7X2WpcC
W4orn6xWbwFDlx/iDp67k+o0cG4/2e3+Mkq+AfKs2K8/mVP1tH4=
=Wg76
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
