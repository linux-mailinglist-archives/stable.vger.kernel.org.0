Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F232F00BA
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbhAIPZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:25:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbhAIPZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:25:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1340423884;
        Sat,  9 Jan 2021 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205906;
        bh=GHxi8NSejOMRsii3GmF3zMBVd/qZr4WbUrq4zIa7Kg0=;
        h=From:To:Cc:Subject:Date:From;
        b=pH0vXGiR2716NCF6zxw9T18KSHQ/t83Wmm/D3Qi2Ft0m/0QDr80sNTtSFoynM579X
         wcJHMjjR1n4KQW+bxix9yP6wQOZFlvg7xvuvIp6LrQefqASkadxshlovfssWHhmXcs
         epkkKlq6hSj2AldQQFaVPi2omDgaAxl9/nzzfJII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.250
Date:   Sat,  9 Jan 2021 16:26:20 +0100
Message-Id: <161020598086193@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.250 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 -
 arch/powerpc/sysdev/mpic_msgr.c         |    2 -
 drivers/iio/magnetometer/mag3110.c      |   13 ++++++---
 drivers/media/usb/dvb-usb/gp8psk.c      |    2 -
 drivers/misc/vmw_vmci/vmci_context.c    |    2 -
 drivers/net/wireless/mwifiex/join.c     |    2 +
 drivers/s390/block/dasd_alias.c         |   10 ++++++-
 drivers/usb/serial/digi_acceleport.c    |   45 +++++++++-----------------------
 fs/quota/quota_tree.c                   |    8 ++---
 fs/reiserfs/stree.c                     |    6 ++++
 include/linux/of.h                      |    1 
 include/uapi/linux/const.h              |    5 +++
 include/uapi/linux/lightnvm.h           |    2 -
 include/uapi/linux/netfilter/x_tables.h |    2 -
 include/uapi/linux/netlink.h            |    2 -
 include/uapi/linux/sysctl.h             |    2 -
 kernel/module.c                         |    6 ++--
 sound/core/seq/seq_queue.h              |    8 ++---
 sound/pci/hda/patch_ca0132.c            |   16 +++++++++--
 sound/pci/hda/patch_realtek.c           |   25 +++++++++++++++--
 sound/usb/pcm.c                         |   38 +++++++++++----------------
 21 files changed, 117 insertions(+), 82 deletions(-)

Alberto Aguirre (1):
      ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Anant Thazhemadam (1):
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Greg Kroah-Hartman (1):
      Linux 4.4.250

Hui Wang (1):
      ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines

Jan Kara (1):
      quota: Don't overflow quota file offsets

Jessica Yu (1):
      module: delay kobject uevent until after module init call

Johan Hovold (3):
      ALSA: usb-audio: fix sync-ep altsetting sanity check
      USB: serial: digi_acceleport: fix write-wakeup deadlocks
      of: fix linker-section match-table corruption

Jonathan Cameron (1):
      iio:magnetometer:mag3110: Fix alignment and data leak issues.

Kailang Yang (2):
      ALSA: hda/realtek - Support Dell headset mode for ALC3271
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Mauro Carvalho Chehab (1):
      media: gp8psk: initialize stats at power control logic

Miroslav Benes (1):
      module: set MODULE_STATE_GOING state when a module fails to load

Petr Vorel (1):
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Qinglang Miao (1):
      powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Rustam Kovhaev (1):
      reiserfs: add check for an invalid ih_entry_count

Stefan Haberland (1):
      s390/dasd: fix hanging device offline processing

Takashi Iwai (2):
      ALSA: hda/ca0132 - Fix work handling in delayed HP detection
      ALSA: seq: Use bool for snd_seq_queue internal flags

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

