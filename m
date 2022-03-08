Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D1A4D200D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbiCHSXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349534AbiCHSWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:22:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AA856C24;
        Tue,  8 Mar 2022 10:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44F89B81C22;
        Tue,  8 Mar 2022 18:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91682C340EB;
        Tue,  8 Mar 2022 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646763707;
        bh=U3zgfE9wefbrl6oGsubYZy3YjHQQIY2RwdC0Dx0/5No=;
        h=From:To:Cc:Subject:Date:From;
        b=wqNHQoRbUCK2yVVv8d8/aMJQycKifdu/KgZWA2tfzGFRdFUeZaLwGPePp08U5RaTy
         09rO14C8H8HZ9z4Ql7flusI5KHaNwpUAX873Rddy6HQAmZLw/2piHuDt4EMeYMb+sT
         90sgVtbxM/cZ1GHfBf1LheR6FrKVTZOKfOsddnxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.270
Date:   Tue,  8 Mar 2022 19:21:41 +0100
Message-Id: <1646763701154242@kroah.com>
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

I'm announcing the release of the 4.14.270 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/arm/mm/mmu.c                                 |    2 
 drivers/ata/pata_hpt37x.c                         |    4 -
 drivers/dma/sh/shdma-base.c                       |    4 +
 drivers/firmware/efi/vars.c                       |    5 +
 drivers/firmware/qemu_fw_cfg.c                    |   10 +--
 drivers/hid/hid-debug.c                           |    4 +
 drivers/hid/hid-input.c                           |    2 
 drivers/i2c/busses/Kconfig                        |    4 -
 drivers/i2c/busses/i2c-bcm2835.c                  |   11 +++
 drivers/input/input.c                             |    6 ++
 drivers/input/mouse/elan_i2c_core.c               |   64 +++++++---------------
 drivers/net/arcnet/com20020-pci.c                 |    3 +
 drivers/net/can/usb/gs_usb.c                      |   10 +--
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c        |    2 
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c   |    6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +-
 drivers/net/hamradio/mkiss.c                      |    2 
 drivers/net/usb/cdc_mbim.c                        |    5 +
 drivers/net/wireless/mac80211_hwsim.c             |   13 ++++
 drivers/soc/fsl/qe/qe_io.c                        |    2 
 drivers/usb/gadget/legacy/inode.c                 |   10 ++-
 fs/cifs/cifsfs.c                                  |    1 
 include/net/netfilter/nf_queue.h                  |    2 
 include/uapi/linux/input-event-codes.h            |    3 -
 include/uapi/linux/xfrm.h                         |    6 ++
 mm/shmem.c                                        |    7 +-
 net/batman-adv/hard-interface.c                   |   29 ++++++---
 net/dcb/dcbnl.c                                   |   44 +++++++++++++++
 net/ipv6/ip6_output.c                             |   11 ++-
 net/mac80211/rx.c                                 |    4 -
 net/netfilter/core.c                              |    5 +
 net/netfilter/nf_queue.c                          |   23 ++++++-
 net/netfilter/nfnetlink_queue.c                   |   12 +++-
 net/smc/smc_core.c                                |    5 +
 net/wireless/nl80211.c                            |   12 ++++
 net/xfrm/xfrm_device.c                            |    6 +-
 sound/soc/soc-ops.c                               |    4 -
 sound/x86/intel_hdmi_audio.c                      |    2 
 39 files changed, 251 insertions(+), 102 deletions(-)

Benjamin Beichler (1):
      mac80211_hwsim: report NOACK frames in tx_status

D. Wythe (2):
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client
      net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Eric Anholt (1):
      i2c: bcm2835: Avoid clock stretching timeouts

Eric Dumazet (1):
      netfilter: fix use-after-free in __nf_register_net_hook()

Florian Westphal (2):
      netfilter: nf_queue: don't assume sk is full socket
      netfilter: nf_queue: fix possible use-after-free

Greg Kroah-Hartman (1):
      Linux 4.14.270

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

Johan Hovold (1):
      firmware: qemu_fw_cfg: fix kobject leak in probe error path

José Expósito (1):
      Input: clear BTN_RIGHT/MIDDLE on buttonpads

Leon Romanovsky (1):
      xfrm: enforce validity of offload input flags

Marek Vasut (1):
      ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Qiushi Wu (1):
      firmware: Fix a reference count leak.

Randy Dunlap (3):
      net: stmmac: fix return value of __setup handler
      net: sxgbe: fix return value of __setup handler
      ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Ronnie Sahlberg (1):
      cifs: fix double free race when mount fails in cifs_get_root()

Sergey Shtylyov (1):
      ata: pata_hpt37x: fix PCI clock detection

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

Yongzhi Liu (1):
      dmaengine: shdma: Fix runtime PM imbalance on error

Zhen Ni (1):
      ALSA: intel_hdmi: Fix reference to PCM buffer address

Zheyu Ma (1):
      net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

