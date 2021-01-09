Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC26D2F00BE
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAIPZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbhAIPZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:25:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47CC623A3C;
        Sat,  9 Jan 2021 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205913;
        bh=UyRw4rKEjDRVNJTS8g0r/HXiLi7WsIu/cBiCr54KoxQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ML7WXM4EH51oEFTz5jsiyUO50Z5hVMSF0OH02mh/mEIKzxeq4XLhvJysvupoaa/S7
         JFXSYZ8kjTQifux5mnraZAwQO2Q1rn7NQcT9PPCkC2BJFl2WIeiVYypyZARq3oISd0
         BwjTBUZOj+3ORuNtjPEjlHci/t977guWmDu39jYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.250
Date:   Sat,  9 Jan 2021 16:26:25 +0100
Message-Id: <1610205985137223@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.250 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 arch/powerpc/sysdev/mpic_msgr.c             |    2 -
 arch/x86/entry/entry_64.S                   |    2 -
 drivers/block/xen-blkback/xenbus.c          |    3 +
 drivers/iio/imu/bmi160/bmi160_core.c        |   12 ++++--
 drivers/iio/magnetometer/mag3110.c          |   13 ++++---
 drivers/media/usb/dvb-usb/gp8psk.c          |    2 -
 drivers/misc/vmw_vmci/vmci_context.c        |    2 -
 drivers/net/wireless/marvell/mwifiex/join.c |    2 +
 drivers/net/xen-netback/xenbus.c            |    4 +-
 drivers/s390/block/dasd_alias.c             |   10 ++++-
 drivers/usb/serial/digi_acceleport.c        |   45 +++++++-----------------
 drivers/vfio/pci/vfio_pci.c                 |    4 --
 drivers/xen/xen-pciback/xenbus.c            |    2 -
 drivers/xen/xenbus/xenbus_client.c          |    8 +++-
 drivers/xen/xenbus/xenbus_probe.c           |    1 
 drivers/xen/xenbus/xenbus_probe.h           |    2 +
 drivers/xen/xenbus/xenbus_probe_backend.c   |    7 +++
 drivers/xen/xenbus/xenbus_xs.c              |   38 +++++++++++++-------
 fs/quota/quota_tree.c                       |    8 ++--
 fs/reiserfs/stree.c                         |    6 +++
 include/linux/kdev_t.h                      |   22 +++++------
 include/linux/of.h                          |    1 
 include/uapi/linux/const.h                  |    5 ++
 include/uapi/linux/ethtool.h                |    2 -
 include/uapi/linux/kernel.h                 |    9 ----
 include/uapi/linux/lightnvm.h               |    2 -
 include/uapi/linux/mroute6.h                |    2 -
 include/uapi/linux/netfilter/x_tables.h     |    2 -
 include/uapi/linux/netlink.h                |    2 -
 include/uapi/linux/sysctl.h                 |    2 -
 include/xen/xenbus.h                        |   15 +++++++-
 kernel/module.c                             |    6 ++-
 net/ipv6/datagram.c                         |   21 +++++++++--
 net/l2tp/l2tp_core.c                        |   38 +++++++++-----------
 net/l2tp/l2tp_core.h                        |    3 -
 sound/core/seq/seq_queue.h                  |    8 ++--
 sound/pci/hda/patch_ca0132.c                |   16 +++++++-
 sound/pci/hda/patch_realtek.c               |   25 +++++++++++--
 sound/usb/pcm.c                             |   52 ++++++++++------------------
 40 files changed, 243 insertions(+), 165 deletions(-)

Alberto Aguirre (1):
      ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk

Anant Thazhemadam (1):
      misc: vmw_vmci: fix kernel info-leak by initializing dbells in vmci_ctx_get_chkpt_doorbells()

Eric Auger (1):
      vfio/pci: Move dummy_resources_list init in vfio_pci_probe()

Greg Kroah-Hartman (1):
      Linux 4.9.250

Hui Wang (1):
      ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines

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

Jonathan Cameron (3):
      iio:imu:bmi160: Fix too large a buffer.
      iio:imu:bmi160: Fix alignment and data leak issues
      iio:magnetometer:mag3110: Fix alignment and data leak issues.

Josh Poimboeuf (1):
      kdev_t: always inline major/minor helper functions

Kailang Yang (2):
      ALSA: hda/realtek - Support Dell headset mode for ALC3271
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Mauro Carvalho Chehab (1):
      media: gp8psk: initialize stats at power control logic

Miroslav Benes (1):
      module: set MODULE_STATE_GOING state when a module fails to load

Paolo Abeni (2):
      net: ipv6: keep sk status consistent after datagram connect failure
      l2tp: fix races with ipv4-mapped ipv6 addresses

Petr Vorel (1):
      uapi: move constants from <linux/kernel.h> to <linux/const.h>

Qinglang Miao (1):
      powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()

Rustam Kovhaev (1):
      reiserfs: add check for an invalid ih_entry_count

SeongJae Park (5):
      xen/xenbus: Allow watches discard events before queueing
      xen/xenbus: Add 'will_handle' callback support in xenbus_watch_path()
      xen/xenbus/xen_bus_type: Support will_handle watch callback
      xen/xenbus: Count pending messages for each watch
      xenbus/xenbus_backend: Disallow pending watch messages

Stefan Haberland (1):
      s390/dasd: fix hanging device offline processing

Takashi Iwai (2):
      ALSA: hda/ca0132 - Fix work handling in delayed HP detection
      ALSA: seq: Use bool for snd_seq_queue internal flags

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

sayli karnik (1):
      iio: bmi160_core: Fix sparse warning due to incorrect type in assignment

