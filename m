Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1E4D2010
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349568AbiCHSXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349613AbiCHSXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:23:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D3D56C32;
        Tue,  8 Mar 2022 10:22:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5567F615AA;
        Tue,  8 Mar 2022 18:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D369C340EB;
        Tue,  8 Mar 2022 18:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763725;
        bh=znIly9z7kDlvffgbfDJuG4dSqf72ooFgiUt2M/ekwc4=;
        h=From:To:Cc:Subject:Date:From;
        b=sCEyhqO672ks1ujd6Rp+nwjSyQnN6qMDg7mo4I2fngLTHwRgSRnCO6wwzqXwOD1dY
         NtrP18obDDuA2TDl6P+te1mHSyrqHYOVBBuROhGZQh/3jM/s7UVjHByO2AxD7ay+UK
         9yhE58FuTtAm620L3GiDR4oGyLjjuJLsqI5TtLMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.183
Date:   Tue,  8 Mar 2022 19:21:50 +0100
Message-Id: <164676371112015@kroah.com>
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

I'm announcing the release of the 5.4.183 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/kernel/kgdb.c                            |   36 ++++++--
 arch/arm/mm/mmu.c                                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi      |   17 ++-
 arch/ia64/kernel/acpi.c                           |    7 +
 block/blk-flush.c                                 |    4 
 drivers/ata/pata_hpt37x.c                         |    4 
 drivers/dma/sh/shdma-base.c                       |    4 
 drivers/firmware/arm_scmi/driver.c                |    2 
 drivers/firmware/efi/vars.c                       |    5 -
 drivers/hid/hid-debug.c                           |    5 -
 drivers/hid/hid-input.c                           |    3 
 drivers/i2c/busses/Kconfig                        |    4 
 drivers/i2c/busses/i2c-bcm2835.c                  |   11 ++
 drivers/input/input.c                             |    6 +
 drivers/input/mouse/elan_i2c_core.c               |   64 +++++---------
 drivers/net/arcnet/com20020-pci.c                 |    3 
 drivers/net/can/usb/gs_usb.c                      |   10 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c        |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                |    4 
 drivers/net/ethernet/intel/iavf/iavf_main.c       |    7 +
 drivers/net/ethernet/intel/igc/igc_phy.c          |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c      |    6 -
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c   |    6 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 -
 drivers/net/hamradio/mkiss.c                      |    2 
 drivers/net/usb/cdc_mbim.c                        |    5 +
 drivers/net/wireless/mac80211_hwsim.c             |   13 ++
 drivers/net/xen-netfront.c                        |   39 +++++---
 drivers/soc/fsl/qe/qe_io.c                        |    2 
 drivers/usb/gadget/legacy/inode.c                 |   10 +-
 fs/btrfs/qgroup.c                                 |    9 +-
 fs/btrfs/tree-log.c                               |   61 ++++++++++---
 fs/cifs/cifsfs.c                                  |    1 
 include/linux/topology.h                          |    1 
 include/net/netfilter/nf_queue.h                  |    2 
 include/net/xfrm.h                                |    1 
 include/uapi/linux/input-event-codes.h            |    4 
 include/uapi/linux/xfrm.h                         |    6 +
 kernel/sched/topology.c                           |   99 ++++++++++------------
 kernel/trace/trace.c                              |    4 
 kernel/trace/trace_events_hist.c                  |    6 -
 kernel/trace/trace_kprobe.c                       |    2 
 mm/memfd.c                                        |   40 ++++++--
 net/batman-adv/hard-interface.c                   |   29 ++++--
 net/dcb/dcbnl.c                                   |   44 +++++++++
 net/ipv4/esp4.c                                   |    2 
 net/ipv6/esp6.c                                   |    2 
 net/ipv6/ip6_output.c                             |   11 +-
 net/mac80211/rx.c                                 |    4 
 net/netfilter/core.c                              |    5 -
 net/netfilter/nf_queue.c                          |   24 ++++-
 net/netfilter/nfnetlink_queue.c                   |   12 ++
 net/smc/smc_core.c                                |    5 -
 net/wireless/nl80211.c                            |   12 ++
 net/xfrm/xfrm_device.c                            |    6 +
 net/xfrm/xfrm_interface.c                         |    2 
 net/xfrm/xfrm_state.c                             |   14 ---
 sound/soc/codecs/cs4265.c                         |    3 
 sound/soc/codecs/rt5668.c                         |   12 +-
 sound/soc/codecs/rt5682.c                         |   12 +-
 sound/soc/soc-ops.c                               |    4 
 sound/x86/intel_hdmi_audio.c                      |    2 
 63 files changed, 488 insertions(+), 248 deletions(-)

Alyssa Ross (1):
      firmware: arm_scmi: Remove space in MODULE_ALIAS name

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Brian Norris (1):
      arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Corinna Vinschen (1):
      igc: igc_read_phy_reg_gpy: drop premature return

D. Wythe (2):
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Dietmar Eggemann (1):
      sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (1):
      netfilter: fix use-after-free in __nf_register_net_hook()

Fabio Estevam (1):
      ASoC: cs4265: Fix the duplicated control name

Filipe Manana (2):
      btrfs: fix lost prealloc extents beyond eof after full fsync
      btrfs: add missing run of delayed items after unlink during log replay

Florian Westphal (2):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free

Greg Kroah-Hartman (1):
      Linux 5.4.183

Hangyu Hua (2):
      usb: gadget: don't release an existing dev->buf
      usb: gadget: clear related members when goto fail

Hans de Goede (2):
      Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
      Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Huang Pei (1):
      hamradio: fix macro redefine warning

Hugh Dickins (1):
      memfd: fix F_SEAL_WRITE after shmem huge page allocated

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

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

Kai Vehmanen (2):
      ASoC: rt5668: do not block workqueue if card is unbound
      ASoC: rt5682: do not block workqueue if card is unbound

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Maciej Fijalkowski (1):
      ixgbe: xsk: change !netif_carrier_ok() handling in ixgbe_xmit_zc()

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Marek Vasut (1):
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Randy Dunlap (4):
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions
      tracing: Fix return value of __setup handlers

Ronnie Sahlberg (1):
      cifs: fix double free race when mount fails in cifs_get_root()

Russell King (Oracle) (1):
      ARM: Fix kgdb breakpoint for Thumb2

Sasha Neftin (1):
      igc: igc_write_phy_reg_gpy: drop premature return

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

Sidong Yang (1):
      btrfs: qgroup: fix deadlock between rescan worker and remove qgroup

Slawomir Laba (1):
      iavf: Fix missing check for running netdev

Steven Rostedt (Google) (1):
      tracing/histogram: Fix sorting on old "cpu" value

Sukadev Bhattiprolu (1):
      ibmvnic: free reset-work-item when flushing

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Valentin Schneider (2):
      sched/topology: Make sched_init_numa() use a set for the deduplicating sort
      ia64: ensure proper NUMA distance and possible map initialization

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

Ye Bin (1):
      block: Fix fsync always failed if once failed

Yongzhi Liu (1):
      dmaengine: shdma: Fix runtime PM imbalance on error

Zhen Ni (1):
      ALSA: intel_hdmi: Fix reference to PCM buffer address

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

