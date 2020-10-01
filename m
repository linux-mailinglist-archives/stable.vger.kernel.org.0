Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77F4280403
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgJAQej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 12:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732046AbgJAQej (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 12:34:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B3E20759;
        Thu,  1 Oct 2020 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601570078;
        bh=8sNv6+JiXieE0zW+u84eLTat9hGepLo9ObwAtIY2n/w=;
        h=From:To:Cc:Subject:Date:From;
        b=FyYqS129iI8+4FKECP+iNIYF5MZOk/MyiBqcE42wupBdd5H8cEDZ1VQamJCI7piWb
         +im3Hhc28JcykQhdtKImomoqdi4NYJB3JIP3PJdTD4WpneqUI1Sxv3SyrSZ3yz05WI
         bZwd6aPBuBHfdgdWsayBYfVLpYfEqUYPNexc03fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.13
Date:   Thu,  1 Oct 2020 18:34:38 +0200
Message-Id: <16015700778371@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.13 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm64/include/asm/kvm_emulate.h                  |   12 +
 arch/arm64/kvm/hyp/switch.c                           |    2 
 arch/arm64/kvm/mmio.c                                 |    2 
 arch/arm64/kvm/mmu.c                                  |    2 
 arch/ia64/mm/init.c                                   |    6 
 arch/mips/include/asm/cpu-type.h                      |    1 
 arch/mips/loongson2ef/Platform                        |    4 
 arch/mips/loongson64/cop2-ex.c                        |   24 --
 arch/riscv/boot/dts/kendryte/k210.dtsi                |    6 
 arch/riscv/include/asm/ftrace.h                       |    7 
 arch/riscv/kernel/ftrace.c                            |   19 ++
 arch/s390/include/asm/pgtable.h                       |   42 +++--
 arch/s390/kernel/setup.c                              |    6 
 arch/x86/entry/common.c                               |    2 
 arch/x86/entry/entry_64.S                             |    2 
 arch/x86/include/asm/idtentry.h                       |    2 
 arch/x86/include/asm/irq_stack.h                      |   70 +++++++-
 arch/x86/kernel/apic/io_apic.c                        |    1 
 arch/x86/kernel/irq.c                                 |    2 
 arch/x86/kernel/irq_64.c                              |    2 
 arch/x86/kvm/svm/svm.c                                |    8 
 arch/x86/kvm/x86.c                                    |    3 
 arch/x86/lib/usercopy_64.c                            |    2 
 drivers/atm/eni.c                                     |    2 
 drivers/base/node.c                                   |   85 ++++++----
 drivers/base/regmap/internal.h                        |    2 
 drivers/base/regmap/regcache.c                        |    2 
 drivers/base/regmap/regmap.c                          |   33 ++--
 drivers/clk/versatile/clk-impd1.c                     |    4 
 drivers/clocksource/h8300_timer8.c                    |    2 
 drivers/clocksource/timer-ti-dm-systimer.c            |   44 ++---
 drivers/devfreq/tegra30-devfreq.c                     |    4 
 drivers/dma-buf/dma-buf.c                             |    2 
 drivers/edac/ghes_edac.c                              |    4 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     |   32 +--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    4 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_log.h   |    2 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c   |    2 
 drivers/gpu/drm/sun4i/sun8i_csc.h                     |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                        |    1 
 drivers/i2c/busses/i2c-aspeed.c                       |    2 
 drivers/i2c/busses/i2c-mt65xx.c                       |    2 
 drivers/i2c/i2c-core-base.c                           |    2 
 drivers/infiniband/core/device.c                      |    6 
 drivers/md/dm.c                                       |   23 --
 drivers/media/cec/core/cec-adap.c                     |    2 
 drivers/net/ethernet/intel/igc/igc.h                  |   20 --
 drivers/net/ethernet/intel/igc/igc_ptp.c              |   19 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c     |    7 
 drivers/net/ethernet/qlogic/qed/qed_dev.c             |   11 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c              |    3 
 drivers/net/ethernet/qlogic/qed/qed_main.c            |    2 
 drivers/net/ethernet/qlogic/qed/qed_sriov.c           |    1 
 drivers/net/ethernet/qlogic/qede/qede_filter.c        |    3 
 drivers/net/ethernet/qlogic/qede/qede_main.c          |   11 -
 drivers/net/hyperv/netvsc_drv.c                       |   11 -
 drivers/net/ieee802154/adf7242.c                      |    4 
 drivers/net/ieee802154/ca8210.c                       |    1 
 drivers/net/wireless/marvell/mwifiex/fw.h             |    2 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c    |    4 
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c       |    3 
 drivers/nvme/host/Kconfig                             |    1 
 drivers/regulator/axp20x-regulator.c                  |    7 
 drivers/s390/block/dasd_fba.c                         |    9 -
 drivers/s390/crypto/zcrypt_api.c                      |    3 
 drivers/scsi/lpfc/lpfc_hbadisc.c                      |   76 ++++++---
 drivers/spi/spi-bcm-qspi.c                            |    2 
 drivers/spi/spi-fsl-dspi.c                            |    6 
 fs/btrfs/disk-io.c                                    |   11 -
 fs/btrfs/sysfs.c                                      |   16 +
 fs/io_uring.c                                         |    8 
 include/linux/kprobes.h                               |    5 
 include/linux/mm.h                                    |    2 
 include/linux/mmzone.h                                |   11 -
 include/linux/node.h                                  |   11 -
 include/linux/pgtable.h                               |   10 +
 include/linux/qed/qed_if.h                            |    1 
 init/main.c                                           |    2 
 kernel/bpf/inode.c                                    |    4 
 kernel/kprobes.c                                      |   27 +++
 kernel/trace/trace_events_hist.c                      |    1 
 kernel/trace/trace_preemptirq.c                       |    4 
 lib/bootconfig.c                                      |   38 ++--
 lib/string.c                                          |   24 ++
 mm/gup.c                                              |   18 +-
 mm/madvise.c                                          |    2 
 mm/memory_hotplug.c                                   |    5 
 mm/page_alloc.c                                       |   10 -
 mm/swapfile.c                                         |    2 
 net/batman-adv/bridge_loop_avoidance.c                |  145 ++++++++++++++----
 net/batman-adv/bridge_loop_avoidance.h                |    4 
 net/batman-adv/multicast.c                            |   46 ++++-
 net/batman-adv/multicast.h                            |   15 +
 net/batman-adv/routing.c                              |    4 
 net/batman-adv/soft-interface.c                       |   11 -
 net/core/filter.c                                     |    4 
 net/mac80211/mlme.c                                   |    3 
 net/mac80211/util.c                                   |    7 
 net/mac802154/tx.c                                    |    8 
 net/netfilter/nf_conntrack_netlink.c                  |   22 --
 net/netfilter/nf_conntrack_proto.c                    |    2 
 net/netfilter/nft_meta.c                              |    4 
 net/sunrpc/svcsock.c                                  |    2 
 net/wireless/Kconfig                                  |    1 
 net/wireless/util.c                                   |    2 
 net/xdp/xdp_umem.c                                    |   17 --
 security/device_cgroup.c                              |    3 
 sound/pci/asihpi/hpioctl.c                            |    4 
 sound/pci/hda/patch_realtek.c                         |   13 +
 sound/soc/codecs/pcm3168a.c                           |    7 
 sound/soc/codecs/wm8994.c                             |   10 +
 sound/soc/codecs/wm_hubs.c                            |    3 
 sound/soc/codecs/wm_hubs.h                            |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                 |   10 +
 sound/usb/quirks.c                                    |    7 
 tools/lib/bpf/Makefile                                |    2 
 tools/lib/bpf/libbpf.c                                |    2 
 tools/objtool/check.c                                 |    2 
 120 files changed, 865 insertions(+), 409 deletions(-)

Amol Grover (1):
      device_cgroup: Fix RCU list debugging warning

Anand Jain (1):
      btrfs: fix put of uninitialized kobject after seed device delete

Bhawanpreet Lakha (2):
      drm/amd/display: Don't use DRM_ERROR() for DTM add topology
      drm/amd/display: Don't log hdcp module warnings in dmesg

Björn Töpel (1):
      xsk: Fix number of pinned pages/umem size discrepancy

Borislav Petkov (1):
      EDAC/ghes: Check whether the driver is on the safe list correctly

Charan Teja Reddy (1):
      dmabuf: fix NULL pointer dereference in dma_buf_release()

Christian Borntraeger (1):
      s390/zcrypt: Fix ZCRYPT_PERDEV_REQCNT ioctl

Chuck Lever (1):
      SUNRPC: Fix svc_flush_dcache()

Damien Le Moal (1):
      riscv: Fix Kendryte K210 device tree

Dan Carpenter (1):
      PM / devfreq: tegra30: Disable clock on error in probe

Daniel Borkmann (1):
      bpf: Fix clobbering of r2 in bpf_gen_ld_abs

Dennis Li (1):
      drm/amdkfd: fix a memory leak issue

Dexuan Cui (1):
      hv_netvsc: Switch the data path at the right time during hibernation

Dmitry Baryshkov (2):
      regmap: fix page selection for noinc reads
      regmap: fix page selection for noinc writes

Dmitry Bogdanov (3):
      net: qed: Disable aRFS for NPAR and 100G
      net: qede: Disable aRFS for NPAR and 100G
      net: qed: RDMA personality shouldn't fail VF load

Eddie James (1):
      i2c: aspeed: Mask IRQ status to relevant bits

Eelco Chaudron (1):
      netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled

Eric Dumazet (1):
      mac802154: tx: fix use-after-free

Felix Fietkau (1):
      mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/removing stations

Gao Xiang (1):
      mm, THP, swap: fix allocating cluster for swapfile by mistake

Greg Kroah-Hartman (1):
      Linux 5.8.13

Hans Verkuil (1):
      media: cec-adap.c: don't use flush_scheduled_work()

Hans de Goede (2):
      ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1
      i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()

Huacai Chen (1):
      MIPS: Loongson-3: Fix fp register access if MSA enabled

Hui Wang (1):
      ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged

Icenowy Zheng (1):
      regulator: axp20x: fix LDO2/4 description

Ilya Leoshkevich (1):
      s390/init: add missing __init annotations

James Smart (1):
      scsi: lpfc: Fix initial FLOGI failure due to BBSCN not supported

Jan Höppner (1):
      s390/dasd: Fix zero write for FBA devices

Jason Gunthorpe (1):
      RDMA/core: Fix ordering of CQ pool destruction

Jens Axboe (2):
      io_uring: fix openat/openat2 unified prep handling
      io_uring: ensure open/openat2 name is cleaned on cancelation

Jiaxun Yang (1):
      MIPS: Loongson2ef: Disable Loongson MMI instructions

Jing Xiangfeng (1):
      atm: eni: fix the missed pci_disable_device() for eni_init_one()

Joakim Tjernlund (1):
      ALSA: usb-audio: Add delay quirk for H570e USB headsets

Johannes Berg (1):
      cfg80211: fix 6 GHz channel conversion

Johannes Thumshirn (1):
      btrfs: fix overflow when copying corrupt csums for a message

John Crispin (1):
      mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz

Josh Poimboeuf (1):
      objtool: Fix noreturn detection for ignored functions

Jun Lei (1):
      drm/amd/display: update nv1x stutter latencies

Kai-Heng Feng (1):
      ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520

Kuninori Morimoto (1):
      ASoC: pcm3168a: ignore 0 Hz settings

Laurent Dufour (2):
      mm: replace memmap_context by meminit_context
      mm: don't rely on system state to detect hot-plug operations

Linus Lüssing (5):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh
      batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Liu Jian (1):
      ieee802154: fix one possible memleak in ca8210_dev_com_init

Marc Zyngier (1):
      KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch

Marek Szyprowski (1):
      drm/vc4/vc4_hdmi: fill ASoC card owner

Martin Cerveny (1):
      drm/sun4i: sun8i-csc: Secondary CSC register correction

Martin Willi (1):
      netfilter: ctnetlink: fix mark based dump filtering regression

Masami Hiramatsu (4):
      lib/bootconfig: Fix a bug of breaking existing tree nodes
      lib/bootconfig: Fix to remove tailing spaces after value
      kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()
      kprobes: tracing/kprobes: Fix to kill kprobes on initmem after boot

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Michel Dänzer (1):
      drm/amdgpu/dc: Require primary plane to be enabled whenever the CRTC is

Mike Snitzer (1):
      dm: fix bio splitting and its bio completion order for regular IO

Mikulas Patocka (1):
      arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback

Minchan Kim (1):
      mm: validate pmd after splitting

Necip Fazil Yildiran (2):
      nvme-tcp: fix kconfig dependency warning when !CRYPTO
      lib80211: fix unmet direct dependendices config warning when !CRYPTO

Nick Desaulniers (1):
      lib/string.c: implement stpcpy

Pablo Neira Ayuso (1):
      netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid

Palmer Dabbelt (1):
      RISC-V: Take text_mutex in ftrace_init_nop()

Qii Wang (1):
      i2c: mediatek: Send i2c master code at more than 1MHz

Ray Jui (1):
      spi: bcm-qspi: Fix probe regression on iProc platforms

Saeed Mahameed (1):
      net/mlx5e: mlx5e_fec_in_caps() returns a boolean

Sean Christopherson (1):
      KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE

Sumera Priyadarsini (1):
      clk: versatile: Add of_node_put() before return statement

Sven Eckelmann (1):
      batman-adv: Add missing include for in_interrupt()

Sven Schnelle (1):
      lockdep: fix order in trace_hardirqs_off_caller()

Sylwester Nawrocki (2):
      ASoC: wm8994: Skip setting of the WM8994_MICBIAS register for WM1811
      ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions

Thomas Gleixner (2):
      x86/irq: Make run_on_irqstack_cond() typesafe
      x86/ioapic: Unbreak check_timer()

Tianjia Zhang (1):
      clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Lendacky (1):
      KVM: SVM: Add a dedicated INVD intercept routine

Tom Rix (3):
      ieee802154/adf7242: check status of adf7242_read_reg
      ALSA: asihpi: fix iounmap in error handler
      tracing: fix double free

Tony Ambardar (2):
      libbpf: Fix build failure from uninitialized variable warning
      tools/libbpf: Avoid counting local symbols in ABI check

Tony Lindgren (1):
      clocksource/drivers/timer-ti-dm: Do reset before enable

Vasily Gorbik (1):
      mm/gup: fix gup_fast with dynamic page table folding

Vinicius Costa Gomes (2):
      igc: Fix wrong timestamp latency numbers
      igc: Fix not considering the TX delay for timestamps

Vladimir Oltean (1):
      spi: spi-fsl-dspi: use XSPI mode instead of DMA for DPAA2 SoCs

Wei Li (1):
      MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Wen Gong (1):
      mac80211: do not disable HE if HT is missing on 2.4 GHz

Will McVicker (1):
      netfilter: ctnetlink: add a range check for l3/l4 protonum

Yonghong Song (1):
      bpf: Fix a rcu warning for bpffs map pretty-print

