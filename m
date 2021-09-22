Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59D414796
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbhIVLRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhIVLPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D13A60F23;
        Wed, 22 Sep 2021 11:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309222;
        bh=cjGYy02+Sf0iTxVaXsKV5w23LxdXDkgfwUVyJTGwsGY=;
        h=From:To:Cc:Subject:Date:From;
        b=LEuvSpqjHvBT41D+gcTNozcbs5U6d6KKh4BIEubvccFIbPhD1AcnwKZngbrxnLEJ+
         09oR6O8KQPHR4dewOHmYScbXHS9AnzkAugqZPjpZF2y4sGSx0I2p8MPuLu0YX1niRS
         qjU9VT6WLHMJ2nEiYlhjE9uc33XeU4xcGxLCxFek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.68
Date:   Wed, 22 Sep 2021 13:13:19 +0200
Message-Id: <1632309199108165@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.68 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/arm/tegra.yaml          |    2 
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt       |    2 
 Makefile                                                  |    2 
 arch/arc/mm/cache.c                                       |    2 
 arch/arm64/kernel/fpsimd.c                                |    2 
 arch/arm64/kvm/arm.c                                      |    8 +
 arch/arm64/kvm/reset.c                                    |   24 +++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                   |   36 +++++-
 arch/s390/net/bpf_jit_comp.c                              |   70 ++++++------
 arch/x86/include/asm/uaccess.h                            |    4 
 arch/x86/kernel/cpu/mce/core.c                            |   43 +++++--
 arch/x86/mm/init_64.c                                     |    6 -
 arch/x86/mm/pat/memtype.c                                 |    7 +
 arch/x86/xen/enlighten_pv.c                               |    7 +
 block/bfq-iosched.c                                       |   16 ++
 drivers/base/power/trace.c                                |   10 +
 drivers/gpio/gpio-mpc8xxx.c                               |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                       |    2 
 drivers/gpu/drm/bridge/lontium-lt9611.c                   |    8 +
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c                  |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                     |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c              |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                     |   43 ++++---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                     |    1 
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c                   |    4 
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c                |    8 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                     |    1 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                     |    4 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                    |    2 
 drivers/mfd/ab8500-core.c                                 |    2 
 drivers/mfd/axp20x.c                                      |    3 
 drivers/mfd/db8500-prcmu.c                                |   14 +-
 drivers/mfd/lpc_sch.c                                     |   36 +-----
 drivers/mfd/stmpe.c                                       |    4 
 drivers/mfd/tc3589x.c                                     |    2 
 drivers/mfd/tqmx86.c                                      |    2 
 drivers/mfd/wm8994-irq.c                                  |    2 
 drivers/mtd/mtdconcat.c                                   |   33 ++++-
 drivers/mtd/nand/raw/cafe_nand.c                          |    4 
 drivers/net/dsa/b53/b53_common.c                          |   33 ++++-
 drivers/net/dsa/b53/b53_priv.h                            |    1 
 drivers/net/dsa/bcm_sf2.c                                 |    2 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c         |    2 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |   80 +++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c         |    6 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c              |    3 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                 |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           |    8 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |   19 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    6 -
 drivers/net/ethernet/ibm/ibmvnic.c                        |    8 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c           |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c  |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c         |    5 
 drivers/net/ethernet/netronome/nfp/flower/offload.c       |    3 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                 |    6 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c          |    1 
 drivers/net/ethernet/rdc/r6040.c                          |    9 +
 drivers/net/ethernet/renesas/sh_eth.c                     |    1 
 drivers/net/ipa/ipa_table.c                               |    3 
 drivers/net/phy/dp83640_reg.h                             |    2 
 drivers/net/usb/cdc_mbim.c                                |    5 
 drivers/net/usb/hso.c                                     |   11 +
 drivers/ntb/test/ntb_msi_test.c                           |    4 
 drivers/ntb/test/ntb_perf.c                               |    1 
 drivers/nvme/host/tcp.c                                   |   20 +--
 drivers/pci/controller/cadence/pci-j721e.c                |   61 +++++++++-
 drivers/pci/controller/cadence/pcie-cadence-ep.c          |    4 
 drivers/pci/controller/cadence/pcie-cadence-host.c        |    3 
 drivers/pci/controller/cadence/pcie-cadence.c             |   16 ++
 drivers/pci/controller/cadence/pcie-cadence.h             |   17 ++
 drivers/pci/controller/dwc/pcie-tegra194.c                |   32 ++---
 drivers/pci/controller/pci-tegra.c                        |   13 +-
 drivers/pci/controller/pcie-iproc-bcma.c                  |   16 +-
 drivers/pci/controller/pcie-rcar-ep.c                     |    4 
 drivers/pci/hotplug/TODO                                  |    3 
 drivers/pci/hotplug/ibmphp_ebda.c                         |    5 
 drivers/pci/of.c                                          |    2 
 drivers/pci/pci.c                                         |    2 
 drivers/pci/quirks.c                                      |   58 +++++++++-
 drivers/s390/char/sclp_early.c                            |    3 
 drivers/vhost/net.c                                       |   11 +
 drivers/video/backlight/ktd253-backlight.c                |   75 +++++++++----
 drivers/watchdog/watchdog_dev.c                           |    5 
 fs/btrfs/disk-io.c                                        |   45 ++++---
 fs/fuse/dev.c                                             |    4 
 fs/io_uring.c                                             |    9 +
 include/linux/memory_hotplug.h                            |    4 
 include/linux/pci.h                                       |    5 
 include/linux/pci_ids.h                                   |    3 
 include/linux/sched.h                                     |    1 
 include/linux/skbuff.h                                    |    2 
 include/uapi/linux/pkt_sched.h                            |    2 
 kernel/events/core.c                                      |    2 
 kernel/trace/trace_boot.c                                 |   15 +-
 kernel/trace/trace_kprobe.c                               |    6 -
 kernel/trace/trace_probe.c                                |   25 ++++
 kernel/trace/trace_probe.h                                |    1 
 kernel/trace/trace_uprobe.c                               |    6 -
 mm/memory_hotplug.c                                       |    4 
 net/caif/chnl_net.c                                       |   19 ---
 net/dccp/minisocks.c                                      |    2 
 net/dsa/slave.c                                           |   12 --
 net/dsa/tag_rtl4_a.c                                      |    7 -
 net/ethtool/ioctl.c                                       |    2 
 net/ipv4/ip_gre.c                                         |    9 +
 net/ipv4/nexthop.c                                        |    2 
 net/ipv4/tcp_input.c                                      |    2 
 net/ipv4/udp_tunnel_nic.c                                 |    2 
 net/ipv6/netfilter/nf_socket_ipv6.c                       |    4 
 net/l2tp/l2tp_core.c                                      |    4 
 net/netfilter/nf_conntrack_proto_dccp.c                   |    1 
 net/netfilter/nf_tables_api.c                             |    1 
 net/netfilter/nft_ct.c                                    |   10 +
 net/sched/sch_fq_codel.c                                  |   12 +-
 net/tipc/socket.c                                         |   10 +
 net/unix/af_unix.c                                        |    2 
 scripts/clang-tools/gen_compile_commands.py               |    1 
 tools/perf/Makefile.config                                |    8 -
 tools/perf/bench/inject-buildid.c                         |   52 +++++----
 tools/perf/util/machine.c                                 |    1 
 tools/testing/selftests/net/altnames.sh                   |    2 
 tools/testing/selftests/net/mptcp/simult_flows.sh         |    4 
 124 files changed, 903 insertions(+), 418 deletions(-)

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Alex Elder (1):
      net: ipa: initialize all filter table slots

Alexander Egorenkov (1):
      s390/sclp: fix Secure-IPL facility detection

Anand Jain (1):
      btrfs: fix upper limit for max_inline for page size 64K

Andrea Claudi (1):
      selftest: net: fix typo in altname test

Andy Shevchenko (2):
      PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n
      mfd: lpc_sch: Partially revert "Add support for Intel Quark X1000"

Anshuman Khandual (1):
      KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size

Arnaldo Carvalho de Melo (1):
      perf bench inject-buildid: Handle writen() errors

Arnd Bergmann (1):
      drm/rockchip: cdn-dp-core: Make cdn_dp_core_resume __maybe_unused

Aya Levin (1):
      udp_tunnel: Fix udp_tunnel_nic work-queue type

Baptiste Lepers (1):
      events: Reuse value read using READ_ONCE instead of re-reading it

Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Christophe JAILLET (4):
      PCI: tegra: Fix OF node reference leak
      mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'
      gpio: mpc8xxx: Fix a resources leak in the error handling path of 'mpc8xxx_probe()'
      gpio: mpc8xxx: Use 'devm_gpiochip_add_data()' to simplify the code and avoid a leak

Dan Carpenter (1):
      PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

David Heidelberg (1):
      dt-bindings: arm: Fix Toradex compatible typo

David Hildenbrand (1):
      mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

Dinghao Liu (2):
      PCI: rcar: Fix runtime PM imbalance in rcar_pcie_ep_probe()
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Edwin Peer (3):
      bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
      bnxt_en: fix stored FW_PSID version masks
      bnxt_en: log firmware debug notifications

Eli Cohen (1):
      net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert

Eric Dumazet (3):
      net-caif: avoid user-triggerable WARN_ON(1)
      net/af_unix: fix a data-race in unix_dgram_poll
      fq_codel: reject silly quantum parameters

Ernst Sjöstrand (1):
      drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan (1):
      PCI: Add AMD GPU multi-function power dependencies

Florian Fainelli (2):
      r6040: Restore MDIO clock frequency after MAC reset
      net: dsa: bcm_sf2: Fix array overrun in bcm_sf2_num_active_ports()

George Cherian (1):
      PCI: Add ACS quirks for Cavium multi-function devices

Greg Kroah-Hartman (1):
      Linux 5.10.68

Gustavo A. R. Silva (1):
      netfilter: Fix fall-through warnings for Clang

Hans de Goede (1):
      mfd: axp20x: Update AXP288 volatile ranges

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Ilya Leoshkevich (3):
      s390/bpf: Fix optimizing out zero-extensions
      s390/bpf: Fix 64-bit subtraction of the -0x80000000 constant
      s390/bpf: Fix branch shortening during codegen pass

Jan Kiszka (1):
      watchdog: Start watchdog in watchdog_set_last_hw_keepalive only if appropriate

Jeff Moyer (1):
      x86/pat: Pass valid address to sanitize_phys()

Jens Axboe (1):
      io_uring: ensure symmetry in handling iter types in loop_rw_iter()

Jiaran Zhang (1):
      net: hns3: fix the timing issue of VF clearing interrupt sources

Juergen Gross (2):
      xen: reset legacy rtc flag for PV domU
      PM: base: power: don't try to use non-existing RTC for storing data

Keith Busch (1):
      nvme-tcp: fix io_work priority inversion

Kishon Vijay Abraham I (3):
      PCI: cadence: Use bitfield for *quirk_retrain_flag* instead of bool
      PCI: j721e: Add PCIe support for J7200
      PCI: j721e: Add PCIe support for AM64

Kortan (1):
      gen_compile_commands: fix missing 'sys' package

Li Huafei (1):
      perf unwind: Do not overwrite FEATURE_CHECK_LDFLAGS-libunwind-{x86,aarch64}

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Linus Walleij (3):
      mfd: db8500-prcmu: Adjust map to reality
      backlight: ktd253: Stabilize backlight
      net: dsa: tag_rtl4_a: Fix egress tags

Lucas Stach (8):
      drm/etnaviv: return context from etnaviv_iommu_context_get
      drm/etnaviv: put submit prev MMU context when it exists
      drm/etnaviv: stop abusing mmu_context as FE running marker
      drm/etnaviv: keep MMU context across runtime suspend/resume
      drm/etnaviv: exec and MMU state is lost when resetting the GPU
      drm/etnaviv: fix MMU context leak on GPU reset
      drm/etnaviv: reference MMU context when setting up hardware state
      drm/etnaviv: add missing MMU context put when reaping MMU mapping

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Marc Zyngier (1):
      mfd: Don't use irq_create_mapping() to resolve a mapping

Mark Brown (1):
      arm64/sve: Use correct size when reinitialising SVE state

Masami Hiramatsu (2):
      tracing/probes: Reject events which have the same name of existing one
      tracing/boot: Fix a hist trigger dependency for boot time tracing

Matthias Schiffer (1):
      mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set

Matthieu Baerts (1):
      selftests: mptcp: clean tmp files in simult_flows

Michael Chan (6):
      bnxt_en: Fix asic.rev in devlink dev info command
      bnxt_en: Consolidate firmware reset event logging.
      bnxt_en: Convert to use netif_level() helpers.
      bnxt_en: Improve logging of error recovery settings information.
      bnxt_en: Fix possible unintended driver initiated error recovery
      bnxt_en: Fix error recovery regression

Michael Petlan (1):
      perf machine: Initialize srcline string member in add_location struct

Mike Rapoport (1):
      x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Miklos Szeredi (1):
      fuse: fix use after free in fuse_read_interrupt()

Miquel Raynal (1):
      dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Nadeem Athani (1):
      PCI: cadence: Add quirk flag to set minimum delay in LTSSM Detect.Quiet state

Nicholas Piggin (1):
      KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers

Oliver Upton (2):
      KVM: arm64: Fix read-side race on updates to vcpu reset state
      KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Om Prakash Singh (2):
      PCI: tegra194: Fix handling BME_CHGED event
      PCI: tegra194: Fix MSI-X programming

Paolo Abeni (1):
      vhost_net: fix OoB on sendmsg() failure.

Paolo Valente (1):
      block, bfq: honor already-setup queue merges

Pavel Skripkin (1):
      netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex

Rafał Miłecki (3):
      net: dsa: b53: Fix calculating number of switch ports
      net: dsa: b53: Set correct number of ports in the DSA struct
      net: dsa: b53: Fix IMP port setup on BCM5301x

Randy Dunlap (3):
      ptp: dp83640: don't define PAGE0
      ARC: export clear_user_page() for modules
      mfd: lpc_sch: Rename GPIOBASE to prevent build error

Rob Herring (2):
      PCI: of: Don't fail devm_pci_alloc_host_bridge() on missing 'ranges'
      PCI: iproc: Fix BCMA probe resource handling

Robert Foss (1):
      drm/bridge: lt9611: Fix handling of 4k panels

Ryoga Saito (1):
      Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

Saeed Mahameed (2):
      ethtool: Fix rxnfc copy to user buffer overflow
      net/mlx5: FWTrace, cancel work on alloc pd error flow

Shai Malin (1):
      qed: Handle management FW error

Smadar Fuks (1):
      octeontx2-af: Add additional register check to rvu_poll_reg()

Sukadev Bhattiprolu (1):
      ibmvnic: check failover_pending in login response

Tony Luck (1):
      x86/mce: Avoid infinite loop for copy from user recovery

Vishal Aslot (1):
      PCI: ibmphp: Fix double unmap of io_mem

Vladimir Oltean (1):
      net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Wasim Khan (1):
      PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms

Will Deacon (1):
      x86/uaccess: Fix 32-bit __get_user_asm_u64() when CC_HAS_ASM_GOTO_OUTPUT=y

Willem de Bruijn (1):
      ip_gre: validate csum_start only on pull

Xin Long (1):
      tipc: fix an use-after-free issue in tipc_recvmsg

Xiyu Yang (1):
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yang Li (3):
      ethtool: Fix an error code in cxgb2.c
      NTB: Fix an error code in ntb_msit_probe()
      NTB: perf: Fix an error code in perf_setup_inbuf()

Yoshihiro Shimoda (1):
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Yufeng Mo (3):
      net: hns3: pad the short tunnel frame before sending to hardware
      net: hns3: change affinity_mask to numa node range
      net: hns3: disable mac in flr process

Zhihao Cheng (2):
      mtd: mtdconcat: Judge callback existence based on the master
      mtd: mtdconcat: Check _read, _write callbacks existence before assignment

Ziyang Xuan (1):
      net: hso: add failure handler for add_net_device

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

