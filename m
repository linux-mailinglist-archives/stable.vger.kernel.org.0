Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EE35B98FA
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 12:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIOKlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 06:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIOKkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 06:40:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4161711;
        Thu, 15 Sep 2022 03:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A509F622DB;
        Thu, 15 Sep 2022 10:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1B5C433C1;
        Thu, 15 Sep 2022 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663238447;
        bh=ZIcUqAyU5l5FMFL4bMtTmKdVCypGy/qOactFq7SAIv4=;
        h=From:To:Cc:Subject:Date:From;
        b=c8aX3qiMu3FOor06wuEQnuuhSYG9cosRB6PExkLpxRuLJHxzyRvWifOc7WFb61wzA
         5UuvsUKgBd6WlKH/cfU9EfJ6WJ4su3A7Zq36zKwc+0lX6kXfRLqHvaEgM6LSwQO8y6
         pwapFqKROxktHKk5oUpTv4NzC1U20sDAGV3VuESo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.328
Date:   Thu, 15 Sep 2022 12:41:09 +0200
Message-Id: <166323846967209@kroah.com>
X-Mailer: git-send-email 2.37.3
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

I'm announcing the release of the 4.9.328 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 -
 arch/mips/loongson32/ls1c/board.c            |    1 
 arch/parisc/kernel/head.S                    |   43 ++++++++++++++++++++++++++-
 arch/s390/include/asm/hugetlb.h              |    6 ++-
 arch/s390/kernel/vmlinux.lds.S               |    1 
 arch/x86/include/asm/pmc_atom.h              |    6 ++-
 arch/x86/platform/atom/pmc_atom.c            |    2 -
 drivers/base/dd.c                            |   10 ++++++
 drivers/gpu/drm/radeon/radeon_device.c       |    3 +
 drivers/hwmon/gpio-fan.c                     |    3 +
 drivers/parisc/ccio-dma.c                    |   11 +++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |    2 -
 drivers/staging/rtl8712/rtl8712_cmd.c        |   36 ----------------------
 drivers/tty/serial/fsl_lpuart.c              |    4 +-
 drivers/tty/vt/vt.c                          |   12 +++++--
 drivers/usb/class/cdc-acm.c                  |    3 +
 drivers/usb/core/hub.c                       |   10 ++++++
 drivers/usb/dwc3/core.c                      |   20 ++++++------
 drivers/usb/gadget/function/storage_common.c |    6 ++-
 drivers/usb/host/xhci-hub.c                  |   11 ++++++
 drivers/usb/host/xhci.c                      |    4 +-
 drivers/usb/host/xhci.h                      |    2 -
 drivers/usb/serial/cp210x.c                  |    1 
 drivers/usb/serial/ftdi_sio.c                |    2 +
 drivers/usb/serial/ftdi_sio_ids.h            |    6 +++
 drivers/usb/serial/option.c                  |   11 ++++++
 drivers/usb/storage/unusual_devs.h           |    7 ++++
 drivers/video/fbdev/chipsfb.c                |    1 
 drivers/video/fbdev/pm2fb.c                  |    5 +++
 include/linux/buffer_head.h                  |   11 ++++++
 include/linux/usb.h                          |    2 +
 mm/kmemleak.c                                |    8 ++---
 net/bridge/br_netfilter_hooks.c              |    2 +
 net/bridge/br_netfilter_ipv6.c               |    1 
 net/ipv4/tcp_input.c                         |   25 +++++++++++----
 net/mac80211/ibss.c                          |    4 ++
 net/mac802154/rx.c                           |    2 -
 net/netfilter/nf_conntrack_irc.c             |    5 +--
 net/sched/sch_sfb.c                          |   13 +++++---
 net/sunrpc/xprt.c                            |    4 +-
 net/tipc/monitor.c                           |    2 -
 net/wireless/debugfs.c                       |    3 +
 sound/core/seq/oss/seq_oss_midi.c            |    2 +
 sound/core/seq/seq_clientmgr.c               |   12 +++----
 sound/drivers/aloop.c                        |    7 ++--
 sound/pci/emu10k1/emupcm.c                   |    2 -
 sound/usb/stream.c                           |    2 -
 47 files changed, 235 insertions(+), 103 deletions(-)

Alan Stern (1):
      USB: core: Prevent nested device-reset calls

Andy Shevchenko (1):
      platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Armin Wolf (1):
      hwmon: (gpio-fan) Fix array out of bounds access

Dan Carpenter (3):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      staging: rtl8712: fix use after free bugs
      tipc: fix shift wrapping bug in map_get()

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

Dongxiang Ke (1):
      ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Gerald Schaefer (1):
      s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Greg Kroah-Hartman (1):
      Linux 4.9.328

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Helge Deller (2):
      vt: Clear selection before changing the font
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Isaac J. Manjarres (1):
      driver core: Don't probe devices after bus_type.match() probe deferral

Johan Hovold (2):
      USB: serial: cp210x: add Decagon UCA device id
      usb: dwc3: fix PHY disable sequence

Josh Poimboeuf (1):
      s390: fix nospec table alignments

Krishna Kurapati (1):
      usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Letu Ren (1):
      fbdev: fb_pm2fb: Avoid potential divide by zero error

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Mathias Nyman (1):
      xhci: Add grace period after xHC start to prevent premature runtime suspend.

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

NeilBrown (1):
      SUNRPC: use _bh spinlocking on ->transport_lock

Niek Nooijens (1):
      USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Pattara Teerapong (1):
      ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Shenwei Wang (1):
      serial: fsl_lpuart: RS485 RTS polariy is inverse

Siddh Raman Pant (1):
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Takashi Iwai (2):
      ALSA: seq: oss: Fix data-race for max_midi_devs access
      ALSA: seq: Fix data-race at module auto-loading

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Thierry GUIBERT (1):
      USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Witold Lipieta (1):
      usb-storage: Add ignore-residue quirk for NXP PN7462AU

Yan Xinyu (1):
      USB: serial: option: add support for OPPO R11 diag port

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (1):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

