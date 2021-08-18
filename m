Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F893EFE16
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbhHRHpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239307AbhHRHpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 382F960FDA;
        Wed, 18 Aug 2021 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629272679;
        bh=iu0mKdv1xOvSqXZ9taJIse3l/0vB2mp23YbgRwfDzmE=;
        h=From:To:Cc:Subject:Date:From;
        b=LT+Y5TyzXBuHrPGw3xyg2MBtIo1feFgXOEfw4bSJusTsdh8YrhlmfPzs4KlrfOApW
         B36WUwkILOpd8pRRJ8WncJywUIE7JAvzzpzGavdBxvGVSzNKz++vEjLIjhz3Xja02p
         mFuNaMXLcK2JhbFKe+OYZYnwUSDHMVUEUbGIDxE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.12
Date:   Wed, 18 Aug 2021 09:44:33 +0200
Message-Id: <162927267320059@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.12 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/locking.rst                           |    8 
 Makefile                                                     |    2 
 arch/arc/kernel/fpu.c                                        |    9 
 arch/arm64/kvm/hyp/nvhe/mem_protect.c                        |    2 
 arch/powerpc/include/asm/interrupt.h                         |    3 
 arch/powerpc/include/asm/irq.h                               |    2 
 arch/powerpc/include/asm/ptrace.h                            |   16 +
 arch/powerpc/kernel/asm-offsets.c                            |   31 +-
 arch/powerpc/kernel/head_book3s_32.S                         |    2 
 arch/powerpc/kernel/head_booke.h                             |   27 --
 arch/powerpc/kernel/irq.c                                    |    7 
 arch/powerpc/kernel/kprobes.c                                |    3 
 arch/powerpc/kernel/sysfs.c                                  |    2 
 arch/powerpc/kernel/time.c                                   |    2 
 arch/powerpc/kernel/traps.c                                  |    9 
 arch/powerpc/platforms/pseries/setup.c                       |    5 
 arch/powerpc/sysdev/xive/common.c                            |   35 ++-
 arch/riscv/kernel/Makefile                                   |    2 
 arch/x86/events/intel/core.c                                 |   23 +-
 arch/x86/events/perf_event.h                                 |   15 +
 arch/x86/include/asm/kvm_host.h                              |    7 
 arch/x86/include/asm/svm.h                                   |    2 
 arch/x86/kernel/apic/io_apic.c                               |    6 
 arch/x86/kernel/apic/msi.c                                   |   11 
 arch/x86/kernel/cpu/resctrl/monitor.c                        |   27 +-
 arch/x86/kernel/hpet.c                                       |    2 
 arch/x86/kvm/mmu/mmu.c                                       |   28 ++
 arch/x86/kvm/mmu/tdp_mmu.c                                   |   26 +-
 arch/x86/kvm/svm/nested.c                                    |   12 -
 arch/x86/kvm/svm/svm.c                                       |    9 
 arch/x86/kvm/vmx/nested.c                                    |    3 
 arch/x86/kvm/vmx/vmx.h                                       |    2 
 arch/x86/tools/chkobjdump.awk                                |    1 
 block/blk-cgroup.c                                           |   14 -
 drivers/acpi/nfit/core.c                                     |    3 
 drivers/base/core.c                                          |    1 
 drivers/block/nbd.c                                          |   14 -
 drivers/firmware/efi/libstub/arm64-stub.c                    |   69 +++++-
 drivers/firmware/efi/libstub/randomalloc.c                   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c                |   12 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                      |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c            |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c        |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c        |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c             |    2 
 drivers/gpu/drm/i915/display/intel_display.c                 |   34 ++
 drivers/gpu/drm/i915/gvt/handlers.c                          |    1 
 drivers/gpu/drm/i915/gvt/mmio_context.c                      |    2 
 drivers/gpu/drm/i915/i915_gpu_error.c                        |   19 +
 drivers/gpu/drm/i915/i915_reg.h                              |   16 -
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                      |    3 
 drivers/gpu/drm/mediatek/mtk_drm_plane.c                     |   60 ++---
 drivers/gpu/drm/meson/meson_registers.h                      |    5 
 drivers/gpu/drm/meson/meson_viu.c                            |    7 
 drivers/i2c/busses/i2c-bcm-iproc.c                           |    4 
 drivers/i2c/i2c-dev.c                                        |    5 
 drivers/iio/adc/palmas_gpadc.c                               |    4 
 drivers/iio/adc/ti-ads7950.c                                 |    1 
 drivers/iio/humidity/hdc100x.c                               |    6 
 drivers/iio/imu/adis.c                                       |    3 
 drivers/infiniband/hw/mlx5/cq.c                              |    4 
 drivers/infiniband/hw/mlx5/devx.c                            |    3 
 drivers/net/bareudp.c                                        |   16 -
 drivers/net/dsa/hirschmann/hellcreek.c                       |    7 
 drivers/net/dsa/lan9303-core.c                               |   34 +-
 drivers/net/dsa/lantiq_gswip.c                               |   14 -
 drivers/net/dsa/microchip/ksz8795.c                          |   82 +++++--
 drivers/net/dsa/microchip/ksz8795_reg.h                      |    4 
 drivers/net/dsa/microchip/ksz_common.h                       |    9 
 drivers/net/dsa/mt7530.c                                     |    1 
 drivers/net/dsa/qca/ar9331.c                                 |   73 ++++++
 drivers/net/dsa/sja1105/sja1105_main.c                       |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c                  |   13 -
 drivers/net/ethernet/intel/ice/ice.h                         |    1 
 drivers/net/ethernet/intel/ice/ice_main.c                    |   28 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c             |    7 
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cq.c                 |    1 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c     |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c          |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c            |   33 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                 |   20 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c         |    1 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   |   14 -
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c          |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/main.c               |   12 -
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h          |    5 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c   |    4 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c |    2 
 drivers/net/ethernet/ti/cpsw_new.c                           |    7 
 drivers/net/ethernet/ti/cpsw_priv.h                          |    4 
 drivers/net/ieee802154/mac802154_hwsim.c                     |    6 
 drivers/net/phy/micrel.c                                     |    2 
 drivers/net/ppp/ppp_generic.c                                |    2 
 drivers/net/wwan/mhi_wwan_ctrl.c                             |   12 -
 drivers/nvdimm/namespace_devs.c                              |   17 -
 drivers/pci/msi.c                                            |  125 ++++++-----
 drivers/pinctrl/intel/pinctrl-tigerlake.c                    |   26 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c             |    8 
 drivers/pinctrl/pinctrl-k210.c                               |   26 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                        |    8 
 drivers/platform/x86/pcengines-apuv2.c                       |    2 
 drivers/scsi/lpfc/lpfc_init.c                                |    3 
 drivers/usb/dwc3/gadget.c                                    |   18 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c                            |    3 
 drivers/xen/events/events_base.c                             |   20 +
 fs/ceph/caps.c                                               |   17 +
 fs/ceph/mds_client.c                                         |   25 +-
 fs/ceph/snap.c                                               |   54 +++-
 fs/ceph/super.h                                              |    2 
 fs/cifs/cifsglob.h                                           |    5 
 fs/cifs/dir.c                                                |    2 
 fs/cifs/file.c                                               |   35 +--
 fs/cifs/inode.c                                              |   19 +
 fs/cifs/misc.c                                               |   50 +++-
 fs/cifs/smb2pdu.c                                            |    2 
 fs/io-wq.c                                                   |   26 +-
 fs/io_uring.c                                                |   26 +-
 fs/overlayfs/file.c                                          |   47 ++++
 include/asm-generic/vmlinux.lds.h                            |    1 
 include/linux/bpf-cgroup.h                                   |    4 
 include/linux/device.h                                       |    1 
 include/linux/inetdevice.h                                   |    2 
 include/linux/irq.h                                          |    2 
 include/linux/mlx5/driver.h                                  |    3 
 include/linux/msi.h                                          |    2 
 include/net/psample.h                                        |    2 
 include/uapi/linux/neighbour.h                               |    7 
 kernel/bpf/hashtab.c                                         |    4 
 kernel/bpf/helpers.c                                         |    4 
 kernel/cgroup/rstat.c                                        |   19 -
 kernel/irq/chip.c                                            |    5 
 kernel/irq/msi.c                                             |   13 -
 kernel/irq/timings.c                                         |    5 
 kernel/locking/rtmutex.c                                     |    2 
 kernel/seccomp.c                                             |    2 
 lib/devmem_is_allowed.c                                      |    2 
 mm/slub.c                                                    |    4 
 net/bridge/br.c                                              |    3 
 net/bridge/br_fdb.c                                          |   11 
 net/bridge/br_if.c                                           |    2 
 net/bridge/br_private.h                                      |    2 
 net/bridge/netfilter/nf_conntrack_bridge.c                   |    6 
 net/core/link_watch.c                                        |    5 
 net/ieee802154/socket.c                                      |    7 
 net/ipv4/igmp.c                                              |   21 +
 net/ipv4/tcp_bbr.c                                           |    2 
 net/sched/act_mirred.c                                       |    3 
 net/smc/af_smc.c                                             |    2 
 net/smc/smc_core.c                                           |    4 
 net/smc/smc_core.h                                           |    4 
 net/smc/smc_llc.c                                            |   10 
 net/smc/smc_tx.c                                             |   18 +
 net/smc/smc_wr.c                                             |   10 
 net/vmw_vsock/virtio_transport.c                             |    7 
 sound/soc/amd/acp-pcm-dma.c                                  |    2 
 sound/soc/amd/raven/acp3x-pcm-dma.c                          |    2 
 sound/soc/amd/renoir/acp3x-pdm-dma.c                         |    2 
 sound/soc/codecs/cs42l42.c                                   |   83 ++++---
 sound/soc/codecs/cs42l42.h                                   |    3 
 sound/soc/codecs/tlv320aic31xx.c                             |   10 
 sound/soc/intel/atom/sst-mfld-platform-pcm.c                 |    3 
 sound/soc/kirkwood/kirkwood-dma.c                            |   26 +-
 sound/soc/sof/intel/Kconfig                                  |    4 
 sound/soc/sof/intel/hda-ipc.c                                |    4 
 sound/soc/uniphier/aio-dma.c                                 |    2 
 sound/soc/xilinx/xlnx_formatter_pcm.c                        |    4 
 tools/lib/bpf/btf.c                                          |    3 
 tools/lib/bpf/libbpf_probes.c                                |    4 
 tools/testing/selftests/sgx/sigstruct.c                      |   41 +--
 171 files changed, 1392 insertions(+), 657 deletions(-)

Alex Deucher (2):
      drm/amdgpu: don't enable baco on boco platforms in runpm
      drm/amdgpu: handle VCN instances when harvesting (v2)

Alex Vesker (1):
      net/mlx5: DR, Add fail on error check on decap

Andre Przywara (1):
      pinctrl: sunxi: Don't underestimate number of functions

Andy Shevchenko (1):
      pinctrl: tigerlake: Fix GPIO mapping for newer version of software

Anirudh Venkataramanan (2):
      ice: Prevent probing virtual functions
      ice: Stop processing VF messages during teardown

Ankit Nautiyal (1):
      drm/i915/display: Fix the 12 BPC bits for PIPE_MISC reg

Anson Jacob (1):
      drm/amd/display: use GFP_ATOMIC in amdgpu_dm_irq_schedule_work

Antti Keränen (1):
      iio: adis: set GPIO reset pin direction

Ard Biesheuvel (3):
      efi/libstub: arm64: Force Image reallocation if BSS was not reserved
      efi/libstub: arm64: Relax 2M alignment again for relocatable kernels
      efi/libstub: arm64: Double check image alignment at entry

Aya Levin (2):
      net/mlx5: Block switchdev mode while devlink traps are active
      net/mlx5: Fix return value from tracer initialization

Babu Moger (1):
      x86/resctrl: Fix default monitoring groups reporting

Ben Dai (1):
      genirq/timings: Prevent potential array overflow in __irq_timings_store()

Ben Hutchings (8):
      net: phy: micrel: Fix link detection on ksz87xx switch"
      net: dsa: microchip: Fix ksz_read64()
      net: dsa: microchip: ksz8795: Fix PVID tag insertion
      net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
      net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion
      net: dsa: microchip: ksz8795: Use software untagging on CPU port
      net: dsa: microchip: ksz8795: Fix VLAN filtering
      net: dsa: microchip: ksz8795: Don't use phy_port_cnt in VLAN table lookup

Benjamin Herrenschmidt (1):
      arm64: efi: kaslr: Fix occasional random alloc (and boot) failure

Bixuan Cui (1):
      genirq/msi: Ensure deactivation on teardown

Brett Creeley (1):
      ice: don't remove netdev->dev_addr from uc sync list

Changbin Du (1):
      riscv: kexec: do not add '-mno-relax' flag if compiler doesn't support it

Chris Lesiak (1):
      iio: humidity: hdc100x: Add margin to the conversion time

Chris Mi (1):
      net/mlx5e: TC, Fix error handling memory leak

Christian Hewitt (1):
      drm/meson: fix colour distortion from HDR set during vendor u-boot

Christophe JAILLET (1):
      drm/amd/pm: Fix a memory leak in an error handling path in 'vangogh_tables_init()'

Christophe Leroy (5):
      powerpc/interrupt: Fix OOPS by not calling do_IRQ() from timer_interrupt()
      powerpc/interrupt: Do not call single_step_exception() from other exceptions
      powerpc/32s: Fix napping restore in data storage interrupt (DSI)
      powerpc/smp: Fix OOPS in topology_init()
      powerpc/32: Fix critical and debug interrupts on BOOKE

Colin Ian King (1):
      iio: adc: Fix incorrect exit of for-loop

Cédric Le Goater (1):
      powerpc/xive: Do not skip CPU-less nodes when creating the IPIs

DENG Qingfang (1):
      net: dsa: mt7530: add the missing RxUnicast MIB counter

Damien Le Moal (1):
      pinctrl: k210: Fix k210_fpioa_probe()

Dan Williams (2):
      ACPI: NFIT: Fix support for virtual SPA ranges
      libnvdimm/region: Fix label activation vs errors

Daniel Xu (1):
      libbpf: Do not close un-owned FD 0 on errors

David Brazdil (1):
      KVM: arm64: Fix off-by-one in range_is_memory

Dhananjay Phadke (1):
      i2c: iproc: fix race between client unreg and tasklet

Dongliang Mu (2):
      ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
      ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Eric Bernstein (1):
      drm/amd/display: Remove invalid assert for ODM + MPC case

Eric Dumazet (2):
      net: igmp: fix data-race in igmp_ifc_timer_expire()
      net: igmp: increase size of mr_ifc_count

Ewan D. Milne (1):
      scsi: lpfc: Move initialization of phba->poll_list earlier to avoid crash

Greg Kroah-Hartman (3):
      Revert "usb: dwc3: gadget: Use list_replace_init() before traversing lists"
      i2c: dev: zero out array used for i2c reads from userspace
      Linux 5.13.12

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases

Guennadi Liakhovetski (1):
      ASoC: SOF: Intel: hda-ipc: fix reply size checking

Guillaume Nault (1):
      bareudp: Fix invalid read beyond skb's linear data

Guvenc Gulce (1):
      net/smc: Correct smc link connection counter in case of smc client

Hangbin Liu (1):
      net: sched: act_mirred: Reset ct info when mirror/redirect skb

Hans de Goede (1):
      platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables

Hao Xu (2):
      io-wq: fix bug of creating io-wokers unconditionally
      io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()

Hsin-Yi Wang (1):
      pinctrl: mediatek: Fix fallback behavior for bias_set_combo

Hsuan-Chi Kuo (1):
      seccomp: Fix setting loaded filter count during TSYNC

Jeff Layton (3):
      ceph: add some lockdep assertions around snaprealm handling
      ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
      ceph: take snap_empty_lock atomically with snaprealm refcount change

Jens Axboe (1):
      io_uring: drop ctx->uring_lock before flushing work item

John Hubbard (1):
      net: mvvp2: fix short frame size on s390

Kan Liang (1):
      perf/x86/intel: Apply mid ACK for small core

Karsten Graul (1):
      net/smc: fix wait on already cleared link

Kuan-Ying Lee (1):
      kasan, slub: reset tag when printing address

Laurent Dufour (1):
      powerpc/pseries: Fix update of LPAR security flavor after LPM

Leon Romanovsky (1):
      net/mlx5: Don't skip subfunction cleanup in case of error in module init

Liang Wang (1):
      lib: use PFN_PHYS() in devmem_is_allowed()

Loic Poulain (1):
      net: wwan: mhi_wwan_ctrl: Fix possible deadlock

Longpeng(Mike) (1):
      vsock/virtio: avoid potential deadlock when vsock device remove

Luis Henriques (1):
      ceph: reduce contention in ceph_check_delayed_caps()

Mark Brown (1):
      ASoC: tlv320aic31xx: Fix jack detection after suspend

Matt Roper (1):
      drm/i915: Only access SFC_DONE when media domain is not fused off

Maxim Levitsky (2):
      KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
      KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)

Maxim Mikityanskiy (1):
      net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free

Maximilian Heyne (1):
      xen/events: Fix race in set_evtchn_to_irq

Md Fahad Iqbal Polash (1):
      iavf: Set RSS LUT and key in reset handle path

Miklos Szeredi (1):
      ovl: fix deadlock in splice write

Nadav Amit (1):
      io_uring: clear TIF_NOTIFY_SIGNAL when running task work

Nathan Chancellor (1):
      vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
      tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Nikolay Aleksandrov (1):
      net: bridge: fix flags interpretation for extern learn fdb entries

Oleksij Rempel (1):
      net: dsa: qca: ar9331: make proper initial port defaults

Pali Rohár (1):
      ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pavel Begunkov (1):
      io_uring: fix ctx-exit io_rsrc_put_work() deadlock

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: Kconfig: fix SoundWire dependencies

Pu Lehui (1):
      powerpc/kprobes: Fix kprobe Oops happens in booke

Randy Dunlap (1):
      x86/tools: Fix objdump version check again

Richard Fitzgerald (8):
      ASoC: cs42l42: Correct definition of ADC Volume control
      ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
      ASoC: cs42l42: Fix bclk calculation for mono
      ASoC: cs42l42: Fix inversion of ADC Notch Switch control
      ASoC: cs42l42: Remove duplicate control for WNF filter frequency
      ASoC: cs42l42: PLL must be running when changing MCLK_SRC_SEL
      ASoC: cs42l42: Fix LRCLK frame start edge
      ASoC: cs42l42: Fix mono playback

Robin Gögge (1):
      libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT

Rohith Surabattula (2):
      cifs: Handle race conditions during rename
      cifs: Call close synchronously during unlink/rename/lease break.

Roi Dayan (2):
      psample: Add a fwd declaration for skbuff
      net/mlx5e: Avoid creating tunnel headers for local route

Ronnie Sahlberg (1):
      cifs: use the correct max-length for dentry_path_raw()

Sean Christopherson (4):
      KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation
      KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF
      KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all SPTEs
      KVM: x86/mmu: Protect marking SPs unsync when using TDP MMU with spinlock

Shay Drory (1):
      net/mlx5: Synchronize correct IRQ when destroying CQ

Shyam Prasad N (1):
      cifs: create sd context must be a multiple of 8

Solomon Chiu (1):
      drm/amdgpu: Add preferred mode in modeset when freesync video mode's enabled.

Takashi Iwai (5):
      ASoC: amd: Fix reference to PCM buffer address
      ASoC: xilinx: Fix reference to PCM buffer address
      ASoC: uniphier: Fix reference to PCM buffer address
      ASoC: kirkwood: Fix reference to PCM buffer address
      ASoC: intel: atom: Fix reference to PCM buffer address

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow involving bucket_size

Tejun Heo (1):
      cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync

Thomas Gleixner (11):
      genirq: Provide IRQCHIP_AFFINITY_PRE_STARTUP
      x86/msi: Force affinity setup before startup
      x86/ioapic: Force affinity setup before startup
      PCI/MSI: Enable and mask MSI-X early
      PCI/MSI: Mask all unused MSI-X entries
      PCI/MSI: Enforce that MSI-X table entry is masked for update
      PCI/MSI: Enforce MSI[X] entry updates to be visible
      PCI/MSI: Do not set invalid bits in MSI mask
      PCI/MSI: Correct misleading comments
      PCI/MSI: Use msi_mask_irq() in pci_msi_shutdown()
      PCI/MSI: Protect msi_desc::masked for multi-MSI

Tianjia Zhang (1):
      selftests/sgx: Fix Q1 and Q2 calculation in sigstruct.c

Uwe Kleine-König (1):
      iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels

Vineet Gupta (1):
      ARC: fp: set FPU_STATUS.FWE to enable FPU_STATUS update on context switch

Vladimir Oltean (4):
      net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
      net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
      net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
      net: dsa: sja1105: fix broken backpressure in .port_fdb_dump

Willy Tarreau (1):
      net: linkwatch: fix failure to restore device state across suspend/resume

Xie Yongji (1):
      nbd: Aovid double completion of a request

Yajun Deng (1):
      netfilter: nf_conntrack_bridge: Fix memory leak when error

Yang Yingliang (1):
      net: bridge: fix memleak in br_add_if()

Yonghong Song (1):
      bpf: Fix potentially incorrect results with bpf_get_local_storage()

Zhen Lei (1):
      locking/rtmutex: Use the correct rtmutex debugging config option

Zhenyu Wang (1):
      drm/i915/gvt: Fix cached atomics setting for Windows VM

jason-jh.lin (1):
      drm/mediatek: Fix cursor plane no update

