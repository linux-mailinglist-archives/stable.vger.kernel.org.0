Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01B064CD46
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbiLNPr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbiLNPrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:47:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC1523382;
        Wed, 14 Dec 2022 07:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF80C61AFE;
        Wed, 14 Dec 2022 15:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9064C433D2;
        Wed, 14 Dec 2022 15:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032836;
        bh=UdC8VloJ+LgoTTAIe+lGqxX0QXe6uh3WfwJFDvrA3R4=;
        h=From:To:Cc:Subject:Date:From;
        b=fOnniQIhL+67vD616QPZHgJeTWGMvETMzH5clG/JubG0rhJ1d/AY7Zy1Kq4CMRFV/
         Xc2mkSZsKAxFivIeFBRIzez6mV2rrBeKsTrtMuV6yfMZW8G3slq/YCUx/fmmVXW7rF
         xJ+W7bejDOCdM5L5U3Y1a9y9kjGeegSRB2I2G/XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.269
Date:   Wed, 14 Dec 2022 16:46:57 +0100
Message-Id: <167103281872144@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.269 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/boot/dts/rk3036-evb.dts                      |    2 
 arch/arm/boot/dts/rk3188-radxarock.dts                |    2 
 arch/arm/boot/dts/rk3188.dtsi                         |    1 
 arch/arm/boot/dts/rk3288-evb-act8846.dts              |    2 
 arch/arm/boot/dts/rk3288-firefly.dtsi                 |    2 
 arch/arm/boot/dts/rk3288-miqi.dts                     |    2 
 arch/arm/boot/dts/rk3288-rock2-square.dts             |    2 
 arch/arm/boot/dts/rk3xxx.dtsi                         |    7 
 arch/arm/include/asm/perf_event.h                     |    2 
 arch/arm/include/asm/pgtable-nommu.h                  |    6 
 arch/arm/include/asm/pgtable.h                        |   16 -
 arch/arm/mm/nommu.c                                   |   19 +
 arch/s390/kvm/vsie.c                                  |    4 
 drivers/gpio/gpio-amd8111.c                           |    4 
 drivers/hid/hid-core.c                                |    3 
 drivers/hid/hid-lg4ff.c                               |    6 
 drivers/media/v4l2-core/v4l2-dv-timings.c             |   20 +
 drivers/net/can/usb/esd_usb2.c                        |    6 
 drivers/net/ethernet/aeroflex/greth.c                 |    1 
 drivers/net/ethernet/hisilicon/hisi_femac.c           |    2 
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c         |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c            |    4 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c        |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   19 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c    |    2 
 drivers/net/ethernet/intel/igb/igb_ethtool.c          |    2 
 drivers/net/ethernet/marvell/mvneta.c                 |    2 
 drivers/net/ethernet/microchip/encx24j600-regmap.c    |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    8 
 drivers/net/ieee802154/ca8210.c                       |    2 
 drivers/net/ieee802154/cc2520.c                       |    2 
 drivers/net/plip/plip.c                               |    4 
 drivers/net/usb/qmi_wwan.c                            |    1 
 drivers/net/xen-netback/common.h                      |   14 -
 drivers/net/xen-netback/interface.c                   |   22 -
 drivers/net/xen-netback/netback.c                     |  229 +++++++++---------
 drivers/net/xen-netback/rx.c                          |   10 
 drivers/net/xen-netfront.c                            |    6 
 drivers/nvme/host/core.c                              |    8 
 drivers/regulator/twl6030-regulator.c                 |   15 -
 drivers/video/fbdev/core/fbcon.c                      |    2 
 include/linux/cgroup.h                                |    1 
 kernel/cgroup/cgroup-internal.h                       |    1 
 mm/memcontrol.c                                       |   15 +
 net/9p/trans_fd.c                                     |    6 
 net/9p/trans_xen.c                                    |    9 
 net/bluetooth/6lowpan.c                               |    1 
 net/bluetooth/af_bluetooth.c                          |    4 
 net/ipv6/ip6_output.c                                 |    5 
 net/mac802154/iface.c                                 |    1 
 net/nfc/nci/ntf.c                                     |    6 
 net/tipc/link.c                                       |    4 
 sound/core/seq/seq_memory.c                           |   11 
 sound/soc/soc-pcm.c                                   |    2 
 tools/testing/selftests/net/rtnetlink.sh              |    2 
 tools/testing/selftests/rcutorture/bin/kvm.sh         |    8 
 tools/testing/selftests/rcutorture/bin/mkinitrd.sh    |   60 ++++
 58 files changed, 403 insertions(+), 208 deletions(-)

Akihiko Odaki (2):
      e1000e: Fix TX dispatch condition
      igb: Allocate MSI-X vector when testing

Anastasia Belova (1):
      HID: hid-lg4ff: Add check for empty lbuf

Andreas Kemnade (1):
      regulator: twl6030: fix get status of twl6032 regulators

Chen Zhongjin (1):
      Bluetooth: Fix not cleanup led when bt_init fails

Connor Shu (1):
      rcutorture: Automatically create initrd directory

Dan Carpenter (2):
      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
      net: mvneta: Fix an out of bounds check

Davide Tronchin (1):
      net: usb: qmi_wwan: add u-blox 0x1342 composition

Dominique Martinet (1):
      9p/xen: check logical size for buffer size

Eric Dumazet (1):
      ipv6: avoid use-after-free in ip6_fragment()

Frank Jungclaus (1):
      can: esd_usb: Allow REC and TEC to return to zero

GUO Zihua (1):
      9p/fd: Use P9_HDRSZ for header size

Giulio Benetti (1):
      ARM: 9266/1: mm: fix no-MMU ZERO_PAGE() implementation

Greg Kroah-Hartman (1):
      Linux 4.19.269

Hans Verkuil (1):
      media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Hauke Mehrtens (1):
      ca8210: Fix crash by zero initializing data

Jisheng Zhang (1):
      net: stmmac: fix "snps,axi-config" node property parsing

Johan Jonker (2):
      ARM: dts: rockchip: fix ir-receiver node names
      ARM: dts: rockchip: disable arm_global_timer on rk3066 and rk3188

Juergen Gross (3):
      xen/netback: do some code cleanup
      xen/netback: don't call kfree_skb() with interrupts disabled
      xen/netback: fix build warning

Kees Cook (2):
      ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
      NFC: nci: Bounds check struct nfc_target arrays

Lin Liu (1):
      xen-netfront: Fix NULL sring after live migration

Liu Jian (2):
      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Michal Jaron (1):
      i40e: Fix not setting default xps_cpus after reset

Pankaj Raghav (1):
      nvme initialize core quirks before calling nvme_init_subsystem

Przemyslaw Patynowski (1):
      i40e: Disallow ip4 and ip6 l4_4_bytes

Ross Lagerwall (1):
      xen/netback: Ensure protocol headers don't fall in the non-linear area

Sebastian Reichel (1):
      arm: dts: rockchip: fix node name for hym8563 rtc

Srinivasa Rao Mandadapu (1):
      ASoC: soc-pcm: Add NULL check in BE reparenting

Sylwester Dziedziuch (1):
      i40e: Fix for VF MAC address 0

Tejun Heo (1):
      memcg: fix possible use-after-free in memcg_write_event_control()

Tetsuo Handa (1):
      fbcon: Use kzalloc() in fbcon_prepare_logo()

Thomas Huth (1):
      KVM: s390: vsie: Fix the initialization of the epoch extension (epdx) field

Tomislav Novak (1):
      ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels

Valentina Goncharenko (2):
      net: encx24j600: Add parentheses to fix precedence
      net: encx24j600: Fix invalid logic in reading of MISTAT register

Wang ShaoBo (1):
      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()

Wei Yongjun (1):
      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()

Xiongfeng Wang (1):
      gpio: amd8111: Fix PCI device reference count leak

Yang Yingliang (1):
      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()

YueHaibing (1):
      tipc: Fix potential OOB in tipc_link_proto_rcv()

Zhang Changzhong (1):
      ethernet: aeroflex: fix potential skb leak in greth_init_rings()

ZhangPeng (1):
      HID: core: fix shift-out-of-bounds in hid_report_raw_event

Zhengchao Shao (1):
      selftests: rtnetlink: correct xfrm policy rule in kci_test_ipsec_offload

Ziyang Xuan (1):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()

