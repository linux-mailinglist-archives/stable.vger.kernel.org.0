Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1E4D201D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349578AbiCHSXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245268AbiCHSXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7C811143;
        Tue,  8 Mar 2022 10:22:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16BEFB81C1B;
        Tue,  8 Mar 2022 18:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BB5C340EB;
        Tue,  8 Mar 2022 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763752;
        bh=2L0SbVtbEN7BjQB8Qx+DpMnHc0eilk85s/NRh9tf6Dw=;
        h=From:To:Cc:Subject:Date:From;
        b=Y9feBJbC6pNG9HqVa8ZICIIeMXTI3nvssm2FDeONh2UazdiFaPUSHIxofjrHPHM9h
         n9A3JZtwUUa+yuSRufvPO/h0WCfCWCpJOIhfFEy6yJ2qVFJ6iXPkQlbILS0ytTIwUo
         XyZKe9vuplcoObzuBSKpjuvU9u5Idg7O5AXXMGRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.13
Date:   Tue,  8 Mar 2022 19:22:16 +0100
Message-Id: <1646763737122246@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.13 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/mm/pagemap.rst                             |    2 
 Documentation/arm64/silicon-errata.rst                               |    2 
 Documentation/trace/events.rst                                       |   19 
 Documentation/virt/kvm/api.rst                                       |    2 
 Makefile                                                             |    2 
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi                       |   18 
 arch/arm/boot/dts/omap3-devkit8000.dts                               |   33 -
 arch/arm/boot/dts/tegra124-nyan-big.dts                              |   15 
 arch/arm/boot/dts/tegra124-nyan-blaze.dts                            |   15 
 arch/arm/boot/dts/tegra124-venice2.dts                               |   14 
 arch/arm/kernel/kgdb.c                                               |   36 +
 arch/arm/mm/mmu.c                                                    |    2 
 arch/arm64/Kconfig                                                   |   16 
 arch/arm64/boot/dts/arm/juno-base.dtsi                               |    3 
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                            |    1 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi                         |   17 
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts                   |    2 
 arch/arm64/boot/dts/rockchip/rk3568.dtsi                             |    6 
 arch/arm64/kernel/cpu_errata.c                                       |    8 
 arch/arm64/kernel/stacktrace.c                                       |    3 
 arch/arm64/kvm/hyp/include/hyp/switch.h                              |   20 
 arch/arm64/kvm/vgic/vgic-mmio.c                                      |    2 
 arch/arm64/tools/cpucaps                                             |    5 
 arch/mips/kernel/setup.c                                             |    2 
 arch/mips/ralink/mt7621.c                                            |   36 -
 arch/riscv/mm/Makefile                                               |    3 
 arch/riscv/mm/kasan_init.c                                           |    3 
 arch/s390/include/asm/extable.h                                      |    9 
 arch/s390/include/asm/ftrace.h                                       |   10 
 arch/s390/include/asm/ptrace.h                                       |    2 
 arch/s390/kernel/ftrace.c                                            |   37 +
 arch/s390/kernel/mcount.S                                            |    9 
 arch/s390/kernel/setup.c                                             |    2 
 arch/x86/kernel/kvmclock.c                                           |    3 
 arch/x86/kvm/mmu/mmu.c                                               |    2 
 arch/x86/kvm/x86.c                                                   |    1 
 block/blk-map.c                                                      |    2 
 drivers/ata/pata_hpt37x.c                                            |    4 
 drivers/auxdisplay/lcd2s.c                                           |   24 
 drivers/block/loop.c                                                 |    8 
 drivers/clocksource/timer-ti-dm-systimer.c                           |    3 
 drivers/dma/sh/shdma-base.c                                          |    4 
 drivers/firmware/arm_scmi/driver.c                                   |    2 
 drivers/firmware/efi/libstub/riscv-stub.c                            |   17 
 drivers/firmware/efi/vars.c                                          |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                               |   10 
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                     |    4 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c              |   26 -
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.h              |    8 
 drivers/gpu/drm/bridge/ti-sn65dsi86.c                                |    5 
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c                          |    2 
 drivers/gpu/drm/i915/intel_pch.c                                     |    2 
 drivers/gpu/drm/i915/intel_pch.h                                     |    2 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                               |   69 ++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h                               |    2 
 drivers/hid/hid-debug.c                                              |    5 
 drivers/hid/hid-input.c                                              |    3 
 drivers/i2c/busses/Kconfig                                           |    6 
 drivers/i2c/busses/i2c-bcm2835.c                                     |   11 
 drivers/input/input.c                                                |    6 
 drivers/input/keyboard/Kconfig                                       |    2 
 drivers/input/mouse/elan_i2c_core.c                                  |   64 --
 drivers/iommu/amd/amd_iommu.h                                        |    1 
 drivers/iommu/amd/amd_iommu_types.h                                  |    1 
 drivers/iommu/amd/init.c                                             |   10 
 drivers/iommu/amd/io_pgtable.c                                       |   12 
 drivers/iommu/amd/iommu.c                                            |   10 
 drivers/iommu/intel/iommu.c                                          |    2 
 drivers/iommu/tegra-smmu.c                                           |    4 
 drivers/net/arcnet/com20020-pci.c                                    |    3 
 drivers/net/can/usb/etas_es58x/es58x_core.c                          |    9 
 drivers/net/can/usb/etas_es58x/es58x_core.h                          |    8 
 drivers/net/can/usb/gs_usb.c                                         |   10 
 drivers/net/dsa/microchip/ksz_common.c                               |   26 -
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                           |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                                   |  247 +++++++---
 drivers/net/ethernet/ibm/ibmvnic.h                                   |    1 
 drivers/net/ethernet/intel/e1000e/hw.h                               |    1 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                          |    8 
 drivers/net/ethernet/intel/e1000e/ich8lan.h                          |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                           |   26 +
 drivers/net/ethernet/intel/iavf/iavf.h                               |    6 
 drivers/net/ethernet/intel/iavf/iavf_main.c                          |  152 ++++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                      |   14 
 drivers/net/ethernet/intel/igc/igc_phy.c                             |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                         |    6 
 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c                  |   20 
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c                      |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                         |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                    |  170 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c                     |    4 
 drivers/net/ipa/Kconfig                                              |    2 
 drivers/net/usb/cdc_mbim.c                                           |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                     |   11 
 drivers/net/wireless/mac80211_hwsim.c                                |   13 
 drivers/net/xen-netfront.c                                           |   39 -
 drivers/ntb/hw/intel/ntb_hw_gen4.c                                   |   17 
 drivers/ntb/hw/intel/ntb_hw_gen4.h                                   |   16 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                                |    9 
 drivers/platform/x86/amd-pmc.c                                       |   34 +
 drivers/ptp/ptp_ocp.c                                                |   25 -
 drivers/regulator/core.c                                             |   13 
 drivers/soc/fsl/guts.c                                               |   14 
 drivers/soc/fsl/qe/qe_io.c                                           |    2 
 drivers/soc/imx/gpcv2.c                                              |    3 
 drivers/thermal/thermal_netlink.c                                    |    5 
 drivers/tty/serial/stm32-usart.c                                     |   12 
 drivers/usb/gadget/legacy/inode.c                                    |   10 
 fs/binfmt_elf.c                                                      |   25 -
 fs/btrfs/ctree.h                                                     |   10 
 fs/btrfs/disk-io.c                                                   |   10 
 fs/btrfs/extent-tree.c                                               |   10 
 fs/btrfs/extent_io.c                                                 |   16 
 fs/btrfs/extent_map.c                                                |    2 
 fs/btrfs/extent_map.h                                                |    8 
 fs/btrfs/inode.c                                                     |  170 ++++--
 fs/btrfs/ioctl.c                                                     |  175 ++++++-
 fs/btrfs/qgroup.c                                                    |    9 
 fs/btrfs/relocation.c                                                |   13 
 fs/btrfs/root-tree.c                                                 |   15 
 fs/btrfs/subpage.c                                                   |    2 
 fs/btrfs/transaction.c                                               |   77 ++-
 fs/btrfs/transaction.h                                               |    1 
 fs/btrfs/tree-log.c                                                  |   61 +-
 fs/cifs/cifsacl.c                                                    |    9 
 fs/cifs/cifsfs.c                                                     |    1 
 fs/exfat/file.c                                                      |   18 
 fs/exfat/inode.c                                                     |   13 
 fs/exfat/namei.c                                                     |    6 
 fs/exfat/super.c                                                     |   10 
 fs/ext4/ext4.h                                                       |   15 
 fs/ext4/extents.c                                                    |    6 
 fs/ext4/fast_commit.c                                                |  218 +++-----
 fs/ext4/fast_commit.h                                                |   27 -
 fs/ext4/inode.c                                                      |    4 
 fs/ext4/ioctl.c                                                      |    5 
 fs/ext4/namei.c                                                      |    4 
 fs/ext4/super.c                                                      |    3 
 fs/ext4/xattr.c                                                      |    6 
 fs/jbd2/commit.c                                                     |    2 
 fs/jbd2/journal.c                                                    |    2 
 fs/proc/task_mmu.c                                                   |    3 
 include/linux/jbd2.h                                                 |    2 
 include/linux/sched/task.h                                           |    4 
 include/net/bluetooth/bluetooth.h                                    |    3 
 include/net/ndisc.h                                                  |    4 
 include/net/netfilter/nf_queue.h                                     |    2 
 include/net/xfrm.h                                                   |    1 
 include/uapi/linux/input-event-codes.h                               |    4 
 include/uapi/linux/xfrm.h                                            |    6 
 kernel/fork.c                                                        |   13 
 kernel/sched/core.c                                                  |   23 
 kernel/trace/blktrace.c                                              |   26 -
 kernel/trace/trace.c                                                 |    4 
 kernel/trace/trace_events_filter.c                                   |  107 ++++
 kernel/trace/trace_events_hist.c                                     |    6 
 kernel/trace/trace_kprobe.c                                          |    2 
 kernel/user_namespace.c                                              |   14 
 mm/memfd.c                                                           |   40 +
 mm/util.c                                                            |    4 
 net/batman-adv/hard-interface.c                                      |   29 -
 net/core/skbuff.c                                                    |    2 
 net/core/skmsg.c                                                     |    2 
 net/dcb/dcbnl.c                                                      |   44 +
 net/ipv4/esp4.c                                                      |    2 
 net/ipv6/addrconf.c                                                  |    8 
 net/ipv6/esp6.c                                                      |    2 
 net/ipv6/ip6_output.c                                                |   11 
 net/ipv6/mcast.c                                                     |   32 -
 net/mac80211/ieee80211_i.h                                           |    2 
 net/mac80211/mlme.c                                                  |   16 
 net/mac80211/rx.c                                                    |   14 
 net/mptcp/protocol.c                                                 |    7 
 net/netfilter/core.c                                                 |    5 
 net/netfilter/nf_queue.c                                             |   36 +
 net/netfilter/nf_tables_api.c                                        |    4 
 net/netfilter/nfnetlink_queue.c                                      |   12 
 net/smc/af_smc.c                                                     |   10 
 net/smc/smc_core.c                                                   |    5 
 net/tipc/crypto.c                                                    |    2 
 net/wireless/nl80211.c                                               |   12 
 net/xfrm/xfrm_device.c                                               |    6 
 net/xfrm/xfrm_interface.c                                            |    2 
 net/xfrm/xfrm_state.c                                                |   14 
 sound/soc/codecs/cs4265.c                                            |    3 
 sound/soc/codecs/rt5668.c                                            |   12 
 sound/soc/codecs/rt5682.c                                            |   12 
 sound/soc/codecs/rt5682s.c                                           |   12 
 sound/soc/soc-ops.c                                                  |    4 
 sound/x86/intel_hdmi_audio.c                                         |    2 
 tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh |    2 
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh         |    3 
 tools/testing/selftests/ftrace/test.d/ftrace/func_set_ftrace_file.tc |    2 
 tools/testing/selftests/seccomp/Makefile                             |    2 
 194 files changed, 2342 insertions(+), 868 deletions(-)

Aaron Lewis (1):
      KVM: x86: Add KVM_CAP_ENABLE_CAP to x86

Adam Ford (1):
      arm64: dts: imx8mm: Fix VPU Hanging

Adrian Huang (1):
      iommu/vt-d: Fix double list_add when enabling VMD in scalable mode

Alex Elder (2):
      net: ipa: fix a build dependency
      net: ipa: add an interconnect dependency

Alexander Egorenkov (1):
      s390/setup: preserve memory at OLDMEM_BASE and OLDMEM_SIZE

Alexandre Ghiti (2):
      riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP
      riscv: Fix config KASAN && DEBUG_VIRTUAL

Alyssa Ross (1):
      firmware: arm_scmi: Remove space in MODULE_ALIAS name

Amit Cohen (2):
      selftests: mlxsw: tc_police_scale: Make test more robust
      selftests: mlxsw: resource_scale: Fix return value

Andy Shevchenko (3):
      auxdisplay: lcd2s: Fix lcd2s_redefine_char() feature
      auxdisplay: lcd2s: Fix memory leak in ->remove()
      auxdisplay: lcd2s: Use proper API to free the instance of charlcd object

Anthoine Bourgeois (2):
      ARM: dts: switch timer config to common devkit8000 devicetree
      ARM: dts: Use 32KiHz oscillator on devkit8000

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Basavaraj Natikar (3):
      HID: amd_sfh: Handle amd_sfh work buffer in PM ops
      HID: amd_sfh: Add functionality to clear interrupts
      HID: amd_sfh: Add interrupt handler to process interrupts

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Brian Norris (1):
      arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Casper Andersson (1):
      net: sparx5: Fix add vlan when invalid operation

Christophe JAILLET (2):
      soc: fsl: guts: Revert commit 3c0d64e867ed
      soc: fsl: guts: Add a missing memory allocation failure check

Christophe Vu-Brugier (2):
      exfat: reuse exfat_inode_info variable instead of calling EXFAT_I()
      exfat: fix i_blocks for files truncated over 4 GiB

Chuanhong Guo (1):
      MIPS: ralink: mt7621: do memory detection on KSEG1

Corinna Vinschen (1):
      igc: igc_read_phy_reg_gpy: drop premature return

D. Wythe (3):
      net/smc: fix connection leak
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

Daniel Borkmann (1):
      mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Dany Madden (1):
      ibmvnic: Update driver return codes

Dave Jiang (1):
      ntb: intel: fix port config status offset for SPR

David Gow (1):
      Input: samsung-keypad - properly state IOMEM dependency

Deren Wu (1):
      mac80211: fix EAPoL rekey fail in 802.3 rx path

Dexuan Cui (1):
      x86/kvmclock: Fix Hyper-V Isolated VM's boot issue when vCPUs > 64

Douglas Anderson (1):
      drm/bridge: ti-sn65dsi86: Properly undo autosuspend

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (4):
      ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
      netfilter: fix use-after-free in __nf_register_net_hook()
      bpf, sockmap: Do not ignore orig_len parameter
      netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant

Eric W. Biederman (1):
      ucounts: Fix systemd LimitNPROC with private users regression

Evan Quan (1):
      drm/amd/pm: correct UMD pstate clocks for Dimgrey Cavefish and Beige Goby

Fabio Estevam (1):
      ASoC: cs4265: Fix the duplicated control name

Filipe Manana (5):
      btrfs: get rid of warning on transaction commit when using flushoncommit
      btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range
      btrfs: fix lost prealloc extents beyond eof after full fsync
      btrfs: add missing run of delayed items after unlink during log replay
      btrfs: fallback to blocking mode when doing async dio over multiple extents

Florian Westphal (3):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free
      netfilter: nf_queue: handle socket prefetch

Frank Wunderlich (1):
      arm64: dts: rockchip: drop pclk_xpcs from gmac0 on rk3568

Greg Kroah-Hartman (1):
      Linux 5.16.13

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Hangyu Hua (3):
      tipc: fix a bit overflow in tipc_crypto_key_rcv()
      usb: gadget: don't release an existing dev->buf
      usb: gadget: clear related members when goto fail

Hans de Goede (2):
      Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
      Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Harshad Shirwadkar (2):
      ext4: drop ineligible txn start stop APIs
      ext4: simplify updating of fast commit stats

Heiko Carstens (3):
      s390/extable: fix exception table sorting
      s390/ftrace: fix arch_ftrace_get_regs implementation
      s390/ftrace: fix ftrace_caller/ftrace_regs_caller generation

Hugh Dickins (1):
      memfd: fix F_SEAL_WRITE after shmem huge page allocated

Ilya Lipnitskiy (1):
      MIPS: ralink: mt7621: use bitwise NOT instead of logical

JaeMan Park (1):
      mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

James Morse (1):
      KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata

Jann Horn (1):
      efivars: Respect "block" flag in efivar_entry_set_safe()

Jedrzej Jagielski (1):
      iavf: Add trace while removing device

Jia-Ju Bai (1):
      net: chelsio: cxgb3: check the return value of pci_find_capability()

Jiasheng Jiang (2):
      soc: fsl: qe: Check of ioremap return value
      nl80211: Handle nla_memdup failures in handle_nan_filter

Jiri Bohac (2):
      xfrm: fix MTU regression
      Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"

Johannes Berg (1):
      mac80211: treat some SAE auth steps as final

Jonathan Lemon (1):
      ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments

Josef Bacik (2):
      btrfs: do not WARN_ON() if we have PageError set
      btrfs: do not start relocation until in progress drops are done

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

Kai Vehmanen (3):
      ASoC: rt5682s: do not block workqueue if card is unbound
      ASoC: rt5668: do not block workqueue if card is unbound
      ASoC: rt5682: do not block workqueue if card is unbound

Kees Cook (1):
      binfmt_elf: Avoid total_mapping_size for ET_EXEC

Krzysztof Kozlowski (1):
      selftests/ftrace: Do not trace do_softirq because of PREEMPT_RT

Laurent Pinchart (1):
      soc: imx: gpcv2: Fix clock disabling imbalance in error path

Lennert Buytenhek (1):
      iommu/amd: Recover from event log overflow

Leo (Hanghong) Ma (1):
      drm/amd/display: Reduce dmesg error to a debug print

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Like Xu (1):
      KVM: x86/mmu: Passing up the error state of mmu_alloc_shadow_roots()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Maciej Fijalkowski (1):
      ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Marek Vasut (1):
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Mario Limonciello (1):
      platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer wakeup

Masami Hiramatsu (1):
      arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL

Mat Martineau (1):
      mptcp: Correctly set DATA_FIN timeout when number of retransmits is large

Miaoqian Lin (1):
      iommu/tegra-smmu: Fix missing put_device() call in tegra_smmu_find

Ming Lei (1):
      block: loop:use kstatfs.f_bsize of backing file to set discard granularity

Nicolas Cavallari (1):
      thermal: core: Fix TZ_GET_TRIP NULL pointer dereference

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Oliver Barta (1):
      regulator: core: fix false positive in regulator_late_cleanup()

Omar Sandoval (1):
      btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()

Ong Boon Leong (2):
      net: stmmac: enhance XDP ZC driver level switching performance
      net: stmmac: perserve TX and RX coalesce value during XDP setup

Peter Geis (1):
      arm64: dts: rockchip: fix Quartz64-A ddr regulator voltage

Peter Zijlstra (1):
      sched: Fix yet more sched_fork() races

Qiang Yu (2):
      drm/amdgpu: check vm ready by amdgpu_vm->evicting flag
      drm/amdgpu: fix suspend/resume hang regression

Qu Wenruo (3):
      btrfs: defrag: bring back the old file extent search behavior
      btrfs: defrag: don't use merged extent map for their generation check
      btrfs: subpage: fix a wrong check on subpage->writers

Randy Dunlap (6):
      iwlwifi: mvm: check debugfs_dir ptr before use
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      mips: setup: fix setnocoherentio() boolean setting
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions
      tracing: Fix return value of __setup handlers

Robin Murphy (1):
      arm64: dts: juno: Remove GICv2m dma-range

Ronnie Sahlberg (3):
      cifs: do not use uninitialized data in the owner/group sid
      cifs: fix double free race when mount fails in cifs_get_root()
      cifs: modefromsids must add an ACE for authenticated users

Russell King (Oracle) (1):
      ARM: Fix kgdb breakpoint for Thumb2

Samuel Holland (1):
      pinctrl: sunxi: Use unique lockdep classes for IRQs

Sasha Neftin (3):
      e1000e: Correct NVM checksum verification flow
      igc: igc_write_phy_reg_gpy: drop premature return
      e1000e: Fix possible HW unit hang after an s0ix exit

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

Sherry Yang (1):
      selftests/seccomp: Fix seccomp failure by adding missing headers

Sidong Yang (1):
      btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Slawomir Laba (8):
      iavf: Fix missing check for running netdev
      iavf: Fix deadlock in iavf_reset_task
      iavf: Rework mutexes for better synchronisation
      iavf: Add waiting so the port is initialized in remove
      iavf: Fix init state closure on remove
      iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
      iavf: Fix race in init state
      iavf: Fix __IAVF_RESETTING state usage

Steven Rostedt (2):
      tracing: Add test for user space strings when filtering on string pointers
      tracing: Add ustring operation to filtering string pointers

Steven Rostedt (Google) (1):
      tracing/histogram: Fix sorting on old "cpu" value

Sukadev Bhattiprolu (8):
      ibmvnic: register netdev after init of adapter
      ibmvnic: free reset-work-item when flushing
      ibmvnic: initialize rc before completing wait
      ibmvnic: define flush_reset_queue helper
      ibmvnic: complete init_done on transport events
      ibmvnic: init init_done_rc earlier
      ibmvnic: clear fop when retrying probe
      ibmvnic: Allow queueing resets during probe

Sunil V L (1):
      riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value

Suravee Suthikulpanit (1):
      iommu/amd: Fix I/O page table memory leak

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Svenning Sørensen (1):
      net: dsa: microchip: fix bridging with more than two member ports

Tadeusz Struk (1):
      sched/fair: Fix fault in reweight_entity

Thierry Reding (1):
      ARM: tegra: Move panels to AUX bus

Valentin Caron (1):
      serial: stm32: prevent TDR register overwrite when sending x_char

Ville Syrjälä (1):
      drm/i915: s/JSP2/ICP2/ PCH

Vinay Belgaumkar (1):
      drm/i915/guc/slpc: Correct the param count for unset param

Vincent Mailhol (2):
      can: gs_usb: change active_channels's type from atomic_t to u8
      can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8

Vincent Whitchurch (1):
      net: stmmac: only enable DMA interrupts when ready

Vladimir Oltean (2):
      net: dcb: flush lingering app table entries for unregistered devices
      net: dcb: disable softirqs in dcbnl_flush_dev()

William Mahon (2):
      HID: add mapping for KEY_DICTATE
      HID: add mapping for KEY_ALL_APPLICATIONS

Wolfram Sang (3):
      i2c: cadence: allow COMPILE_TEST
      i2c: imx: allow COMPILE_TEST
      i2c: qup: allow COMPILE_TEST

Xin Yin (2):
      ext4: fast commit may not fallback for ineligible commit
      ext4: fast commit may miss file actions

Yongzhi Liu (1):
      dmaengine: shdma: Fix runtime PM imbalance on error

Yu Kuai (1):
      blktrace: fix use after free for struct blk_trace

Yun Zhou (1):
      proc: fix documentation and description of pagemap

Zhen Ni (1):
      ALSA: intel_hdmi: Fix reference to PCM buffer address

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

lena wang (1):
      net: fix up skbs delta_truesize in UDP GRO frag_list

