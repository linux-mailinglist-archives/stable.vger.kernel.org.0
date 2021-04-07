Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8F356A30
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbhDGKq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351440AbhDGKqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:46:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 909736139C;
        Wed,  7 Apr 2021 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617792362;
        bh=uTuI5HeuEM9PE9whtGnCwBZD8vXb5ghCHp7rSrp4guU=;
        h=From:To:Cc:Subject:Date:From;
        b=VylymsCUT/HQ0YRNzkae/jNT8UHHndZuoYzhvYZntmQNjj02GHsRA2ColAQnE1A9Q
         OvXj+uTTm4+vkPVJtQ10nAXxBQagdue03d3Lmql/NJQGJzXjuqc1gqZTs3+RJQ7H/O
         Zo6jE58Q8ze3vXrtO1DjA6knQ7LSpufxvciEAk+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.265
Date:   Wed,  7 Apr 2021 12:45:58 +0200
Message-Id: <161779235816622@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.265 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                     |    2 -
 drivers/extcon/extcon.c                      |    1 
 drivers/firewire/nosy.c                      |    9 +++++--
 drivers/net/wan/lmc/lmc_main.c               |    2 +
 drivers/pinctrl/pinctrl-rockchip.c           |   13 ++++++----
 drivers/scsi/qla2xxx/qla_target.h            |    2 -
 drivers/scsi/st.c                            |    2 -
 drivers/staging/comedi/drivers/cb_pcidas.c   |    2 -
 drivers/staging/comedi/drivers/cb_pcidas64.c |    2 -
 drivers/staging/rtl8192e/rtllib.h            |    2 -
 drivers/staging/rtl8192e/rtllib_rx.c         |    2 -
 drivers/usb/class/cdc-acm.c                  |   12 ++++++++-
 drivers/usb/core/quirks.c                    |    4 +++
 fs/ext4/inode.c                              |    6 ++--
 fs/ext4/namei.c                              |   18 +++++++-------
 fs/reiserfs/xattr.h                          |    2 -
 kernel/trace/trace.c                         |    3 +-
 mm/memory.c                                  |    2 -
 net/appletalk/ddp.c                          |   33 +++++++++++++++++----------
 net/dccp/ipv6.c                              |    5 ++++
 net/ipv6/ip6_input.c                         |   10 --------
 net/ipv6/tcp_ipv6.c                          |    5 ++++
 net/sunrpc/auth_gss/svcauth_gss.c            |   11 +++++----
 net/vmw_vsock/af_vsock.c                     |    1 
 sound/pci/hda/patch_realtek.c                |    1 
 sound/soc/codecs/rt5640.c                    |    4 +--
 sound/soc/codecs/rt5651.c                    |    4 +--
 sound/soc/codecs/sgtl5000.c                  |    2 -
 sound/usb/quirks.c                           |    1 
 29 files changed, 101 insertions(+), 62 deletions(-)

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Atul Gopinathan (2):
      staging: rtl8192e: Fix incorrect source in memcpy()
      staging: rtl8192e: Change state information from u16 to u8

Benjamin Rood (1):
      ASoC: sgtl5000: set DAP_AVC_CTRL register to correct default value on probe

David Brazdil (1):
      selinux: vsock: Set SID for socket returned by accept()

Dinghao Liu (1):
      extcon: Fix error handling in extcon_dev_register

Doug Brown (1):
      appletalk: Fix skb allocation size in loopback case

Greg Kroah-Hartman (1):
      Linux 4.4.265

Hans de Goede (2):
      ASoC: rt5640: Fix dac- and adc- vol-tlv values being off by a factor of 10
      ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10

Hui Wang (1):
      ALSA: hda/realtek: call alc_update_headset_mode() in hp_automute_hook

Ikjoon Jang (1):
      ALSA: usb-audio: Apply sample rate quirk to Logitech Connect

Ilya Lipnitskiy (1):
      mm: fix race by making init_zero_pfn() early_initcall

J. Bruce Fields (1):
      rpc: fix NULL dereference on kmalloc failure

Jakub Kicinski (1):
      ipv6: weaken the v4mapped source check

Johan Hovold (1):
      USB: cdc-acm: fix use-after-free after probe failure

Lv Yunlong (1):
      scsi: st: Fix a use after free in st_open()

Oliver Neukum (2):
      cdc-acm: fix BREAK rx code path adding necessary calls
      USB: cdc-acm: downgrade message to debug

Steven Rostedt (VMware) (1):
      tracing: Fix stack trace event size

Tetsuo Handa (1):
      reiserfs: update reiserfs_xattrs_initialized() condition

Tong Zhang (3):
      staging: comedi: cb_pcidas: fix request_irq() warn
      staging: comedi: cb_pcidas64: fix request_irq() warn
      net: wan/lmc: unregister device when no matching device is found

Vincent Palatin (1):
      USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem

Wang Panzhenzhuan (1):
      pinctrl: rockchip: fix restore error in resume

Zhaolong Zhang (1):
      ext4: fix bh ref count on error paths

Zheyu Ma (1):
      firewire: nosy: Fix a use-after-free bug in nosy_ioctl()

zhangyi (F) (1):
      ext4: do not iput inode under running transaction in ext4_rename()

