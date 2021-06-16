Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F53A9771
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhFPKfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232399AbhFPKek (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 06:34:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 081696101B;
        Wed, 16 Jun 2021 10:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623839554;
        bh=SaVcLq/gfYYaQ8UUdkwNcu1J0MzYLPeXrQYq3tGOK2A=;
        h=From:To:Cc:Subject:Date:From;
        b=a8R7Su+Yant4lzer4f3wWCR1YfBbkMQ9Fqb2KvmS4p1kPwmVQMXwkm+MsfmJ2WyHS
         R1SirH8B8yenKc/jfibt/RGY+azSnFdJlgXXWuZ2TpWmLW6oIhKoigJK5tomakLUIg
         pZ10dH/7L8d/TyCQ8NwnV98vOTw+AV/vyVxueQ6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.11
Date:   Wed, 16 Jun 2021 12:32:17 +0200
Message-Id: <162383953748219@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.11 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml |    4 
 Documentation/virt/kvm/mmu.rst                                     |    4 
 Makefile                                                           |    7 
 arch/arm/include/asm/cpuidle.h                                     |    5 
 arch/mips/lib/mips-atomic.c                                        |   12 
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi                        |    8 
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi                        |   16 +
 arch/x86/Makefile                                                  |    5 
 arch/x86/events/intel/uncore_snbep.c                               |    9 
 arch/x86/kernel/cpu/perfctr-watchdog.c                             |    4 
 arch/x86/kvm/mmu/paging_tmpl.h                                     |   14 
 arch/x86/kvm/trace.h                                               |    6 
 arch/x86/kvm/x86.c                                                 |   13 
 crypto/async_tx/async_xor.c                                        |    3 
 drivers/acpi/bus.c                                                 |   27 -
 drivers/acpi/sleep.c                                               |    4 
 drivers/bus/mhi/pci_generic.c                                      |    2 
 drivers/gpio/gpio-wcd934x.c                                        |    2 
 drivers/gpu/drm/drm_auth.c                                         |    3 
 drivers/gpu/drm/drm_ioctl.c                                        |    9 
 drivers/gpu/drm/mcde/mcde_dsi.c                                    |    2 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                              |  155 +++++++---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h                              |    2 
 drivers/hwmon/corsair-psu.c                                        |   14 
 drivers/hwmon/tps23861.c                                           |   17 -
 drivers/i2c/busses/i2c-mpc.c                                       |   95 ++++++
 drivers/infiniband/core/uverbs_cmd.c                               |    5 
 drivers/infiniband/hw/mlx4/main.c                                  |    8 
 drivers/infiniband/hw/mlx5/cq.c                                    |    9 
 drivers/infiniband/hw/mlx5/doorbell.c                              |    7 
 drivers/infiniband/hw/mlx5/fs.c                                    |   11 
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c                       |    1 
 drivers/isdn/hardware/mISDN/netjet.c                               |    1 
 drivers/md/bcache/bcache.h                                         |    1 
 drivers/md/bcache/request.c                                        |   20 -
 drivers/md/bcache/stats.c                                          |   14 
 drivers/md/bcache/stats.h                                          |    1 
 drivers/md/bcache/sysfs.c                                          |    4 
 drivers/md/dm-verity-verify-sig.c                                  |    2 
 drivers/misc/cardreader/rtl8411.c                                  |    1 
 drivers/misc/cardreader/rts5209.c                                  |    1 
 drivers/misc/cardreader/rts5227.c                                  |    2 
 drivers/misc/cardreader/rts5228.c                                  |    1 
 drivers/misc/cardreader/rts5229.c                                  |    1 
 drivers/misc/cardreader/rts5249.c                                  |    3 
 drivers/misc/cardreader/rts5260.c                                  |    1 
 drivers/misc/cardreader/rts5261.c                                  |    1 
 drivers/misc/cardreader/rtsx_pcr.c                                 |   44 ++
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
 drivers/pinctrl/qcom/Kconfig                                       |    2 
 drivers/pinctrl/qcom/pinctrl-sdx55.c                               |   18 -
 drivers/platform/surface/aggregator/controller.c                   |    2 
 drivers/regulator/atc260x-regulator.c                              |   19 -
 drivers/regulator/bd718x7-regulator.c                              |    2 
 drivers/regulator/core.c                                           |    6 
 drivers/regulator/da9121-regulator.c                               |   10 
 drivers/regulator/fan53880.c                                       |    3 
 drivers/regulator/fixed.c                                          |    7 
 drivers/regulator/max77620-regulator.c                             |    7 
 drivers/regulator/rtmv20-regulator.c                               |   42 ++
 drivers/regulator/scmi-regulator.c                                 |    2 
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
 drivers/usb/cdns3/cdns3-gadget.c                                   |   12 
 drivers/usb/cdns3/cdnsp-ring.c                                     |    7 
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
 drivers/usb/host/xhci-pci.c                                        |    7 
 drivers/usb/host/xhci.h                                            |    1 
 drivers/usb/misc/brcmstb-usb-pinmap.c                              |    2 
 drivers/usb/musb/musb_core.c                                       |    3 
 drivers/usb/serial/cp210x.c                                        |   84 +++++
 drivers/usb/serial/ftdi_sio.c                                      |    1 
 drivers/usb/serial/ftdi_sio_ids.h                                  |    1 
 drivers/usb/serial/omninet.c                                       |    2 
 drivers/usb/serial/quatech2.c                                      |    6 
 drivers/usb/typec/mux.c                                            |    2 
 drivers/usb/typec/mux/intel_pmc_mux.c                              |    9 
 drivers/usb/typec/tcpm/tcpm.c                                      |   84 +++--
 drivers/usb/typec/tcpm/wcove.c                                     |    2 
 drivers/usb/typec/ucsi/ucsi.c                                      |    1 
 fs/btrfs/disk-io.c                                                 |   26 +
 fs/btrfs/file.c                                                    |    4 
 fs/btrfs/tree-log.c                                                |   16 +
 fs/btrfs/zoned.c                                                   |   23 +
 fs/coredump.c                                                      |    2 
 fs/nfs/client.c                                                    |    2 
 fs/nfs/nfs4_fs.h                                                   |    1 
 fs/nfs/nfs4client.c                                                |    2 
 fs/nfs/nfs4proc.c                                                  |   29 +
 fs/proc/base.c                                                     |   11 
 include/asm-generic/vmlinux.lds.h                                  |    1 
 include/dt-bindings/usb/pd.h                                       |   20 -
 include/linux/entry-kvm.h                                          |    3 
 include/linux/kvm_host.h                                           |   10 
 include/linux/mfd/rohm-bd71828.h                                   |   10 
 include/linux/mlx4/device.h                                        |    1 
 include/linux/rtsx_pci.h                                           |    2 
 include/linux/sched.h                                              |    8 
 include/linux/tick.h                                               |    7 
 include/linux/usb/pd.h                                             |    2 
 include/linux/usb/pd_ext_sdb.h                                     |    4 
 kernel/bpf/btf.c                                                   |   12 
 kernel/bpf/verifier.c                                              |   14 
 kernel/cgroup/cgroup-v1.c                                          |    4 
 kernel/cgroup/cgroup.c                                             |   13 
 kernel/entry/common.c                                              |    5 
 kernel/events/core.c                                               |    2 
 kernel/sched/debug.c                                               |    3 
 kernel/sched/fair.c                                                |   18 -
 kernel/sched/pelt.h                                                |   11 
 kernel/time/tick-sched.c                                           |    1 
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
 sound/soc/codecs/lpass-rx-macro.c                                  |    1 
 sound/soc/codecs/lpass-tx-macro.c                                  |    1 
 sound/soc/codecs/max98088.c                                        |   13 
 sound/soc/codecs/sti-sas.c                                         |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                              |   25 +
 sound/soc/soc-core.c                                               |    2 
 sound/soc/sof/pm.c                                                 |    1 
 tools/bootconfig/include/linux/bootconfig.h                        |    4 
 tools/bootconfig/main.c                                            |    1 
 tools/perf/util/session.c                                          |    1 
 tools/testing/selftests/bpf/verifier/stack_ptr.c                   |    2 
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c             |    8 
 188 files changed, 1242 insertions(+), 475 deletions(-)

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

Axel Lin (7):
      regulator: da9121: Return REGULATOR_MODE_INVALID for invalid mode
      regulator: fan53880: Fix missing n_voltages setting
      regulator: fixed: Ensure enable_counter is correct if reg_domain_disable fails
      regulator: scmi: Fix off-by-one for linear regulators .n_voltages setting
      regulator: bd71828: Fix .n_voltages settings
      regulator: atc260x: Fix n_voltages and min_sel for pickable linear ranges
      regulator: rtmv20: Fix .set_current_limit/.get_current_limit callbacks

Bixuan Cui (1):
      ASoC: codecs: lpass-tx-macro: add missing MODULE_DEVICE_TABLE

Bjorn Andersson (2):
      usb: typec: mux: Fix copy-paste mistake in typec_mux_match
      pinctrl: qcom: Make it possible to select SC8180x TLMM

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

Coly Li (2):
      bcache: remove bcache device self-defined readahead
      bcache: avoid oversized read request in cache missing code path

Dai Ngo (1):
      NFSv4: nfs4_proc_set_acl needs to restore NFS_CAP_UIDGID_NOMAP on error.

Dan Carpenter (2):
      net: mdiobus: get rid of a BUG_ON()
      NFS: Fix a potential NULL dereference in nfs_get_client()

Daniel Borkmann (1):
      bpf, selftests: Adjust few selftest result_unpriv outcomes

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

Eric W. Biederman (1):
      coredump: Limit what can interrupt coredumps

Frederic Weisbecker (1):
      tick/nohz: Only check for RCU deferred wakeup on user/guest entry when needed

Geert Uytterhoeven (1):
      mmc: renesas_sdhi: Fix HS400 on R-Car M3-W+

George McCollister (2):
      net: dsa: microchip: enable phy errata workaround on 9567
      USB: serial: ftdi_sio: add NovaTech OrionMX product ID

Greg Kroah-Hartman (1):
      Linux 5.12.11

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

Jiri Olsa (2):
      bpf: Forbid trampoline attach for functions with variable arguments
      bpf: Add deny list of btf ids check for tracing programs

Johan Hovold (2):
      USB: serial: quatech2: fix control-request directions
      USB: serial: cp210x: fix CP2102N-A01 modem control

Johannes Berg (2):
      bonding: init notify_work earlier to avoid uninitialized use
      netlink: disable IRQs for netlink_lock_table()

John Keeping (1):
      dm verity: fix require_signatures module_param permissions

Jonathan Marek (3):
      drm/msm/a6xx: fix incorrectly set uavflagprd_inv field for A650
      drm/msm/a6xx: update/fix CP_PROTECT initialization
      drm/msm/a6xx: avoid shadow NULL reference in failure path

Josef Bacik (1):
      btrfs: do not write supers if we have an fs error

Kai Vehmanen (1):
      ASoC: SOF: reset enabled_cores state at suspend

Kamal Heib (1):
      RDMA/ipoib: Fix warning caused by destroying non-initial netns

Kan Liang (2):
      perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server
      perf/x86/intel/uncore: Fix a kernel WARNING triggered by maxcpus=1

Karen Dombroski (1):
      spi: spi-zynq-qspi: Fix stack violation bug

Kees Cook (1):
      proc: Track /proc/$pid/attr/ opener mm_struct

Kefeng Wang (1):
      ASoC: core: Fix Null-point-dereference in fmt_single_name()

Kyle Tso (6):
      usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms
      usb: typec: tcpm: Properly handle Alert and Status Messages
      usb: typec: tcpm: Do not finish VDM AMS for retrying Responses
      usb: typec: tcpm: Correct the responses in SVDM Version 2.0 DFP
      usb: typec: tcpm: Fix misuses of AMS invocation
      dt-bindings: connector: Replace BIT macro with generic bit ops

Lai Jiangshan (2):
      KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
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

Manivannan Sadhasivam (1):
      pinctrl: qcom: Fix duplication in gpio_groups

Maor Gottlieb (1):
      RDMA: Verify port when creating flow rule

Marco Elver (1):
      perf: Fix data race between pin_count increment/decrement

Marco Felsch (1):
      ASoC: max98088: fix ni clock divider calculation

Marian-Cristian Rotariu (1):
      usb: dwc3: ep0: fix NULL pointer exception

Mario Limonciello (1):
      usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD Renoir

Mark Bloch (1):
      RDMA/mlx5: Block FDB rules when not in switchdev mode

Mark Zhang (1):
      RDMA/mlx5: Use different doorbell memory for different processes

Masami Hiramatsu (1):
      tools/bootconfig: Fix a build error accroding to undefined fallthrough

Matt Wang (1):
      scsi: vmw_pvscsi: Set correct residual data length

Matti Vaittinen (1):
      regulator: bd718x7: Fix the BUCK7 voltage setting on BD71837

Maximilian Luz (1):
      platform/surface: aggregator: Fix event disable function

Mayank Rana (1):
      usb: typec: ucsi: Clear PPM capability data in ucsi_init() error path

Mika Westerberg (1):
      ACPI: Pass the same capabilities to the _OSC regardless of the query flag

Ming Lei (4):
      scsi: core: Fix error handling of scsi_host_alloc()
      scsi: core: Fix failure handling of scsi_add_host_with_dma()
      scsi: core: Put .shost_dev in failure path if host state changes to RUNNING
      scsi: core: Only put parent device if host state differs from SHOST_CREATED

Naohiro Aota (1):
      btrfs: zoned: fix zone number to sector/physical calculation

Nathan Chancellor (1):
      vmlinux.lds.h: Avoid orphan section with !SMP

Neil Armstrong (1):
      usb: dwc3-meson-g12a: fix usb2 PHY glue init when phy0 is disabled

Nick Desaulniers (1):
      Makefile: LTO: have linker check -Wframe-larger-than

Nikolay Borisov (1):
      btrfs: promote debugging asserts to full-fledged checks in validate_super

Paolo Bonzini (2):
      kvm: avoid speculation-based attacks from out-of-range memslot accesses
      kvm: fix previous commit for 32-bit builds

Pawel Laszczak (1):
      usb: cdnsp: Fix deadlock issue in cdnsp_thread_irq_handler

Rao Shoaib (1):
      RDS tcp loopback connection can hang

Ricky Wu (1):
      misc: rtsx: separate aspm mode into MODE_REG and MODE_CFG

Ritesh Harjani (1):
      btrfs: return value from btrfs_mark_extent_written() in case of error

Robert Marko (3):
      hwmon: (tps23861) define regmap max register
      hwmon: (tps23861) set current shunt value
      hwmon: (tps23861) correct shunt LSB values

Sagi Grimberg (2):
      nvme-tcp: remove incorrect Kconfig dep in BLK_DEV_NVME
      nvmet: fix false keep-alive timeout when a controller is torn down

Sanket Parmar (1):
      usb: cdns3: Enable TDL_CHK only for OUT ep

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

Srinivas Kandagatla (2):
      ASoC: codecs: lpass-rx-macro: add missing MODULE_DEVICE_TABLE
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

Tor Vic (1):
      x86, lto: Pass -stack-alignment only on LLD < 13.0.0

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

Wei Yongjun (1):
      bus: mhi: pci_generic: Fix possible use-after-free in mhi_pci_remove()

Wenli Looi (1):
      staging: rtl8723bs: Fix uninitialized variables

Wesley Cheng (2):
      usb: gadget: f_fs: Ensure io_completion_wq is idle during unbind
      usb: dwc3: gadget: Disable gadget IRQ during pullup disable

Wilken Gottwalt (1):
      hwmon: (corsair-psu) fix suspend behavior

Wolfram Sang (1):
      mmc: renesas_sdhi: abort tuning when timeout detected

Xiao Ni (1):
      async_xor: check src_offs is not NULL before updating it

Yang Li (1):
      phy: ti: Fix an error code in wiz_probe()

Yang Yingliang (2):
      scsi: hisi_sas: Drop free_irq() of devm_request_irq() allocated irq
      usb: misc: brcmstb-usb-pinmap: check return value after calling platform_get_resource()

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

