Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C85EDA62
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiI1KtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbiI1KtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A19AF0CA;
        Wed, 28 Sep 2022 03:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A74D2B81D56;
        Wed, 28 Sep 2022 10:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1489CC433C1;
        Wed, 28 Sep 2022 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664362146;
        bh=n7DnCc9gmPsJT1ptQRXsKjiNijTjLuV37RqGZT/zl68=;
        h=From:To:Cc:Subject:Date:From;
        b=R4utxUXQSy40bkr5GbuvL7W7xstq9tfv7qimjs0Qxnc96UQH2UO87rarO/Ywnlyne
         eimqEEyA3QeRCUrKXidpGP31+DR+jI+/cACYupAsgJHxKNgI8Bntr5qfqi7dmkG8/a
         KHBXlmGhno7tLzHJyz75S3zGGKo1fon7DGaHCJSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.330
Date:   Wed, 28 Sep 2022 12:49:02 +0200
Message-Id: <166436214215459@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.330 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 arch/mips/lantiq/clk.c            |    1 +
 drivers/hv/vmbus_drv.c            |   10 +++++++++-
 drivers/net/can/usb/gs_usb.c      |    4 ++--
 drivers/net/ethernet/sun/sunhme.c |    4 ++--
 drivers/net/ipvlan/ipvlan_core.c  |    6 ++++--
 drivers/net/team/team.c           |   24 ++++++++++++++++++------
 drivers/parisc/ccio-dma.c         |    1 +
 drivers/s390/block/dasd_alias.c   |    9 +++++++--
 drivers/tty/serial/serial-tegra.c |    5 ++---
 drivers/usb/core/hub.c            |    2 +-
 drivers/video/fbdev/pxa3xx-gcu.c  |    2 +-
 fs/cifs/transport.c               |    4 ++--
 fs/ext4/ialloc.c                  |    2 +-
 include/linux/serial_core.h       |   17 +++++++++++++++++
 mm/slub.c                         |    5 ++++-
 net/mac80211/scan.c               |   11 +++++++----
 net/netfilter/nf_conntrack_irc.c  |   34 ++++++++++++++++++++++++++++------
 net/netfilter/nf_conntrack_sip.c  |    4 ++--
 sound/pci/hda/hda_intel.c         |    2 ++
 sound/pci/hda/patch_hdmi.c        |    1 +
 tools/perf/util/symbol-elf.c      |    7 ++-----
 22 files changed, 115 insertions(+), 42 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Do not check /proc/modules is unchanged

Alan Stern (1):
      USB: core: Fix RST error in hub.c

Benjamin Poirier (1):
      net: team: Unsync device addresses on ndo_stop

Chao Yu (1):
      mm/slub: fix to return errno if kmalloc() fails

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Tighten matching on DCC message

Greg Kroah-Hartman (1):
      Linux 4.9.330

Hyunwoo Kim (1):
      video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Igor Ryzhov (1):
      netfilter: nf_conntrack_sip: fix ct_sip_walk_headers

Ilpo Järvinen (2):
      serial: Create uart_xmit_advance()
      serial: tegra: Use uart_xmit_advance(), fixes icount.tx accounting

Jan Kara (1):
      ext4: make directory inode spreading reflect flexbg size

Kai Vehmanen (1):
      ALSA: hda: add Intel 5 Series / 3400 PCI DID

Lu Wei (1):
      ipvlan: Fix out-of-bound bugs caused by unset skb->mac_header

Marc Kleine-Budde (1):
      can: gs_usb: gs_can_open(): fix race dev->can.state condition

Mohan Kumar (1):
      ALSA: hda/tegra: set depop delay for tegra

Randy Dunlap (1):
      MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko

Sean Anderson (1):
      net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD

Siddh Raman Pant (1):
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Stefan Haberland (1):
      s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup

Stefan Metzmacher (1):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Vitaly Kuznetsov (1):
      Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

