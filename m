Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00BF4436B5
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 20:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhKBTxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 15:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230457AbhKBTxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 15:53:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA1760F45;
        Tue,  2 Nov 2021 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635882665;
        bh=IzHTqmbUrypAYYfCIy4yxWgdpuNNcQTsnX8bBVIwhdI=;
        h=From:To:Cc:Subject:Date:From;
        b=vSqauTbzl6mj+n/mOSa74PS5k9z043fb9/51gVBdM7/OHQqNIizGdEhLnr2XMw8yo
         GvxchSt46AZTuF691T5RvsUsB8ZLlhbUqqu9Xwi/qaibAvBvmIZqMJ52Ws5ZYML+f7
         VzNkL+DO3kFmrRuHl76F0Us7sIjEVDZWJ9Mmgpdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.16
Date:   Tue,  2 Nov 2021 20:50:58 +0100
Message-Id: <1635882659143224@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.16 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm/boot/compressed/decompress.c                          |    3 
 arch/arm/include/asm/uaccess.h                                 |    4 
 arch/arm/kernel/head.S                                         |    4 
 arch/arm/kernel/vmlinux-xip.lds.S                              |    6 
 arch/arm/mm/proc-macros.S                                      |    1 
 arch/arm/probes/kprobes/core.c                                 |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts        |    2 
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts       |    8 
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi    |    8 
 arch/nds32/kernel/ftrace.c                                     |    2 
 arch/nios2/platform/Kconfig.platform                           |    1 
 arch/riscv/Kconfig                                             |    6 
 arch/riscv/include/asm/kasan.h                                 |    3 
 arch/riscv/kernel/head.S                                       |    1 
 arch/riscv/mm/kasan_init.c                                     |   14 
 arch/riscv/net/bpf_jit_core.c                                  |    3 
 arch/s390/kvm/interrupt.c                                      |    5 
 arch/s390/kvm/kvm-s390.c                                       |    1 
 arch/x86/include/asm/kvm_host.h                                |    2 
 arch/x86/kvm/svm/sev.c                                         |   15 -
 arch/x86/kvm/x86.c                                             |   36 +-
 arch/x86/kvm/xen.c                                             |   27 +
 block/blk-settings.c                                           |   20 +
 drivers/ata/sata_mv.c                                          |    4 
 drivers/base/regmap/regcache-rbtree.c                          |    7 
 drivers/gpio/gpio-xgs-iproc.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/nv.c                                |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c      |   20 -
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c   |   29 +
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c             |    7 
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c          |   13 
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c |    6 
 drivers/gpu/drm/amd/display/include/dal_asic_id.h              |    2 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c            |    6 
 drivers/gpu/drm/i915/display/intel_dp.c                        |    3 
 drivers/gpu/drm/i915/gt/intel_timeline.c                       |    4 
 drivers/gpu/drm/ttm/ttm_bo_util.c                              |    1 
 drivers/infiniband/core/sa_query.c                             |    5 
 drivers/infiniband/hw/hfi1/pio.c                               |    9 
 drivers/infiniband/hw/irdma/uk.c                               |    4 
 drivers/infiniband/hw/irdma/verbs.c                            |    8 
 drivers/infiniband/hw/irdma/ws.c                               |   13 
 drivers/infiniband/hw/mlx5/mr.c                                |    2 
 drivers/infiniband/hw/mlx5/qp.c                                |    2 
 drivers/infiniband/hw/qib/qib_user_sdma.c                      |   33 +-
 drivers/mmc/host/cqhci-core.c                                  |    3 
 drivers/mmc/host/dw_mmc-exynos.c                               |   14 
 drivers/mmc/host/mtk-sd.c                                      |   38 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                             |   16 +
 drivers/mmc/host/sdhci-pci-core.c                              |   29 +
 drivers/mmc/host/sdhci.c                                       |    6 
 drivers/mmc/host/tmio_mmc_core.c                               |   17 -
 drivers/mmc/host/vub300.c                                      |   18 -
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                    |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c             |   10 
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c             |   33 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c     |   30 --
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c        |   30 ++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c          |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h          |    1 
 drivers/net/ethernet/intel/ice/ice_lag.c                       |   18 -
 drivers/net/ethernet/intel/ice/ice_ptp.c                       |    3 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c        |  148 +++++++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c            |    3 
 drivers/net/ethernet/mellanox/mlxsw/pci.c                      |   25 -
 drivers/net/ethernet/microchip/lan743x_main.c                  |   35 ++
 drivers/net/ethernet/nxp/lpc_eth.c                             |    5 
 drivers/net/phy/mdio_bus.c                                     |    1 
 drivers/net/phy/phy.c                                          |  140 +++++----
 drivers/net/usb/lan78xx.c                                      |    6 
 drivers/net/usb/usbnet.c                                       |    5 
 drivers/nfc/port100.c                                          |    4 
 drivers/nvme/host/tcp.c                                        |    9 
 drivers/nvme/target/tcp.c                                      |    2 
 drivers/pinctrl/bcm/pinctrl-ns.c                               |   29 -
 drivers/pinctrl/pinctrl-amd.c                                  |   31 ++
 drivers/reset/reset-brcmstb-rescal.c                           |    2 
 drivers/scsi/ibmvscsi/ibmvfc.c                                 |    3 
 drivers/scsi/ufs/ufs-exynos.c                                  |    6 
 drivers/virtio/virtio_ring.c                                   |    2 
 drivers/watchdog/iTCO_wdt.c                                    |   12 
 drivers/watchdog/sbsa_gwdt.c                                   |    4 
 fs/ocfs2/suballoc.c                                            |   22 -
 include/linux/bpf.h                                            |    7 
 include/linux/bpf_types.h                                      |    8 
 include/linux/page-flags.h                                     |   23 +
 include/net/cfg80211.h                                         |    2 
 include/net/tls.h                                              |    9 
 kernel/bpf/arraymap.c                                          |    1 
 kernel/bpf/core.c                                              |   20 -
 kernel/bpf/syscall.c                                           |   39 +-
 kernel/cgroup/cgroup.c                                         |    4 
 mm/huge_memory.c                                               |    2 
 mm/khugepaged.c                                                |   26 +
 mm/memory-failure.c                                            |   28 -
 mm/memory.c                                                    |    9 
 mm/page_alloc.c                                                |    4 
 net/batman-adv/bridge_loop_avoidance.c                         |    8 
 net/batman-adv/main.c                                          |   56 ++-
 net/batman-adv/network-coding.c                                |    4 
 net/batman-adv/translation-table.c                             |    4 
 net/core/dev.c                                                 |    6 
 net/core/net-sysfs.c                                           |    4 
 net/ipv4/tcp_bpf.c                                             |   12 
 net/mac80211/mesh.c                                            |    9 
 net/sctp/sm_statefuns.c                                        |  139 +++++----
 net/tipc/crypto.c                                              |   32 +-
 net/tls/tls_sw.c                                               |   19 -
 net/wireless/core.c                                            |    2 
 net/wireless/core.h                                            |    2 
 net/wireless/mlme.c                                            |   26 -
 net/wireless/scan.c                                            |    7 
 net/wireless/util.c                                            |   14 
 tools/perf/builtin-script.c                                    |   14 
 115 files changed, 1097 insertions(+), 564 deletions(-)

Aaron Liu (1):
      drm/amdgpu: support B0&B1 external revision id for yellow carp

Aharon Landau (1):
      RDMA/mlx5: Initialize the ODP xarray when creating an ODP MR

Alexandre Ghiti (2):
      riscv: Do not re-populate shadow memory with kasan_populate_early_shadow
      riscv: Fix asan-stack clang build

Andrew Lunn (4):
      phy: phy_ethtool_ksettings_get: Lock the phy for consistency
      phy: phy_ethtool_ksettings_set: Move after phy_start_aneg
      phy: phy_start_aneg: Add an unlocked version
      phy: phy_ethtool_ksettings_set: Lock the PHY while changing settings

Andy Shevchenko (1):
      mmc: sdhci-pci: Read card detect from ACPI for Intel Merrifield

Arnd Bergmann (4):
      ARM: 9134/1: remove duplicate memcpy() definition
      ARM: 9138/1: fix link warning with XIP + frame-pointer
      ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
      ARM: 9141/1: only warn about XIP address when not compile testing

Björn Töpel (1):
      riscv, bpf: Fix potential NULL dereference

Brian King (1):
      scsi: ibmvfc: Fix up duplicate response detection

Chanho Park (1):
      scsi: ufs: ufs-exynos: Correct timeout value setting registers

Chen Lu (1):
      riscv: fix misalgned trap vector base address

Christian König (1):
      drm/ttm: fix memleak in ttm_transfered_destroy

Clément Bœsch (1):
      arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node

Daniel Jordan (2):
      net/tls: Fix flipped sign in tls_err_abort() calls
      net/tls: Fix flipped sign in async_wait.err assignment

Dave Ertman (1):
      ice: Respond to a NETDEV_UNREGISTER event for LAG

David Woodhouse (3):
      KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()
      KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock
      KVM: x86: Take srcu lock in post_kvm_run_save()

Eric Yang (1):
      drm/amd/display: increase Z9 latency to workaround underflow in Z9

Frieder Schrempf (5):
      arm64: dts: imx8mm-kontron: Fix polarity of reg_rst_eth2
      arm64: dts: imx8mm-kontron: Fix CAN SPI clock frequency
      arm64: dts: imx8mm-kontron: Fix connection type for VSC8531 RGMII PHY
      arm64: dts: imx8mm-kontron: Set lower limit of VDD_SNVS to 800 mV
      arm64: dts: imx8mm-kontron: Make sure SOC and DRAM supply voltages are correct

Gautham Ananthakrishna (1):
      ocfs2: fix race between searching chunks and release journal_head from buffer_head

Greg Kroah-Hartman (1):
      Linux 5.14.16

Guangbin Huang (2):
      net: hns3: fix pause config problem after autoneg disabled
      net: hns3: expand buffer len for some debugfs command

Guenter Roeck (2):
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: clear the buffer_read_ready to reset standard tuning circuit

Halil Pasic (2):
      KVM: s390: clear kicked_mask before sleeping again
      KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu

Ido Schimmel (1):
      mlxsw: pci: Recycle received packet upon allocation failure

Imre Deak (1):
      drm/i915/dp: Skip the HW readout of DPCD on disabled encoders

Jaehoon Chung (1):
      mmc: dw_mmc: exynos: fix the finding clock sample value

Jake Wang (1):
      drm/amd/display: Moved dccg init to after bios golden init

Jamie Iles (1):
      watchdog: sbsa: only use 32-bit accessors

Janusz Dziedzic (1):
      cfg80211: correct bridge/4addr mode check

Jie Wang (2):
      net: hns3: fix data endian problem of some functions of debugfs
      net: hns3: add more string spaces for dumping packets number of queue info in debugfs

Jim Quinlan (1):
      reset: brcmstb-rescal: fix incorrect polarity of status bit

Johan Hovold (2):
      mmc: vub300: fix control-message timeouts
      net: lan78xx: fix division by zero in send path

Johannes Berg (3):
      cfg80211: scan: fix RCU in cfg80211_add_nontrans_list()
      cfg80211: fix management registrations locking
      mac80211: mesh: fix HE operation element length check

Jonas Gorski (1):
      gpio: xgs-iproc: fix parsing of ngpios property

Kan Liang (1):
      perf script: Fix PERF_SAMPLE_WEIGHT_STRUCT support

Krzysztof Kozlowski (1):
      nfc: port100: fix using -ERRNO as command type mask

LABBE Corentin (1):
      ARM: 9148/1: handle CONFIG_CPU_ENDIAN_BE32 in arch/arm/kernel/head.S

Lexi Shao (1):
      ARM: 9132/1: Fix __get_user_check failure with ARM KASAN images

Liu Jian (1):
      tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Mark Zhang (1):
      RDMA/sa_query: Use strscpy_pad instead of memcpy to copy a string

Max VA (1):
      tipc: fix size validations for the MSG_CRYPTO type

Michael Chan (1):
      net: Prevent infinite while loop in skb_tx_hash()

Michael Strauss (1):
      drm/amd/display: Fallback to clocks which meet requested voltage on DCN31

Mike Marciniszyn (2):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
      IB/hfi1: Fix abba locking issue with sc_disable()

Mustafa Ismail (2):
      RDMA/irdma: Set VLAN in UD work completion correctly
      RDMA/irdma: Do not hold qos mutex twice on QP resume

Nicholas Kazlauskas (3):
      drm/amd/display: Require immediate flip support for DCN3.1 planes
      drm/amd/display: Fix prefetch bandwidth calculation for DCN3.1
      drm/amd/display: Fix deadlock when falling back to v2 from v3

Nick Desaulniers (1):
      ARM: 9133/1: mm: proc-macros: ensure *_tlb_fns are 4B aligned

Nikola Cornij (2):
      drm/amd/display: Limit display scaling to up to true 4k for DCN 3.1
      drm/amd/display: Increase watermark latencies for DCN3.1

Oliver Neukum (1):
      usbnet: sanity check for maxpacket

Paolo Bonzini (1):
      KVM: SEV-ES: fix another issue with string I/O VMGEXITs

Patrik Jakobsson (1):
      drm/amdgpu: Fix even more out of bound writes from debugfs

Patrisious Haddad (1):
      RDMA/mlx5: Set user priority for DCT

Pavel Skripkin (2):
      Revert "net: mdiobus: Fix memory leak in __mdiobus_register"
      net: batman-adv: fix error handling

Quanyang Wang (1):
      cgroup: Fix memory leak caused by missing cgroup_bpf_offline

Rafał Miłecki (1):
      Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"

Rakesh Babu (1):
      octeontx2-af: Display all enabled PF VF rsrc_alloc entries.

Rakesh Babu Saladi (1):
      octeontx2-af: Fix possible null pointer dereference.

Rongwei Wang (1):
      mm, thp: bail out early in collapse_file for writeback page

Sachi King (1):
      pinctrl: amd: disable and mask interrupts on probe

Sagi Grimberg (1):
      nvme-tcp: fix H2CData PDU send accounting (again)

Shawn Guo (1):
      mmc: sdhci: Map more voltage level to SDHCI_POWER_330

Shin'ichiro Kawasaki (1):
      block: Fix partition check for host-aware zoned block devices

Shiraz Saleem (1):
      RDMA/irdma: Process extended CQ entries correctly

Song Liu (1):
      perf script: Check session->header.env.arch before using it

Stanislav Fomichev (1):
      bpf: Use kvmalloc for map values in syscall

Steven Rostedt (VMware) (1):
      ftrace/nds32: Update the proto for ftrace_trace_function to match ftrace_stub

Subbaraya Sundeep (1):
      octeontx2-af: Check whether ipolicers exists

Tejun Heo (1):
      bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE outside of CONFIG_NET

Thelford Williams (1):
      drm/amdgpu: fix out of bounds write

Toke Høiland-Jørgensen (1):
      bpf: Fix potential race in tail call compatibility check

Trevor Woerner (1):
      net: nxp: lpc_eth.c: avoid hang when bringing interface down

Varun Prakash (3):
      nvmet-tcp: fix data digest pointer calculation
      nvme-tcp: fix data digest pointer calculation
      nvme-tcp: fix possible req->offset corruption

Ville Syrjälä (2):
      drm/i915: Convert unconditional clflush to drm_clflush_virt_range()
      drm/i915: Catch yet another unconditioal clflush

Vincent Whitchurch (1):
      virtio-ring: fix DMA metadata flags

Wang Hai (1):
      usbnet: fix error return code in usbnet_probe()

Wenbin Mei (2):
      mmc: cqhci: clear HALT state after CQE enable
      mmc: mediatek: Move cqhci init behind ungate clock

Wolfram Sang (1):
      mmc: tmio: reenable card irqs after the reset callback

Xin Long (8):
      net-sysfs: initialize uid and gid before calling net_ns_get_ownership
      sctp: use init_tag from inithdr for ABORT chunk
      sctp: fix the processing for INIT chunk
      sctp: fix the processing for INIT_ACK chunk
      sctp: fix the processing for COOKIE_ECHO chunk
      sctp: add vtag check in sctp_sf_violation
      sctp: add vtag check in sctp_sf_do_8_5_1_E_sa
      sctp: add vtag check in sctp_sf_ootb

Xu Kuohai (1):
      bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()

Yang Shi (3):
      mm: hwpoison: remove the unnecessary THP check
      mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
      mm: khugepaged: skip huge page collapse for special files

Yang Yingliang (1):
      regmap: Fix possible double-free in regcache_rbtree_exit()

Yongxin Liu (1):
      ice: check whether PTP is initialized in ice_ptp_release()

Yuiko Oshino (3):
      net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
      net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent
      net: ethernet: microchip: lan743x: Fix skb allocation failure

Zheyu Ma (1):
      ata: sata_mv: Fix the error handling of mv_chip_id()

