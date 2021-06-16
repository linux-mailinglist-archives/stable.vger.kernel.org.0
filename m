Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01503A976D
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhFPKfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhFPKed (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 06:34:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4324F61107;
        Wed, 16 Jun 2021 10:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623839547;
        bh=4sY+vICVpr6IWw4tlyauoZvt5lxQoDEsoINIb0TAswQ=;
        h=From:To:Cc:Subject:Date:From;
        b=RmLud94+hqxJPdpsmVYJZ0kL6LQeRyc10R2F/oaRbyQ7QdXvFEc6XXLpXhmOWts2+
         3kdCeuimGSbpoa/XO3CKu56AvVB+dDt+UBvli7GjzR78BUNaRAKwl+ufSUWJTTFkXk
         +CQecz3i2KftJ0zWkp77XL6kTwHf6hN3BC077BSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.44
Date:   Wed, 16 Jun 2021 12:32:11 +0200
Message-Id: <1623839531127176@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.44 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml |    4 
 Documentation/virt/kvm/mmu.rst                                     |    4 
 Makefile                                                           |    2 
 arch/arm/include/asm/cpuidle.h                                     |    5 
 arch/mips/lib/mips-atomic.c                                        |   12 
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi                        |    8 
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi                        |   16 +
 arch/x86/events/intel/uncore_snbep.c                               |    3 
 arch/x86/kernel/cpu/perfctr-watchdog.c                             |    4 
 arch/x86/kvm/mmu/paging_tmpl.h                                     |   14 
 arch/x86/kvm/trace.h                                               |    6 
 crypto/async_tx/async_xor.c                                        |    3 
 drivers/acpi/sleep.c                                               |    4 
 drivers/gpio/gpio-wcd934x.c                                        |    2 
 drivers/gpu/drm/drm_auth.c                                         |    3 
 drivers/gpu/drm/drm_ioctl.c                                        |    9 
 drivers/gpu/drm/mcde/mcde_dsi.c                                    |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                              |  155 +++++++---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h                              |    2 
 drivers/i2c/busses/i2c-mpc.c                                       |   95 ++++++
 drivers/infiniband/hw/mlx4/main.c                                  |    5 
 drivers/infiniband/hw/mlx5/cq.c                                    |    9 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                       |    1 
 drivers/isdn/hardware/mISDN/netjet.c                               |    1 
 drivers/md/dm-verity-verify-sig.c                                  |    2 
 drivers/mmc/host/renesas_sdhi_core.c                               |    9 
 drivers/net/appletalk/cops.c                                       |    4 
 drivers/net/bonding/bond_main.c                                    |    2 
 drivers/net/dsa/microchip/ksz9477.c                                |    1 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c                  |    4 
 drivers/net/ethernet/cadence/macb_main.c                           |    3 
 drivers/net/ethernet/mellanox/mlx4/fw.c                            |    3 
 drivers/net/ethernet/mellanox/mlx4/fw.h                            |    1 
 drivers/net/ethernet/mellanox/mlx4/main.c                          |    6 
 drivers/net/ethernet/qlogic/qla3xxx.c                              |    2 
 drivers/net/ethernet/sfc/nic.c                                     |    1 
 drivers/net/phy/mdio_bus.c                                         |    3 
 drivers/nvme/host/Kconfig                                          |    3 
 drivers/nvme/host/fabrics.c                                        |    5 
 drivers/nvme/target/core.c                                         |   15 
 drivers/nvme/target/nvmet.h                                        |    2 
 drivers/phy/broadcom/phy-brcm-usb-init.h                           |    4 
 drivers/phy/cadence/phy-cadence-sierra.c                           |    1 
 drivers/phy/ti/phy-j721e-wiz.c                                     |    1 
 drivers/regulator/bd718x7-regulator.c                              |    2 
 drivers/regulator/core.c                                           |    6 
 drivers/regulator/fan53880.c                                       |    3 
 drivers/regulator/max77620-regulator.c                             |    7 
 drivers/regulator/rtmv20-regulator.c                               |   42 ++
 drivers/s390/cio/vfio_ccw_drv.c                                    |   12 
 drivers/s390/cio/vfio_ccw_fsm.c                                    |    1 
 drivers/s390/cio/vfio_ccw_ops.c                                    |    2 
 drivers/scsi/bnx2fc/bnx2fc_io.c                                    |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                             |    8 
 drivers/scsi/hosts.c                                               |   47 +--
 drivers/scsi/qla2xxx/qla_target.c                                  |    2 
 drivers/scsi/vmw_pvscsi.c                                          |    8 
 drivers/spi/spi-bcm2835.c                                          |   10 
 drivers/spi/spi-bitbang.c                                          |   18 -
 drivers/spi/spi-fsl-spi.c                                          |    4 
 drivers/spi/spi-omap-uwire.c                                       |    9 
 drivers/spi/spi-omap2-mcspi.c                                      |   33 +-
 drivers/spi/spi-pxa2xx.c                                           |    9 
 drivers/spi/spi-sprd.c                                             |    1 
 drivers/spi/spi-zynq-qspi.c                                        |    7 
 drivers/spi/spi.c                                                  |   20 -
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c                  |    2 
 drivers/usb/cdns3/gadget.c                                         |    4 
 drivers/usb/chipidea/udc.c                                         |    1 
 drivers/usb/dwc3/dwc3-meson-g12a.c                                 |   13 
 drivers/usb/dwc3/ep0.c                                             |    3 
 drivers/usb/dwc3/gadget.c                                          |   15 
 drivers/usb/gadget/config.c                                        |    8 
 drivers/usb/gadget/function/f_ecm.c                                |    2 
 drivers/usb/gadget/function/f_eem.c                                |    6 
 drivers/usb/gadget/function/f_fs.c                                 |    3 
 drivers/usb/gadget/function/f_hid.c                                |    3 
 drivers/usb/gadget/function/f_loopback.c                           |    2 
 drivers/usb/gadget/function/f_ncm.c                                |   10 
 drivers/usb/gadget/function/f_printer.c                            |    3 
 drivers/usb/gadget/function/f_rndis.c                              |    2 
 drivers/usb/gadget/function/f_serial.c                             |    2 
 drivers/usb/gadget/function/f_sourcesink.c                         |    3 
 drivers/usb/gadget/function/f_subset.c                             |    2 
 drivers/usb/gadget/function/f_tcm.c                                |    3 
 drivers/usb/musb/musb_core.c                                       |    3 
 drivers/usb/serial/cp210x.c                                        |   20 +
 drivers/usb/serial/ftdi_sio.c                                      |    1 
 drivers/usb/serial/ftdi_sio_ids.h                                  |    1 
 drivers/usb/serial/omninet.c                                       |    2 
 drivers/usb/serial/quatech2.c                                      |    6 
 drivers/usb/typec/mux.c                                            |    2 
 drivers/usb/typec/mux/intel_pmc_mux.c                              |    9 
 drivers/usb/typec/tcpm/tcpm.c                                      |    4 
 drivers/usb/typec/tcpm/wcove.c                                     |    2 
 drivers/usb/typec/ucsi/ucsi.c                                      |    1 
 fs/btrfs/disk-io.c                                                 |   26 +
 fs/btrfs/file.c                                                    |    4 
 fs/nfs/client.c                                                    |    2 
 fs/nfs/nfs4_fs.h                                                   |    1 
 fs/nfs/nfs4client.c                                                |    2 
 fs/nfs/nfs4proc.c                                                  |   29 +
 fs/proc/base.c                                                     |   11 
 include/asm-generic/vmlinux.lds.h                                  |    1 
 include/linux/kvm_host.h                                           |   10 
 include/linux/mfd/rohm-bd71828.h                                   |   10 
 include/linux/mlx4/device.h                                        |    1 
 include/linux/sched.h                                              |    8 
 include/linux/usb/pd.h                                             |    2 
 kernel/bpf/btf.c                                                   |   12 
 kernel/cgroup/cgroup-v1.c                                          |    4 
 kernel/cgroup/cgroup.c                                             |   13 
 kernel/events/core.c                                               |    2 
 kernel/sched/debug.c                                               |    3 
 kernel/sched/fair.c                                                |   18 -
 kernel/sched/pelt.h                                                |   11 
 kernel/trace/ftrace.c                                              |    8 
 kernel/trace/trace.c                                               |    2 
 kernel/workqueue.c                                                 |   12 
 net/netlink/af_netlink.c                                           |    6 
 net/nfc/rawsock.c                                                  |    2 
 net/rds/connection.c                                               |   23 +
 net/rds/tcp.c                                                      |    4 
 net/rds/tcp.h                                                      |    3 
 net/rds/tcp_listen.c                                               |    6 
 sound/core/seq/seq_timer.c                                         |   10 
 sound/firewire/amdtp-stream.c                                      |    2 
 sound/pci/hda/patch_realtek.c                                      |   16 +
 sound/soc/amd/raven/acp3x-pcm-dma.c                                |   10 
 sound/soc/amd/raven/acp3x.h                                        |    1 
 sound/soc/amd/raven/pci-acp3x.c                                    |   15 
 sound/soc/codecs/max98088.c                                        |   13 
 sound/soc/codecs/sti-sas.c                                         |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                              |   25 +
 sound/soc/soc-core.c                                               |    2 
 tools/bootconfig/main.c                                            |    1 
 tools/perf/util/session.c                                          |    1 
 137 files changed, 875 insertions(+), 289 deletions(-)

Alaa Hleihel (1):
      IB/mlx5: Fix initializing CQ fragments buffer

Alexander Kuznetsov (1):
      cgroup1: don't allow '\n' in renaming

Alexandre GRIVEAUX (1):
      USB: serial: omninet: add device id for Zyxel Omni 56K Plus

Andy Shevchenko (3):
      usb: typec: wcove: Use LE to CPU conversion when accessing msg->header
      usb: typec: intel_pmc_mux: Put fwnode in error case during ->probe()
      usb: typec: intel_pmc_mux: Add missed error check for devm_ioremap_resource()

Anna Schumaker (1):
      NFS: Fix use-after-free in nfs4_init_client()

Arnd Bergmann (1):
      ARM: cpuidle: Avoid orphan section warning

Axel Lin (3):
      regulator: fan53880: Fix missing n_voltages setting
      regulator: bd71828: Fix .n_voltages settings
      regulator: rtmv20: Fix .set_current_limit/.get_current_limit callbacks

Bjorn Andersson (1):
      usb: typec: mux: Fix copy-paste mistake in typec_mux_match

Chen Li (1):
      phy: usb: Fix misuse of IS_ENABLED

Chris Packham (4):
      powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P2041 i2c controllers
      powerpc/fsl: set fsl,i2c-erratum-a004447 flag for P1010 i2c controllers
      i2c: mpc: Make use of i2c_recover_bus()
      i2c: mpc: implement erratum A-004447 workaround

Christophe JAILLET (1):
      usb: dwc3: meson-g12a: Disable the regulator in the error handling path of the probe

Chunyan Zhang (1):
      spi: sprd: Add missing MODULE_DEVICE_TABLE

CodyYao-oc (1):
      x86/nmi_watchdog: Fix old-style NMI watchdog regression on old Intel CPUs

Dai Ngo (1):
      NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.

Dan Carpenter (2):
      net: mdiobus: get rid of a BUG_ON()
      NFS: Fix a potential NULL dereference in nfs_get_client()

Desmond Cheong Zhi Xi (2):
      drm: Fix use-after-free read in drm_getunique()
      drm: Lock pointer access in drm_master_release()

Dietmar Eggemann (1):
      sched/fair: Fix util_est UTIL_AVG_UNCHANGED handling

Dinghao Liu (1):
      usb: cdns3: Fix runtime PM imbalance on error

Dmitry Baryshkov (1):
      regulator: core: resolve supply for boot-on/always-on regulators

Dmitry Bogdanov (1):
      scsi: target: qla2xxx: Wait for stop_phase1 at WWN removal

Dmitry Osipenko (1):
      regulator: max77620: Use device_set_of_node_from_dev()

Eric Farman (2):
      vfio-ccw: Reset FSM state to IDLE inside FSM
      vfio-ccw: Serialize FSM IDLE state with I/O completion

Geert Uytterhoeven (1):
      mmc: renesas_sdhi: Fix HS400 on R-Car M3-W+

George McCollister (2):
      net: dsa: microchip: enable phy errata workaround on 9567
      USB: serial: ftdi_sio: add NovaTech OrionMX product ID

Greg Kroah-Hartman (1):
      Linux 5.10.44

Hannes Reinecke (1):
      nvme-fabrics: decode host pathing error for connect

Hans de Goede (2):
      ASoC: Intel: bytcr_rt5640: Add quirk for the Glavey TM800A550L tablet
      ASoC: Intel: bytcr_rt5640: Add quirk for the Lenovo Miix 3-830 tablet

Hui Wang (1):
      ALSA: hda/realtek: headphone and mic don't work on an Acer laptop

Jack Pham (1):
      usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is NULL

Javed Hasan (1):
      scsi: bnx2fc: Return failure if io_req is already in ABTS processing

Jeimon (1):
      net/nfc/rawsock.c: fix a permission check bug

Jeremy Szu (4):
      ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Elite Dragonfly G2
      ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP EliteBook x360 1040 G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 840 Aero G8
      ALSA: hda/realtek: fix mute/micmute LEDs for HP ZBook Power G8

Jerome Brunet (1):
      ASoC: meson: gx-card: fix sound-dai dt schema

Jiapeng Chong (1):
      bnx2x: Fix missing error code in bnx2x_iov_init_one()

Jiri Olsa (1):
      bpf: Forbid trampoline attach for functions with variable arguments

Johan Hovold (1):
      USB: serial: quatech2: fix control-request directions

Johannes Berg (2):
      bonding: init notify_work earlier to avoid uninitialized use
      netlink: disable IRQs for netlink_lock_table()

John Keeping (1):
      dm verity: fix require_signatures module_param permissions

Jonathan Marek (3):
      drm/msm/a6xx: fix incorrectly set uavflagprd_inv field for A650
      drm/msm/a6xx: update/fix CP_PROTECT initialization
      drm/msm/a6xx: avoid shadow NULL reference in failure path

Kamal Heib (1):
      RDMA/ipoib: Fix warning caused by destroying non-initial netns

Kan Liang (1):
      perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server

Karen Dombroski (1):
      spi: spi-zynq-qspi: Fix stack violation bug

Kees Cook (1):
      proc: Track /proc/$pid/attr/ opener mm_struct

Kefeng Wang (1):
      ASoC: core: Fix Null-point-dereference in fmt_single_name()

Kyle Tso (1):
      usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms

Lai Jiangshan (1):
      KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Leo Yan (1):
      perf session: Correct buffer copying when peeking events

Li Jun (3):
      usb: chipidea: udc: assign interrupt number to USB gadget structure
      usb: typec: tcpm: cancel vdm and state machine hrtimer when unregister tcpm port
      usb: typec: tcpm: cancel frs hrtimer when unregister tcpm port

Liangyan (1):
      tracing: Correct the length check which causes memory corruption

Linus Torvalds (1):
      proc: only require mm_struct for writing

Linus Walleij (1):
      drm/mcde: Fix off by 10^3 in calculation

Linyu Yuan (1):
      usb: gadget: eem: fix wrong eem header operation

Lukas Wunner (2):
      spi: Cleanup on failure of initial setup
      spi: bcm2835: Fix out-of-bounds access with more than 4 slaves

Maciej Żenczykowski (4):
      USB: f_ncm: ncm_bitrate (speed) is unsigned
      usb: f_ncm: only first packet of aggregate needs to start timer
      usb: fix various gadgets null ptr deref on 10gbps cabling.
      usb: fix various gadget panics on 10gbps cabling

Marco Elver (1):
      perf: Fix data race between pin_count increment/decrement

Marco Felsch (1):
      ASoC: max98088: fix ni clock divider calculation

Marian-Cristian Rotariu (1):
      usb: dwc3: ep0: fix NULL pointer exception

Matt Wang (1):
      scsi: vmw_pvscsi: Set correct residual data length

Matti Vaittinen (1):
      regulator: bd718x7: Fix the BUCK7 voltage setting on BD71837

Mayank Rana (1):
      usb: typec: ucsi: Clear PPM capability data in ucsi_init() error path

Ming Lei (4):
      scsi: core: Fix error handling of scsi_host_alloc()
      scsi: core: Fix failure handling of scsi_add_host_with_dma()
      scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
      scsi: core: Only put parent device if host state differs from SHOST_CREATED

Nathan Chancellor (1):
      vmlinux.lds.h: Avoid orphan section with !SMP

Neil Armstrong (1):
      usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled

Nikolay Borisov (1):
      btrfs: promote debugging asserts to full-fledged checks in validate_super

Paolo Bonzini (2):
      kvm: avoid speculation-based attacks from out-of-range memslot accesses
      kvm: fix previous commit for 32-bit builds

Rao Shoaib (1):
      RDS tcp loopback connection can hang

Ritesh Harjani (1):
      btrfs: return value from btrfs_mark_extent_written() in case of error

Sagi Grimberg (2):
      nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME
      nvmet: fix false keep-alive timeout when a controller is torn down

Saravana Kannan (2):
      spi: Fix spi device unregister flow
      spi: Don't have controller clean up spi device before driver unbind

Saubhik Mukherjee (1):
      net: appletalk: cops: Fix data race in cops_probe1

Sean Christopherson (1):
      KVM: x86: Ensure liveliness of nested VM-Enter fail tracepoint message

Sergey Senozhatsky (1):
      wq: handle VM suspension in stall detection

Shakeel Butt (1):
      cgroup: disable controllers at parse time

Shay Drory (1):
      RDMA/mlx4: Do not map the core_clock page to user space unless enabled

Srinivas Kandagatla (1):
      gpio: wcd934x: Fix shift-out-of-bounds error

Stefan Agner (1):
      USB: serial: cp210x: fix alternate function for CP2102N QFN20

Steven Rostedt (VMware) (1):
      ftrace: Do not blindly read the ip address in ftrace_bug()

Takashi Iwai (1):
      ALSA: seq: Fix race of snd_seq_timer_open()

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix the context to call snd_pcm_stop_xrun()

Thomas Petazzoni (1):
      usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling

Tiezhu Yang (1):
      MIPS: Fix kernel hang under FUNCTION_GRAPH_TRACER and PREEMPT_TRACER

Trond Myklebust (2):
      NFSv4: Fix deadlock between nfs4_evict_inode() and nfs4_opendata_get_inode()
      NFSv4: Fix second deadlock in nfs4_evict_inode()

Vijendar Mukunda (1):
      ASoC: amd: fix for pcm_read() error

Vincent Guittot (2):
      sched/fair: Keep load_avg and load_sum synced
      sched/fair: Make sure to update tg contrib for blocked load

Wang Wensheng (1):
      phy: cadence: Sierra: Fix error return code in cdns_sierra_phy_probe()

Wenli Looi (1):
      staging: rtl8723bs: Fix uninitialized variables

Wesley Cheng (2):
      usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind
      usb: dwc3: gadget: Disable gadget IRQ during pullup disable

Wolfram Sang (1):
      mmc: renesas_sdhi: abort tuning when timeout detected

Xiao Ni (1):
      async_xor: check src_offs is not NULL before updating it

Yang Li (1):
      phy: ti: Fix an error code in wiz_probe()

Yang Yingliang (1):
      scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq

Zhang Rui (1):
      Revert "ACPI: sleep: Put the FACS table after using it"

Zhen Lei (1):
      tools/bootconfig: Fix error return code in apply_xbc()

Zheyu Ma (2):
      isdn: mISDN: netjet: Fix crash in nj_probe:
      net/qla3xxx: fix schedule while atomic in ql_sem_spinlock

Zong Li (1):
      net: macb: ensure the device is available before accessing GEMGXL control registers

Zou Wei (1):
      ASoC: sti-sas: add missing MODULE_DEVICE_TABLE

Íñigo Huguet (1):
      net:sfc: fix non-freed irq in legacy irq mode

