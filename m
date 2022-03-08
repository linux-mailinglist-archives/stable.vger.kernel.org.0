Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88554D2012
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiCHSXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349587AbiCHSW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:22:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC2856C2D;
        Tue,  8 Mar 2022 10:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CF8BB818A2;
        Tue,  8 Mar 2022 18:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE62FC340EB;
        Tue,  8 Mar 2022 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763719;
        bh=cY+p25hwKhVgKQJaQWAkyoyKcKuZf5FawmeOCWdfVYs=;
        h=From:To:Cc:Subject:Date:From;
        b=sssYd6vtJDLCdCVIdlk5PG8k/uTCp0sZxZpov56YY3d/jfxWmIxIioRKsqvxJjYEm
         UttiwcjmTQ/9AcmHXmFCbd0nPncJ42IPGyrmc30SSufKapn1OahxPurTcjo5PPYjch
         NrsBWLIOJhVHliTwHPmNdFQ8tOClbiKrYYLddhwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.233
Date:   Tue,  8 Mar 2022 19:21:45 +0100
Message-Id: <1646763706185243@kroah.com>
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

I'm announcing the release of the 4.19.233 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/mm/mmu.c                                 |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi      |   17 ++++-
 block/blk-flush.c                                 |    4 +
 drivers/ata/pata_hpt37x.c                         |    4 -
 drivers/dma/sh/shdma-base.c                       |    4 +
 drivers/firmware/arm_scmi/driver.c                |    2 
 drivers/firmware/efi/vars.c                       |    5 +
 drivers/hid/hid-debug.c                           |    4 +
 drivers/hid/hid-input.c                           |    2 
 drivers/i2c/busses/Kconfig                        |    4 -
 drivers/i2c/busses/i2c-bcm2835.c                  |   11 +++
 drivers/input/input.c                             |    6 ++
 drivers/input/mouse/elan_i2c_core.c               |   64 +++++++---------------
 drivers/net/arcnet/com20020-pci.c                 |    3 +
 drivers/net/can/usb/gs_usb.c                      |   10 +--
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c        |    2 
 drivers/net/ethernet/ibm/ibmvnic.c                |    4 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c   |    6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +-
 drivers/net/hamradio/mkiss.c                      |    2 
 drivers/net/usb/cdc_mbim.c                        |    5 +
 drivers/net/wireless/mac80211_hwsim.c             |   13 ++++
 drivers/net/xen-netfront.c                        |   39 +++++++------
 drivers/pci/hotplug/pciehp_hpc.c                  |    7 +-
 drivers/soc/fsl/qe/qe_io.c                        |    2 
 drivers/usb/gadget/legacy/inode.c                 |   10 ++-
 fs/btrfs/tree-log.c                               |   18 ++++++
 fs/cifs/cifsfs.c                                  |    1 
 include/net/netfilter/nf_queue.h                  |    2 
 include/uapi/linux/input-event-codes.h            |    3 -
 include/uapi/linux/xfrm.h                         |    6 ++
 kernel/trace/trace_events_hist.c                  |    6 +-
 mm/memfd.c                                        |   30 +++++++---
 net/batman-adv/hard-interface.c                   |   29 ++++++---
 net/dcb/dcbnl.c                                   |   44 +++++++++++++++
 net/ipv6/ip6_output.c                             |   11 ++-
 net/mac80211/rx.c                                 |    4 -
 net/netfilter/core.c                              |    5 +
 net/netfilter/nf_queue.c                          |   22 ++++++-
 net/netfilter/nfnetlink_queue.c                   |   12 +++-
 net/smc/smc_core.c                                |    5 +
 net/wireless/nl80211.c                            |   12 ++++
 net/xfrm/xfrm_device.c                            |    6 +-
 net/xfrm/xfrm_interface.c                         |    2 
 sound/soc/codecs/rt5668.c                         |   12 ++--
 sound/soc/codecs/rt5682.c                         |   12 ++--
 sound/soc/soc-ops.c                               |    4 -
 sound/x86/intel_hdmi_audio.c                      |    2 
 49 files changed, 345 insertions(+), 143 deletions(-)

Alyssa Ross (1):
      firmware: arm_scmi: Remove space in MODULE_ALIAS name

Antony Antony (1):
      xfrm: fix the if_id check in changelink

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

Brian Norris (1):
      arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

D. Wythe (2):
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (1):
      netfilter: fix use-after-free in __nf_register_net_hook()

Filipe Manana (1):
      btrfs: add missing run of delayed items after unlink during log replay

Florian Westphal (2):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free

Greg Kroah-Hartman (1):
      Linux 4.19.233

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

Jiri Bohac (1):
      xfrm: fix MTU regression

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

Kai Vehmanen (2):
      ASoC: rt5668: do not block workqueue if card is unbound
      ASoC: rt5682: do not block workqueue if card is unbound

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Lukas Wunner (1):
      PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Marek Marczykowski-Górecki (1):
      xen/netfront: destroy queues before real_num_tx_queues is zeroed

Marek Vasut (1):
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Randy Dunlap (3):
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Ronnie Sahlberg (1):
      cifs: fix double free race when mount fails in cifs_get_root()

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

Steven Rostedt (Google) (1):
      tracing/histogram: Fix sorting on old "cpu" value

Sukadev Bhattiprolu (1):
      ibmvnic: free reset-work-item when flushing

Sven Eckelmann (3):
      batman-adv: Request iflink once in batadv-on-batadv check
      batman-adv: Request iflink once in batadv_get_real_netdevice
      batman-adv: Don't expect inter-netns unique iflink indices

Vincent Mailhol (1):
      can: gs_usb: change active_channels's type from atomic_t to u8

Vladimir Oltean (2):
      net: dcb: flush lingering app table entries for unregistered devices
      net: dcb: disable softirqs in dcbnl_flush_dev()

William Mahon (1):
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

