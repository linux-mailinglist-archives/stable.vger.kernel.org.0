Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566E164CD39
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLNPq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLNPqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:46:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25052229C;
        Wed, 14 Dec 2022 07:46:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53AD5B816ED;
        Wed, 14 Dec 2022 15:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A5AC433D2;
        Wed, 14 Dec 2022 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032812;
        bh=uf3uJ29IRF0B6jfTi/OVGxE/9DAFHln2ROkzkp71rHc=;
        h=From:To:Cc:Subject:Date:From;
        b=FXnN+3zUOVM5czozcyTDUlQWG0s8L+cQNzyWJM/n4Kls9ZdaxDc5BRHw5wZ9nF+nF
         kveQRq28AgAJy5lmhaG4Mty/sHbfF1SHFeiwPWML3VKo9ibW6kd3iWvg8RizZdf5vM
         GkBwizeckfU9yGiUZX+Y4xyGgQWo/iNf+VCJN7j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.336
Date:   Wed, 14 Dec 2022 16:46:47 +0100
Message-Id: <167103280818230@kroah.com>
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

I'm announcing the release of the 4.9.336 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/rk3036-evb.dts                   |    2 
 arch/arm/boot/dts/rk3188-radxarock.dts             |    2 
 arch/arm/boot/dts/rk3288-evb-act8846.dts           |    2 
 arch/arm/boot/dts/rk3288-firefly.dtsi              |    2 
 arch/arm/boot/dts/rk3288-miqi.dts                  |    2 
 arch/arm/boot/dts/rk3288-rock2-square.dts          |    2 
 arch/arm/include/asm/perf_event.h                  |    2 
 drivers/gpio/gpio-amd8111.c                        |    4 
 drivers/hid/hid-core.c                             |    3 
 drivers/hid/hid-lg4ff.c                            |    6 
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   20 +
 drivers/mmc/host/sdhci.c                           |   73 +++++-
 drivers/mmc/host/sdhci.h                           |   12 -
 drivers/net/ethernet/aeroflex/greth.c              |    1 
 drivers/net/ethernet/hisilicon/hisi_femac.c        |    2 
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c         |    4 
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    2 
 drivers/net/ethernet/marvell/mvneta.c              |    2 
 drivers/net/ethernet/microchip/encx24j600-regmap.c |    4 
 drivers/net/ieee802154/cc2520.c                    |    2 
 drivers/net/plip/plip.c                            |    4 
 drivers/net/xen-netback/common.h                   |   14 -
 drivers/net/xen-netback/interface.c                |   22 --
 drivers/net/xen-netback/netback.c                  |  229 +++++++++++----------
 drivers/net/xen-netback/rx.c                       |   10 
 net/bluetooth/6lowpan.c                            |    1 
 net/mac802154/iface.c                              |    1 
 net/nfc/nci/ntf.c                                  |    6 
 net/tipc/link.c                                    |    4 
 sound/core/seq/seq_memory.c                        |   11 -
 sound/soc/soc-pcm.c                                |    2 
 tools/testing/selftests/rcutorture/bin/kvm.sh      |    8 
 tools/testing/selftests/rcutorture/bin/mkinitrd.sh |   60 +++++
 35 files changed, 341 insertions(+), 184 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix voltage switch delay

Akihiko Odaki (2):
      e1000e: Fix TX dispatch condition
      igb: Allocate MSI-X vector when testing

Anastasia Belova (1):
      HID: hid-lg4ff: Add check for empty lbuf

Connor Shu (1):
      rcutorture: Automatically create initrd directory

Dan Carpenter (2):
      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
      net: mvneta: Fix an out of bounds check

Greg Kroah-Hartman (1):
      Linux 4.9.336

Hans Verkuil (1):
      media: v4l2-dv-timings.c: fix too strict blanking sanity checks

Johan Jonker (1):
      ARM: dts: rockchip: fix ir-receiver node names

Juergen Gross (3):
      xen/netback: do some code cleanup
      xen/netback: don't call kfree_skb() with interrupts disabled
      xen/netback: fix build warning

Kees Cook (2):
      ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
      NFC: nci: Bounds check struct nfc_target arrays

Liu Jian (2):
      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()

Masahiro Yamada (1):
      mmc: sdhci: use FIELD_GET for preset value bit masks

Ross Lagerwall (1):
      xen/netback: Ensure protocol headers don't fall in the non-linear area

Sebastian Reichel (1):
      arm: dts: rockchip: fix node name for hym8563 rtc

Srinivasa Rao Mandadapu (1):
      ASoC: soc-pcm: Add NULL check in BE reparenting

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

Ziyang Xuan (1):
      ieee802154: cc2520: Fix error return code in cc2520_hw_init()

