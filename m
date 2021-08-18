Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1F93EFE13
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhHRHpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239265AbhHRHpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 03:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1170460FDA;
        Wed, 18 Aug 2021 07:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629272672;
        bh=4iXDVJtOae66rv33+Zjms1JQPPWAK0UvWfp4rrZBNa8=;
        h=From:To:Cc:Subject:Date:From;
        b=vX2v7MJNa7s02RzlfpG21nbybROrPfXScT76dX2Dm/uJGuZVTHy5336YFQ61/Ps+/
         17oewKWoaJMYIGhOpsEdqDhZsKVKROmB2Co0DG/wc7G7pMaNlfirDlatEFHURP/Dxr
         oITPUZMQniGOe5ovuYBuWhCHPDRgH8LOw4GvFoDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.60
Date:   Wed, 18 Aug 2021 09:44:26 +0200
Message-Id: <1629272666165248@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.60 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/arc/kernel/fpu.c                                      |    9 
 arch/powerpc/kernel/kprobes.c                              |    3 
 arch/powerpc/kernel/sysfs.c                                |    2 
 arch/x86/include/asm/svm.h                                 |    2 
 arch/x86/kernel/apic/io_apic.c                             |    6 
 arch/x86/kernel/apic/msi.c                                 |   13 -
 arch/x86/kernel/cpu/resctrl/monitor.c                      |   27 +-
 arch/x86/kvm/svm/nested.c                                  |   14 +
 arch/x86/kvm/svm/svm.c                                     |    8 
 arch/x86/kvm/vmx/nested.c                                  |    3 
 arch/x86/kvm/vmx/vmx.h                                     |    2 
 arch/x86/tools/chkobjdump.awk                              |    1 
 drivers/acpi/nfit/core.c                                   |    3 
 drivers/base/core.c                                        |    1 
 drivers/block/nbd.c                                        |   14 +
 drivers/firmware/efi/libstub/arm64-stub.c                  |   69 ++++++-
 drivers/firmware/efi/libstub/randomalloc.c                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                    |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c      |    2 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c      |    1 
 drivers/gpu/drm/i915/i915_gpu_error.c                      |   19 +
 drivers/gpu/drm/meson/meson_registers.h                    |    5 
 drivers/gpu/drm/meson/meson_viu.c                          |    7 
 drivers/i2c/i2c-dev.c                                      |    5 
 drivers/iio/adc/palmas_gpadc.c                             |    4 
 drivers/iio/adc/ti-ads7950.c                               |    1 
 drivers/iio/humidity/hdc100x.c                             |    6 
 drivers/iio/imu/adis.c                                     |    3 
 drivers/infiniband/hw/mlx5/cq.c                            |    4 
 drivers/infiniband/hw/mlx5/devx.c                          |    3 
 drivers/net/bareudp.c                                      |   16 +
 drivers/net/dsa/lan9303-core.c                             |   34 +--
 drivers/net/dsa/lantiq_gswip.c                             |   14 +
 drivers/net/dsa/microchip/ksz8795.c                        |   91 ++++++++-
 drivers/net/dsa/microchip/ksz_common.c                     |    2 
 drivers/net/dsa/microchip/ksz_common.h                     |    9 
 drivers/net/dsa/mt7530.c                                   |    1 
 drivers/net/dsa/sja1105/sja1105_main.c                     |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c                |   13 -
 drivers/net/ethernet/intel/ice/ice_main.c                  |   28 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cq.c               |    1 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |   13 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c               |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        |    4 
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |    4 
 drivers/net/ethernet/ti/cpsw_new.c                         |    7 
 drivers/net/ethernet/ti/cpsw_priv.h                        |    4 
 drivers/net/ieee802154/mac802154_hwsim.c                   |    6 
 drivers/net/phy/micrel.c                                   |    2 
 drivers/net/ppp/ppp_generic.c                              |    2 
 drivers/nvdimm/namespace_devs.c                            |   17 +
 drivers/pci/msi.c                                          |  125 ++++++++-----
 drivers/pinctrl/intel/pinctrl-tigerlake.c                  |   26 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c           |    8 
 drivers/platform/x86/pcengines-apuv2.c                     |    2 
 drivers/scsi/lpfc/lpfc_init.c                              |    3 
 drivers/vdpa/mlx5/net/mlx5_vnet.c                          |    3 
 drivers/xen/events/events_base.c                           |   20 +-
 fs/ceph/caps.c                                             |   17 +
 fs/ceph/mds_client.c                                       |   25 +-
 fs/ceph/snap.c                                             |   54 +++--
 fs/ceph/super.h                                            |    2 
 fs/cifs/smb2pdu.c                                          |    2 
 fs/vboxsf/dir.c                                            |   48 ++++
 fs/vboxsf/file.c                                           |   71 ++++---
 fs/vboxsf/vfsmod.h                                         |    7 
 include/asm-generic/vmlinux.lds.h                          |    1 
 include/linux/device.h                                     |    1 
 include/linux/inetdevice.h                                 |    2 
 include/linux/irq.h                                        |    2 
 include/linux/mlx5/driver.h                                |    3 
 include/linux/msi.h                                        |    2 
 include/net/psample.h                                      |    2 
 include/uapi/linux/neighbour.h                             |    7 
 kernel/bpf/hashtab.c                                       |    4 
 kernel/irq/chip.c                                          |    5 
 kernel/irq/msi.c                                           |   13 -
 kernel/irq/timings.c                                       |    5 
 kernel/seccomp.c                                           |    2 
 net/bridge/br_fdb.c                                        |   23 +-
 net/bridge/br_if.c                                         |    2 
 net/bridge/netfilter/nf_conntrack_bridge.c                 |    6 
 net/core/link_watch.c                                      |    5 
 net/ieee802154/socket.c                                    |    7 
 net/ipv4/igmp.c                                            |   21 +-
 net/ipv4/tcp_bbr.c                                         |    2 
 net/sched/act_mirred.c                                     |    3 
 net/smc/smc_core.h                                         |    2 
 net/smc/smc_llc.c                                          |   10 -
 net/smc/smc_tx.c                                           |   18 +
 net/smc/smc_wr.c                                           |   10 +
 net/vmw_vsock/virtio_transport.c                           |    7 
 sound/soc/amd/acp-pcm-dma.c                                |    2 
 sound/soc/amd/raven/acp3x-pcm-dma.c                        |    2 
 sound/soc/amd/renoir/acp3x-pdm-dma.c                       |    2 
 sound/soc/codecs/cs42l42.c                                 |   39 +---
 sound/soc/codecs/tlv320aic31xx.c                           |   10 +
 sound/soc/intel/atom/sst-mfld-platform-pcm.c               |    3 
 sound/soc/sof/intel/hda-ipc.c                              |    4 
 sound/soc/uniphier/aio-dma.c                               |    2 
 sound/soc/xilinx/xlnx_formatter_pcm.c                      |    4 
 tools/lib/bpf/libbpf_probes.c                              |    4 
 106 files changed, 832 insertions(+), 368 deletions(-)

Alex Deucher (1):
      drm/amdgpu: don't enable baco on boco platforms in runpm

Andy Shevchenko (1):
      pinctrl: tigerlake: Fix GPIO mapping for newer version of software

Anirudh Venkataramanan (1):
      ice: Prevent probing virtual functions

Anson Jacob (1):
      drm/amd/display: use GFP_ATOMIC in amdgpu_dm_irq_schedule_work

Antti Keränen (1):
      iio: adis: set GPIO reset pin direction

Ard Biesheuvel (3):
      efi/libstub: arm64: Force Image reallocation if BSS was not reserved
      efi/libstub: arm64: Relax 2M alignment again for relocatable kernels
      efi/libstub: arm64: Double check image alignment at entry

Aya Levin (1):
      net/mlx5: Fix return value from tracer initialization

Babu Moger (1):
      x86/resctrl: Fix default monitoring groups reporting

Ben Dai (1):
      genirq/timings: Prevent potential array overflow in __irq_timings_store()

Ben Hutchings (8):
      net: phy: micrel: Fix link detection on ksz87xx switch"
      net: dsa: microchip: Fix ksz_read64()
      net: dsa: microchip: ksz8795: Fix VLAN filtering
      net: dsa: microchip: Fix probing KSZ87xx switch with DT node for host port
      net: dsa: microchip: ksz8795: Fix PVID tag insertion
      net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
      net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion
      net: dsa: microchip: ksz8795: Use software untagging on CPU port

Benjamin Herrenschmidt (1):
      arm64: efi: kaslr: Fix occasional random alloc (and boot) failure

Bixuan Cui (1):
      genirq/msi: Ensure deactivation on teardown

Brett Creeley (1):
      ice: don't remove netdev->dev_addr from uc sync list

Chris Lesiak (1):
      iio: humidity: hdc100x: Add margin to the conversion time

Christian Hewitt (1):
      drm/meson: fix colour distortion from HDR set during vendor u-boot

Christophe Leroy (1):
      powerpc/smp: Fix OOPS in topology_init()

Colin Ian King (1):
      iio: adc: Fix incorrect exit of for-loop

DENG Qingfang (1):
      net: dsa: mt7530: add the missing RxUnicast MIB counter

Dan Williams (2):
      ACPI: NFIT: Fix support for virtual SPA ranges
      libnvdimm/region: Fix label activation vs errors

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

Greg Kroah-Hartman (2):
      i2c: dev: zero out array used for i2c reads from userspace
      Linux 5.10.60

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases

Guennadi Liakhovetski (1):
      ASoC: SOF: Intel: hda-ipc: fix reply size checking

Guillaume Nault (1):
      bareudp: Fix invalid read beyond skb's linear data

Hangbin Liu (1):
      net: sched: act_mirred: Reset ct info when mirror/redirect skb

Hans de Goede (3):
      platform/x86: pcengines-apuv2: Add missing terminating entries to gpio-lookup tables
      vboxsf: Add vboxsf_[create|release]_sf_handle() helpers
      vboxsf: Add support for the atomic_open directory-inode op

Hsin-Yi Wang (1):
      pinctrl: mediatek: Fix fallback behavior for bias_set_combo

Hsuan-Chi Kuo (1):
      seccomp: Fix setting loaded filter count during TSYNC

Jeff Layton (3):
      ceph: add some lockdep assertions around snaprealm handling
      ceph: clean up locking annotation for ceph_get_snap_realm and __lookup_snap_realm
      ceph: take snap_empty_lock atomically with snaprealm refcount change

John Hubbard (1):
      net: mvvp2: fix short frame size on s390

Karsten Graul (1):
      net/smc: fix wait on already cleared link

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

Maximilian Heyne (1):
      xen/events: Fix race in set_evtchn_to_irq

Md Fahad Iqbal Polash (1):
      iavf: Set RSS LUT and key in reset handle path

Nathan Chancellor (1):
      vmlinux.lds.h: Handle clang's module.{c,d}tor sections

Neal Cardwell (1):
      tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Nikolay Aleksandrov (1):
      net: bridge: fix flags interpretation for extern learn fdb entries

Pali Rohár (1):
      ppp: Fix generating ifname when empty IFLA_IFNAME is specified

Pu Lehui (1):
      powerpc/kprobes: Fix kprobe Oops happens in booke

Randy Dunlap (1):
      x86/tools: Fix objdump version check again

Richard Fitzgerald (5):
      ASoC: cs42l42: Correct definition of ADC Volume control
      ASoC: cs42l42: Don't allow SND_SOC_DAIFMT_LEFT_J
      ASoC: cs42l42: Fix inversion of ADC Notch Switch control
      ASoC: cs42l42: Remove duplicate control for WNF filter frequency
      ASoC: cs42l42: Fix LRCLK frame start edge

Robin Gögge (1):
      libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT

Roi Dayan (1):
      psample: Add a fwd declaration for skbuff

Sean Christopherson (2):
      KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation
      KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF

Shay Drory (1):
      net/mlx5: Synchronize correct IRQ when destroying CQ

Shyam Prasad N (1):
      cifs: create sd context must be a multiple of 8

Takashi Iwai (4):
      ASoC: amd: Fix reference to PCM buffer address
      ASoC: xilinx: Fix reference to PCM buffer address
      ASoC: uniphier: Fix reference to PCM buffer address
      ASoC: intel: atom: Fix reference to PCM buffer address

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow involving bucket_size

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

Uwe Kleine-König (1):
      iio: adc: ti-ads7950: Ensure CS is deasserted after reading channels

Vineet Gupta (1):
      ARC: fp: set FPU_STATUS.FWE to enable FPU_STATUS update on context switch

Vladimir Oltean (4):
      net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
      net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
      net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
      net: bridge: validate the NUD_PERMANENT bit when adding an extern_learn FDB entry

Willy Tarreau (1):
      net: linkwatch: fix failure to restore device state across suspend/resume

Xie Yongji (1):
      nbd: Aovid double completion of a request

Yajun Deng (1):
      netfilter: nf_conntrack_bridge: Fix memory leak when error

Yang Yingliang (1):
      net: bridge: fix memleak in br_add_if()

