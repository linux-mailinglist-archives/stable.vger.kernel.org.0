Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA6C2F00C2
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbhAIP0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:26:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbhAIP0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF48023A5A;
        Sat,  9 Jan 2021 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205920;
        bh=px9lMFeiVBTrvJqGWf5TAg53ywEOk9vN4vIzXdXf/B0=;
        h=From:To:Cc:Subject:Date:From;
        b=fM2HejlrPlN6Ei+0pHOyMZZLDwtXAZPZeIC/UpvWotFNAaGJBeFyrMPhb6nv4MbQK
         ZSK4DrA5kZ5uAVkCwcsESx2LyRVNNZ++UEA6nTdY0oY0CiKP38Mpg/K0mvWQDSz8fr
         y1hN5v6mgmRnD6sHgzTMvT17mpTQ3OdeaC0UufWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.214
Date:   Sat,  9 Jan 2021 16:26:32 +0100
Message-Id: <161020599185165@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.214 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/powerpc/include/asm/bitops.h           |   23 +++
 arch/powerpc/sysdev/mpic_msgr.c             |    2 
 arch/x86/entry/entry_64.S                   |    2 
 drivers/iio/imu/bmi160/bmi160_core.c        |   13 +-
 drivers/iio/magnetometer/mag3110.c          |   13 +-
 drivers/md/dm-verity-target.c               |   12 +-
 drivers/md/raid10.c                         |    3 
 drivers/media/usb/dvb-usb/gp8psk.c          |    2 
 drivers/misc/vmw_vmci/vmci_context.c        |    2 
 drivers/net/wireless/marvell/mwifiex/join.c |    2 
 drivers/rtc/rtc-sun6i.c                     |    8 -
 drivers/s390/block/dasd_alias.c             |   10 +
 drivers/usb/serial/digi_acceleport.c        |   45 ++-----
 drivers/vfio/pci/vfio_pci.c                 |    3 
 fs/quota/quota_tree.c                       |    8 -
 fs/reiserfs/stree.c                         |    6 +
 include/linux/kdev_t.h                      |   22 +--
 include/linux/memcontrol.h                  |  165 +++++++++++++++++-----------
 include/linux/of.h                          |    1 
 include/uapi/linux/const.h                  |    5 
 include/uapi/linux/ethtool.h                |    2 
 include/uapi/linux/kernel.h                 |    9 -
 include/uapi/linux/lightnvm.h               |    2 
 include/uapi/linux/mroute6.h                |    2 
 include/uapi/linux/netfilter/x_tables.h     |    2 
 include/uapi/linux/netlink.h                |    2 
 include/uapi/linux/sysctl.h                 |    2 
 kernel/module.c                             |    6 -
 mm/memcontrol.c                             |  160 ++++++++++++---------------
 sound/core/pcm_native.c                     |    9 +
 sound/core/seq/seq_queue.h                  |    8 -
 sound/pci/hda/patch_ca0132.c                |   16 ++
 sound/usb/pcm.c                             |   52 +++-----
 34 files changed, 347 insertions(+), 274 deletions(-)

Alberto Aguirre (1):
      ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Anant Thazhemadam (1):
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Christophe Leroy (1):
      powerpc/bitops: Fix possible undefined behaviour with fls() and fls64()

Dinghao Liu (1):
      rtc: sun6i: Fix memleak in sun6i_rtc_clk_init

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Greg Kroah-Hartman (1):
      Linux 4.14.214

Hyeongseok Kim (1):
      dm verity: skip verity work if I/O error when system is shutting down

Jan Beulich (1):
      x86/entry/64: Add instruction suffix

Jan Kara (1):
      quota: Don't overflow quota file offsets

Jessica Yu (1):
      module: delay kobject uevent until after module init call

Johan Hovold (3):
      ALSA: usb-audio: fix sync-ep altsetting sanity check
      USB: serial: digi_acceleport: fix write-wakeup deadlocks
      of: fix linker-section match-table corruption

Johannes Weiner (3):
      mm: memcontrol: eliminate raw access to stat and event counters
      mm: memcontrol: implement lruvec stat functions on top of each other
      mm: memcontrol: fix excessive complexity in memory.stat reporting

Jonathan Cameron (2):
      iio:imu:bmi160: Fix alignment and data leak issues
      iio:magnetometer:mag3110: Fix alignment and data leak issues.

Josh Poimboeuf (1):
      kdev_t: always inline major/minor helper functions

Kevin Vigor (1):
      md/raid10: initialize r10_bio->read_slot before use.

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

Takashi Iwai (3):
      ALSA: hda/ca0132 - Fix work handling in delayed HP detection
      ALSA: seq: Use bool for snd_seq_queue internal flags
      ALSA: pcm: Clear the full allocated memory at hw_params

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

