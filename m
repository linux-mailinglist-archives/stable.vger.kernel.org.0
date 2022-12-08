Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048AA646D19
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiLHKgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiLHKfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:35:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B2083EBC;
        Thu,  8 Dec 2022 02:33:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F358561EA2;
        Thu,  8 Dec 2022 10:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F34DC433C1;
        Thu,  8 Dec 2022 10:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495603;
        bh=UHIGNhET15lEMkEF8qap4aZ2BiL4PChxfd2QvOn4glM=;
        h=From:To:Cc:Subject:Date:From;
        b=DqkpduuZGPQmQItHeD35x64e++hi5Bi/UC8zXb7nCLTjOg5CBkwObTODKW4dgOo3r
         Od0PToIeTd3LAWuyIZjDM4wNBwvryydMok8RD/munS5gZFr6J4QpIJtISkxlZyjiRs
         q/k9er7TLUcKRN/7Z6AQAW6ZwfBcv+/JR84ObQt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.82
Date:   Thu,  8 Dec 2022 11:33:16 +0100
Message-Id: <1670495597236120@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.82 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                           |    2 
 arch/arm/boot/dts/at91rm9200.dtsi                                  |    2 
 arch/arm64/kernel/mte.c                                            |    9 
 arch/arm64/mm/mteswap.c                                            |    7 
 arch/riscv/include/asm/asm.h                                       |    1 
 arch/riscv/include/asm/efi.h                                       |    6 
 arch/riscv/include/asm/pgalloc.h                                   |   11 
 arch/riscv/kernel/entry.S                                          |   13 
 arch/riscv/kernel/machine_kexec.c                                  |   35 ++
 arch/riscv/kernel/setup.c                                          |    9 
 arch/riscv/kernel/traps.c                                          |   18 +
 arch/riscv/kernel/vdso/Makefile                                    |    1 
 arch/x86/include/asm/nospec-branch.h                               |    2 
 arch/x86/kernel/cpu/bugs.c                                         |   21 +
 arch/x86/kernel/process.c                                          |    2 
 arch/x86/kvm/mmu/mmu.c                                             |   12 
 drivers/acpi/numa/hmat.c                                           |   27 +
 drivers/char/tpm/tpm-interface.c                                   |    5 
 drivers/clk/at91/at91rm9200.c                                      |    2 
 drivers/clocksource/timer-riscv.c                                  |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c                     |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c                            |    3 
 drivers/gpu/drm/amd/display/Kconfig                                |    7 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c                  |    3 
 drivers/gpu/drm/drm_dp_mst_topology.c                              |    2 
 drivers/gpu/drm/i915/gem/i915_gem_internal.c                       |   44 +--
 drivers/gpu/drm/i915/gt/gen6_ppgtt.c                               |  137 +++++-----
 drivers/gpu/drm/i915/gt/gen6_ppgtt.h                               |    1 
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c                               |   56 ++--
 drivers/gpu/drm/i915/gt/intel_gt.c                                 |    9 
 drivers/gpu/drm/i915/gt/intel_gt_requests.c                        |    2 
 drivers/gpu/drm/i915/gt/intel_gtt.c                                |    3 
 drivers/gpu/drm/i915/i915_drv.h                                    |    4 
 drivers/hwmon/coretemp.c                                           |    9 
 drivers/hwmon/i5500_temp.c                                         |    2 
 drivers/hwmon/ibmpex.c                                             |    1 
 drivers/hwmon/ina3221.c                                            |    4 
 drivers/hwmon/ltc2947-core.c                                       |    2 
 drivers/i2c/busses/i2c-imx.c                                       |    6 
 drivers/i2c/busses/i2c-npcm7xx.c                                   |   11 
 drivers/iio/health/afe4403.c                                       |    5 
 drivers/iio/health/afe4404.c                                       |   12 
 drivers/iio/light/Kconfig                                          |    2 
 drivers/input/touchscreen/raydium_i2c_ts.c                         |    4 
 drivers/iommu/intel/dmar.c                                         |    1 
 drivers/iommu/intel/iommu.c                                        |    4 
 drivers/media/common/videobuf2/frame_vector.c                      |   53 ---
 drivers/mmc/core/core.c                                            |    9 
 drivers/mmc/core/mmc_test.c                                        |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                                 |    2 
 drivers/mmc/host/sdhci-sprd.c                                      |    4 
 drivers/mmc/host/sdhci.c                                           |   61 +++-
 drivers/mmc/host/sdhci.h                                           |    2 
 drivers/net/can/cc770/cc770_isa.c                                  |   10 
 drivers/net/can/m_can/m_can.c                                      |    2 
 drivers/net/can/m_can/m_can_pci.c                                  |    9 
 drivers/net/can/sja1000/sja1000_isa.c                              |   10 
 drivers/net/can/usb/etas_es58x/es58x_core.c                        |    5 
 drivers/net/dsa/lan9303-core.c                                     |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c                |    5 
 drivers/net/ethernet/aquantia/atlantic/aq_main.c                   |    4 
 drivers/net/ethernet/aquantia/atlantic/aq_main.h                   |    2 
 drivers/net/ethernet/intel/e100.c                                  |    5 
 drivers/net/ethernet/intel/fm10k/fm10k_main.c                      |   10 
 drivers/net/ethernet/intel/i40e/i40e_main.c                        |   11 
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |    8 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                  |   10 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                      |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |    2 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c      |   26 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c        |    7 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h        |    2 
 drivers/net/ethernet/ni/nixge.c                                    |   29 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                |    4 
 drivers/net/ethernet/renesas/ravb_main.c                           |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                  |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |   12 
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                           |    2 
 drivers/net/mdio/fwnode_mdio.c                                     |    2 
 drivers/net/ntb_netdev.c                                           |    9 
 drivers/net/phy/phy_device.c                                       |    2 
 drivers/net/tun.c                                                  |    4 
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c                         |    3 
 drivers/net/wwan/iosm/iosm_ipc_protocol.h                          |    2 
 drivers/nvme/host/core.c                                           |    2 
 drivers/nvme/host/multipath.c                                      |    3 
 drivers/nvmem/rmem.c                                               |    4 
 drivers/of/property.c                                              |    4 
 drivers/pinctrl/intel/pinctrl-intel.c                              |   27 +
 drivers/pinctrl/pinctrl-single.c                                   |    2 
 drivers/spi/spi-imx.c                                              |    3 
 drivers/tty/serial/stm32-usart.c                                   |  131 ++++++---
 drivers/tty/serial/stm32-usart.h                                   |    1 
 fs/afs/fs_probe.c                                                  |    4 
 fs/btrfs/backref.c                                                 |   25 +
 fs/btrfs/backref.h                                                 |    3 
 fs/btrfs/ioctl.c                                                   |   38 --
 fs/btrfs/qgroup.c                                                  |   22 -
 fs/erofs/inode.c                                                   |    2 
 fs/io_uring.c                                                      |   57 +++-
 fs/nilfs2/dat.c                                                    |    7 
 include/linux/mmc/mmc.h                                            |    2 
 include/linux/swap.h                                               |    1 
 include/net/sctp/stream_sched.h                                    |    2 
 ipc/sem.c                                                          |    3 
 kernel/bpf/bpf_local_storage.c                                     |    2 
 kernel/events/core.c                                               |    2 
 kernel/sysctl.c                                                    |   30 +-
 kernel/trace/trace_dynevent.c                                      |    2 
 kernel/trace/trace_events.c                                        |   11 
 kernel/trace/trace_events_hist.c                                   |    3 
 kernel/trace/trace_osnoise.c                                       |    6 
 lib/Kconfig.debug                                                  |   14 -
 mm/compaction.c                                                    |   67 +++-
 mm/vmscan.c                                                        |  101 +------
 net/9p/trans_fd.c                                                  |    4 
 net/hsr/hsr_forward.c                                              |    5 
 net/ipv4/fib_semantics.c                                           |   10 
 net/mac80211/airtime.c                                             |    3 
 net/packet/af_packet.c                                             |    6 
 net/sctp/stream.c                                                  |   25 +
 net/sctp/stream_sched.c                                            |    5 
 net/sctp/stream_sched_prio.c                                       |   19 +
 net/sctp/stream_sched_rr.c                                         |    5 
 net/tipc/crypto.c                                                  |    3 
 net/wireless/scan.c                                                |   10 
 scripts/faddr2line                                                 |    7 
 sound/firewire/dice/dice-stream.c                                  |   12 
 sound/soc/soc-ops.c                                                |    2 
 tools/lib/bpf/ringbuf.c                                            |   12 
 tools/testing/selftests/net/fib_nexthops.sh                        |   30 ++
 tools/vm/slabinfo-gnuplot.sh                                       |    4 
 132 files changed, 1051 insertions(+), 557 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix voltage switch delay

Alex Deucher (1):
      drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"

Alexandre Ghiti (1):
      riscv: Sync efi page table's kernel mappings before switching

Anand Jain (1):
      btrfs: free btrfs_path before copying inodes to userspace

Andrew Lunn (1):
      i2c: imx: Only DMA messages with I2C_M_DMA_SAFE flag set

Andy Shevchenko (1):
      pinctrl: intel: Save and restore pins in "direct IRQ" mode

Björn Töpel (1):
      riscv: mm: Proper page permissions after initmem free

Caleb Sander (1):
      nvme: fix SRCU protection of nvme_ns_head list

Catalin Marinas (1):
      arm64: mte: Avoid setting PG_mte_tagged if no tags cleared or restored

ChenXiaoSong (1):
      btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()

Chris Wilson (1):
      drm/i915/gt: Use i915_vm_put on ppgtt_create error paths

Christian Löhle (1):
      mmc: core: Fix ambiguous TRIM and DISCARD arg

Claudio Suarez (1):
      drm/amdgpu: update drm_display_info correctly when the edid is read

Conor Dooley (1):
      Revert "clocksource/drivers/riscv: Events are stopped during CPU suspend"

Daniel Bristot de Oliveira (1):
      tracing/osnoise: Fix duration type

David Ahern (1):
      ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference

David Howells (1):
      afs: Fix fileserver probe RTT handling

David Sterba (1):
      btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino

Derek Nguyen (1):
      hwmon: (ltc2947) fix temperature scaling

Duoming Zhou (1):
      qlcnic: fix sleep-in-atomic-context bugs caused by msleep

Frieder Schrempf (1):
      spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Gao Xiang (1):
      erofs: fix order >= MAX_ORDER warning due to crafted negative i_size

Gaosheng Cui (1):
      hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails

Gavin Shan (1):
      mm: migrate: fix THP's mapcount on isolation

Goh, Wei Sheng (1):
      net: stmmac: Set MAC's flow control register to reflect current settings

Greg Kroah-Hartman (1):
      Linux 5.15.82

Guo Ren (1):
      riscv: kexec: Fixup irq controller broken in kexec crash path

Helge Deller (1):
      parisc: Increase FRAME_WARN to 2048 bytes on parisc

Hou Tao (2):
      bpf, perf: Use subprog name when reporting subprog ksymbol
      libbpf: Handle size overflow for ringbuf mmap

Hugh Dickins (1):
      mm: __isolate_lru_page_prepare() in isolate_migratepages_block()

Ido Schimmel (1):
      ipv4: Fix route deletion when nexthop info is not specified

Izabela Bakollari (1):
      aquantia: Do not purge addresses when setting the number of rings

Jan Dabros (1):
      char: tpm: Protect tpm_pm_suspend with locks

Jann Horn (1):
      ipc/sem: Fix dangling sem_array access in semtimedop race

Janusz Krzysztofik (2):
      drm/i915: Fix negative value passed as remaining time
      drm/i915: Never return 0 if not all requests retired

Jerry Ray (1):
      dsa: lan9303: Correct stat name

Jiasheng Jiang (1):
      can: m_can: Add check for devm_clk_get

Jisheng Zhang (2):
      riscv: vdso: fix section overlapping under some conditions
      riscv: fix race when vmap stack overflow

Johannes Berg (2):
      wifi: cfg80211: fix buffer overflow in elem comparison
      wifi: cfg80211: don't allow multi-BSSID in S1G

Kazuki Takiguchi (1):
      KVM: x86/mmu: Fix race condition in direct_page_fault

Lee Jones (2):
      drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
      Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled

Leo Liu (1):
      drm/amdgpu: enable Vangogh VCN indirect sram mode

Lin Ma (1):
      io_uring/poll: fix poll_refs race with cancelation

Linus Torvalds (3):
      v4l2: don't fall back to follow_pfn() if pin_user_pages_fast() fails
      proc: avoid integer type confusion in get_proc_long
      proc: proc_skip_spaces() shouldn't think it is working on C strings

Lorenzo Bianconi (1):
      wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration

Lukas Wunner (1):
      serial: stm32: Deassert Transmit Enable on ->rs485_config()

Lyude Paul (1):
      drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code

M Chetan Kumar (2):
      net: wwan: iosm: fix kernel test robot reported error
      net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type

Maarten Lankhorst (1):
      drm/i915: Create a dummy object for gen6 ppgtt

Marek Vasut (2):
      serial: stm32: Factor out GPIO RTS toggling into separate function
      serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode

Mark Brown (1):
      ASoC: ops: Fix bounds check for _sx controls

Maxim Korotkov (1):
      pinctrl: single: Fix potential division by zero

Michael Grzeschik (1):
      ARM: at91: rm9200: fix usb device clock id

Minghao Chi (1):
      iavf: remove redundant ret variable

Nikolay Aleksandrov (2):
      selftests: net: add delete nexthop route warning test
      selftests: net: fix nexthop warning cleanup double ip typo

Nikolay Borisov (1):
      btrfs: move QUOTA_ENABLED check to rescan_should_stop from btrfs_qgroup_rescan_worker

Ninad Malwade (1):
      hwmon: (ina3221) Fix shunt sum critical calculation

Paul Gazzillo (1):
      iio: light: rpr0521: add missing Kconfig dependencies

Pavel Begunkov (4):
      io_uring: update res mask in io_poll_check_events
      io_uring: fix tw losing poll events
      io_uring: cmpxchg for poll arm refs release
      io_uring: make poll refs more robust

Pawan Gupta (1):
      x86/bugs: Make sure MSR_SPEC_CTRL is updated properly upon resume from S3

Phil Auld (1):
      hwmon: (coretemp) Check for null before removing sysfs attrs

Roi Dayan (1):
      net/mlx5e: Fix use-after-free when reverting termination table

Sebastian Falbesoner (1):
      mmc: sdhci-esdhc-imx: correct CQHCI exit halt state check

Shang XiaoJing (2):
      ixgbevf: Fix resource leak in ixgbevf_init_module()
      i40e: Fix error handling in i40e_init_module()

Shigeru Yoshida (1):
      net: tun: Fix use-after-free in tun_detach()

Srikar Dronamraju (1):
      scripts/faddr2line: Fix regression in name resolution on ppc64le

Steven Rostedt (Google) (3):
      error-injection: Add prompt for function error injection
      tracing: Fix race where histograms can be called before the event
      tracing: Free buffers when a used dynamic event is removed

Takashi Sakamoto (1):
      ALSA: dice: fix regression for Lexicon I-ONIX FW810S

Tiezhu Yang (1):
      tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"

Vishal Verma (2):
      ACPI: HMAT: remove unnecessary variable initialization
      ACPI: HMAT: Fix initiator registration for single-initiator systems

Wang Hai (2):
      e100: Fix possible use after free in e100_xmit_prepare
      net/9p: Fix a potential socket leak in p9_socket_open

Wei Yongjun (3):
      iio: health: afe4403: Fix oob read in afe4403_read_raw
      iio: health: afe4404: Fix oob read in afe4404_[read|write]_raw
      nvmem: rmem: Fix return value check in rmem_read()

Wenchao Chen (1):
      mmc: sdhci-sprd: Fix no reset data and command after voltage switch

Willem de Bruijn (1):
      packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE

Xin Long (1):
      tipc: re-fetch skb cb after tipc_msg_validate

Xiongfeng Wang (2):
      iommu/vt-d: Fix PCI device refcount leak in has_external_pci()
      iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()

Xu Kuohai (1):
      bpf: Do not copy spin lock field from user in bpf_selem_alloc

Yang Yingliang (5):
      hwmon: (i5500_temp) fix missing pci_disable_device()
      of: property: decrement node refcount in of_fwnode_get_reference_args()
      net: phy: fix null-ptr-deref while probe() failed
      net: mdiobus: fix unbalanced node reference count
      hwmon: (coretemp) fix pci device refcount leak in nv1a_ram_new()

Ye Bin (1):
      mmc: mmc_test: Fix removal of debugfs file

Yevgeny Kliteynik (1):
      net/mlx5: DR, Rename list field in matcher struct to list_node

Yoshihiro Shimoda (1):
      net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed

Yuan Can (4):
      fm10k: Fix error handling in fm10k_init_module()
      iavf: Fix error handling in iavf_init_module()
      net: net_netdev: Fix error handling in ntb_netdev_init_module()
      i2c: npcm7xx: Fix error handling in npcm_i2c_init()

YueHaibing (3):
      net/mlx5: DR, Fix uninitialized var warning
      net/mlx5: Fix uninitialized variable bug in outlen_write()
      net: hsr: Fix potential use-after-free

Yuri Karpov (1):
      net: ethernet: nixge: fix NULL dereference

Zhang Changzhong (5):
      can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
      can: cc770: cc770_isa_probe(): add missing free_cc770dev()
      can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
      can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods
      net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()

Zhang Xiaoxu (1):
      Input: raydium_ts_i2c - fix memory leak in raydium_i2c_send()

ZhangPeng (1):
      nilfs2: fix NULL pointer dereference in nilfs_palloc_commit_free_entry()

Zhengchao Shao (1):
      sctp: fix memory leak in sctp_stream_outq_migrate()

