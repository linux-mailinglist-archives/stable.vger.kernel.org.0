Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6119C4D2017
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349534AbiCHSXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349667AbiCHSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2727156C24;
        Tue,  8 Mar 2022 10:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9524615A3;
        Tue,  8 Mar 2022 18:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29E0C340EB;
        Tue,  8 Mar 2022 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763734;
        bh=u2NGdzhjchxRthvJ0IrFleEwZDOJS/hU2YMiRJWceis=;
        h=From:To:Cc:Subject:Date:From;
        b=bQt3mnzB5lLfI2SW/p9Uo0QgCHg0PUfs/AHujPE5RsAwz71y12BTHUPbvjdX5F2ST
         CVSMADrBSOXKgQFF+EaGM5wt98Ym/0G32U6AmJlH2oRVNj4xHOBnT3XJfHYcDUgTry
         9opDPJQF3KiUVKspafEe/S3QnxBxNgc9Pz5K2p7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.104
Date:   Tue,  8 Mar 2022 19:22:03 +0100
Message-Id: <16467637231798@kroah.com>
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

I'm announcing the release of the 5.10.104 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/trace/events.rst                               |   19 +
 Makefile                                                     |    2 
 arch/arm/boot/dts/omap3-devkit8000-common.dtsi               |   18 +
 arch/arm/boot/dts/omap3-devkit8000.dts                       |   33 ---
 arch/arm/boot/dts/tegra124-nyan-big.dts                      |   15 -
 arch/arm/boot/dts/tegra124-nyan-blaze.dts                    |   15 -
 arch/arm/boot/dts/tegra124-venice2.dts                       |   14 -
 arch/arm/kernel/kgdb.c                                       |   36 ++-
 arch/arm/mm/mmu.c                                            |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi                 |   17 +
 arch/arm64/kvm/vgic/vgic-mmio.c                              |    2 
 arch/ia64/kernel/acpi.c                                      |    7 
 arch/riscv/mm/Makefile                                       |    3 
 arch/riscv/mm/kasan_init.c                                   |    3 
 arch/s390/include/asm/extable.h                              |    9 
 drivers/ata/pata_hpt37x.c                                    |    4 
 drivers/clocksource/timer-ti-dm-systimer.c                   |    3 
 drivers/dma/sh/shdma-base.c                                  |    4 
 drivers/firmware/arm_scmi/driver.c                           |    2 
 drivers/firmware/efi/libstub/riscv-stub.c                    |   17 +
 drivers/firmware/efi/vars.c                                  |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                       |   10 -
 drivers/gpu/drm/i915/intel_pch.c                             |    2 
 drivers/gpu/drm/i915/intel_pch.h                             |    2 
 drivers/hid/hid-debug.c                                      |    5 
 drivers/hid/hid-input.c                                      |    3 
 drivers/i2c/busses/Kconfig                                   |    4 
 drivers/i2c/busses/i2c-bcm2835.c                             |   11 +
 drivers/input/input.c                                        |    6 
 drivers/input/keyboard/Kconfig                               |    2 
 drivers/input/mouse/elan_i2c_core.c                          |   64 ++----
 drivers/iommu/amd/amd_iommu.h                                |    1 
 drivers/iommu/amd/amd_iommu_types.h                          |    1 
 drivers/iommu/amd/init.c                                     |   10 +
 drivers/iommu/amd/iommu.c                                    |   10 -
 drivers/net/arcnet/com20020-pci.c                            |    3 
 drivers/net/can/usb/gs_usb.c                                 |   10 -
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                   |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                           |   21 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |    4 
 drivers/net/ethernet/intel/iavf/iavf.h                       |   10 +
 drivers/net/ethernet/intel/iavf/iavf_main.c                  |   44 ++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c              |    2 
 drivers/net/ethernet/intel/ice/ice_main.c                    |    2 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c             |   58 +++++
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h             |    5 
 drivers/net/ethernet/intel/igc/igc_phy.c                     |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c                 |    6 
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c              |    6 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            |    6 
 drivers/net/hamradio/mkiss.c                                 |    2 
 drivers/net/usb/cdc_mbim.c                                   |    5 
 drivers/net/wireless/mac80211_hwsim.c                        |   13 +
 drivers/net/xen-netfront.c                                   |   39 ++--
 drivers/ntb/hw/intel/ntb_hw_gen4.c                           |   17 +
 drivers/ntb/hw/intel/ntb_hw_gen4.h                           |   16 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                        |    9 
 drivers/regulator/core.c                                     |   13 -
 drivers/soc/fsl/guts.c                                       |   14 -
 drivers/soc/fsl/qe/qe_io.c                                   |    2 
 drivers/thermal/thermal_netlink.c                            |    5 
 drivers/tty/serial/stm32-usart.c                             |   12 +
 drivers/usb/gadget/legacy/inode.c                            |   10 -
 fs/btrfs/qgroup.c                                            |    9 
 fs/btrfs/tree-log.c                                          |   61 +++++-
 fs/cifs/cifsfs.c                                             |    1 
 fs/exfat/file.c                                              |   18 -
 fs/exfat/inode.c                                             |   13 -
 fs/exfat/namei.c                                             |    6 
 fs/exfat/super.c                                             |   10 -
 include/linux/topology.h                                     |    1 
 include/net/netfilter/nf_queue.h                             |    2 
 include/net/xfrm.h                                           |    1 
 include/uapi/linux/input-event-codes.h                       |    4 
 include/uapi/linux/xfrm.h                                    |    6 
 kernel/rcu/tree_plugin.h                                     |    7 
 kernel/sched/topology.c                                      |   99 ++++------
 kernel/trace/trace.c                                         |    4 
 kernel/trace/trace_events_filter.c                           |  107 ++++++++++-
 kernel/trace/trace_events_hist.c                             |    6 
 kernel/trace/trace_kprobe.c                                  |    2 
 mm/memfd.c                                                   |   40 ++--
 mm/util.c                                                    |    4 
 net/batman-adv/hard-interface.c                              |   29 ++
 net/core/skbuff.c                                            |    2 
 net/core/skmsg.c                                             |    2 
 net/dcb/dcbnl.c                                              |   44 ++++
 net/ipv4/esp4.c                                              |    2 
 net/ipv6/addrconf.c                                          |    8 
 net/ipv6/esp6.c                                              |    2 
 net/ipv6/ip6_output.c                                        |   11 -
 net/mac80211/ieee80211_i.h                                   |    2 
 net/mac80211/mlme.c                                          |   16 +
 net/mac80211/rx.c                                            |    4 
 net/netfilter/core.c                                         |    5 
 net/netfilter/nf_queue.c                                     |   36 +++
 net/netfilter/nfnetlink_queue.c                              |   12 -
 net/smc/af_smc.c                                             |   10 -
 net/smc/smc_core.c                                           |    5 
 net/tipc/crypto.c                                            |    2 
 net/wireless/nl80211.c                                       |   12 +
 net/xfrm/xfrm_device.c                                       |    6 
 net/xfrm/xfrm_interface.c                                    |    2 
 net/xfrm/xfrm_state.c                                        |   14 -
 sound/soc/codecs/cs4265.c                                    |    3 
 sound/soc/codecs/rt5668.c                                    |   12 -
 sound/soc/codecs/rt5682.c                                    |   12 -
 sound/soc/soc-ops.c                                          |    4 
 sound/x86/intel_hdmi_audio.c                                 |    2 
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh |    3 
 tools/testing/selftests/seccomp/Makefile                     |    2 
 111 files changed, 948 insertions(+), 418 deletions(-)

Alexandre Ghiti (2):
      riscv: Fix config KASAN && SPARSEMEM && !SPARSE_VMEMMAP
      riscv: Fix config KASAN && DEBUG_VIRTUAL

Alyssa Ross (1):
      firmware: arm_scmi: Remove space in MODULE_ALIAS name

Amit Cohen (1):
      selftests: mlxsw: tc_police_scale: Make test more robust

Anthoine Bourgeois (2):
      ARM: dts: switch timer config to common devkit8000 devicetree
      ARM: dts: Use 32KiHz oscillator on devkit8000

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Brett Creeley (1):
      ice: Fix race conditions between virtchnl handling and VF ndo ops

Brian Norris (1):
      arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Christophe JAILLET (2):
      soc: fsl: guts: Revert commit 3c0d64e867ed
      soc: fsl: guts: Add a missing memory allocation failure check

Christophe Vu-Brugier (2):
      exfat: reuse exfat_inode_info variable instead of calling EXFAT_I()
      exfat: fix i_blocks for files truncated over 4 GiB

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

Dave Jiang (1):
      ntb: intel: fix port config status offset for SPR

David Gow (1):
      Input: samsung-keypad - properly state IOMEM dependency

Dietmar Eggemann (1):
      sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (2):
      netfilter: fix use-after-free in __nf_register_net_hook()
      bpf, sockmap: Do not ignore orig_len parameter

Fabio Estevam (1):
      ASoC: cs4265: Fix the duplicated control name

Filipe Manana (2):
      btrfs: fix lost prealloc extents beyond eof after full fsync
      btrfs: add missing run of delayed items after unlink during log replay

Florian Westphal (3):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free
      netfilter: nf_queue: handle socket prefetch

Frederic Weisbecker (1):
      rcu/nocb: Fix missed nocb_timer requeue

Greg Kroah-Hartman (1):
      Linux 5.10.104

Hangyu Hua (3):
      tipc: fix a bit overflow in tipc_crypto_key_rcv()
      usb: gadget: don't release an existing dev->buf
      usb: gadget: clear related members when goto fail

Hans de Goede (2):
      Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
      Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Heiko Carstens (1):
      s390/extable: fix exception table sorting

Huang Pei (1):
      hamradio: fix macro redefine warning

Hugh Dickins (1):
      memfd: fix F_SEAL_WRITE after shmem huge page allocated

Jacob Keller (1):
      ice: fix concurrent reset and removal of VFs

JaeMan Park (1):
      mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Jann Horn (1):
      efivars: Respect "block" flag in efivar_entry_set_safe()

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

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

Kai Vehmanen (2):
      ASoC: rt5668: do not block workqueue if card is unbound
      ASoC: rt5682: do not block workqueue if card is unbound

Lennert Buytenhek (1):
      iommu/amd: Recover from event log overflow

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Maciej Fijalkowski (1):
      ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Marc Zyngier (1):
      KVM: arm64: vgic: Read HW interrupt pending state from the HW

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Marek Vasut (1):
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Mateusz Palczewski (1):
      iavf: Refactor iavf state machine tracking

Nicolas Cavallari (1):
      thermal: core: Fix TZ_GET_TRIP NULL pointer dereference

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Oliver Barta (1):
      regulator: core: fix false positive in regulator_late_cleanup()

Qiang Yu (2):
      drm/amdgpu: check vm ready by amdgpu_vm->evicting flag
      drm/amdgpu: fix suspend/resume hang regression

Randy Dunlap (4):
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions
      tracing: Fix return value of __setup handlers

Ronnie Sahlberg (1):
      cifs: fix double free race when mount fails in cifs_get_root()

Russell King (Oracle) (1):
      ARM: Fix kgdb breakpoint for Thumb2

Samuel Holland (1):
      pinctrl: sunxi: Use unique lockdep classes for IRQs

Sasha Neftin (2):
      e1000e: Correct NVM checksum verification flow
      igc: igc_write_phy_reg_gpy: drop premature return

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

Sherry Yang (1):
      selftests/seccomp: Fix seccomp failure by adding missing headers

Sidong Yang (1):
      btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Slawomir Laba (1):
      iavf: Fix missing check for running netdev

Steven Rostedt (2):
      tracing: Add test for user space strings when filtering on string pointers
      tracing: Add ustring operation to filtering string pointers

Steven Rostedt (Google) (1):
      tracing/histogram: Fix sorting on old "cpu" value

Sukadev Bhattiprolu (3):
      ibmvnic: register netdev after init of adapter
      ibmvnic: free reset-work-item when flushing
      ibmvnic: complete init_done on transport events

Sunil V L (1):
      riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Thierry Reding (1):
      ARM: tegra: Move panels to AUX bus

Valentin Caron (1):
      serial: stm32: prevent TDR register overwrite when sending x_char

Valentin Schneider (2):
      sched/topology: Make sched_init_numa() use a set for the deduplicating sort
      ia64: ensure proper NUMA distance and possible map initialization

Ville Syrjälä (1):
      drm/i915: s/JSP2/ICP2/ PCH

Vincent Mailhol (1):
      can: gs_usb: change active_channels's type from atomic_t to u8

Vladimir Oltean (2):
      net: dcb: flush lingering app table entries for unregistered devices
      net: dcb: disable softirqs in dcbnl_flush_dev()

William Mahon (2):
      HID: add mapping for KEY_DICTATE
      HID: add mapping for KEY_ALL_APPLICATIONS

Wolfram Sang (2):
      i2c: cadence: allow COMPILE_TEST
      i2c: qup: allow COMPILE_TEST

Yongzhi Liu (1):
      dmaengine: shdma: Fix runtime PM imbalance on error

Zhen Ni (1):
      ALSA: intel_hdmi: Fix reference to PCM buffer address

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

j.nixdorf@avm.de (1):
      net: ipv6: ensure we call ipv6_mc_down() at most once

lena wang (1):
      net: fix up skbs delta_truesize in UDP GRO frag_list

