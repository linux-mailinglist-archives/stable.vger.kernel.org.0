Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6722C39168E
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhEZLu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 07:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhEZLuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 07:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA09B61132;
        Wed, 26 May 2021 11:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622029709;
        bh=wd4EAvM6usNnppXMM2jSgMcfRjMuPxnWjjd+co3+dMk=;
        h=From:To:Cc:Subject:Date:From;
        b=wonWkFWYL8cWG53qDBlJn2RUaykAMRq7yAgVW2X9sKEfwApQjSq14lnlJXIYsgfAH
         CxyijzgVpRemxXXQmHehgpDprxPHjR0G2BqseYclA5Vg3TpzKfQp2ToAe+N5WBJBhU
         WSWDqdKx8/R9yMVltqbwnJlH78Yli0MCZnwR7bqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.270
Date:   Wed, 26 May 2021 13:48:25 +0200
Message-Id: <1622029706112146@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.270 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/openrisc/kernel/setup.c                        |    2 
 drivers/cdrom/gdrom.c                               |   13 +++-
 drivers/hwmon/lm80.c                                |   11 ---
 drivers/leds/leds-lp5523.c                          |    2 
 drivers/md/dm-snap.c                                |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c   |    8 +-
 drivers/net/ethernet/sun/niu.c                      |   32 +++++++----
 drivers/net/wireless/realtek/rtlwifi/base.c         |   19 +++---
 drivers/scsi/qla2xxx/qla_nx.c                       |    3 -
 drivers/tty/vt/vt.c                                 |    2 
 drivers/tty/vt/vt_ioctl.c                           |    6 +-
 drivers/video/console/fbcon.c                       |    2 
 drivers/video/console/vgacon.c                      |   56 +++++++++++---------
 drivers/video/fbdev/hgafb.c                         |   21 ++++---
 drivers/video/fbdev/imsttfb.c                       |    5 -
 drivers/xen/xen-pciback/xenbus.c                    |   22 ++++++-
 fs/cifs/smb2ops.c                                   |    2 
 fs/ecryptfs/crypto.c                                |    6 --
 include/linux/console_struct.h                      |    1 
 kernel/ptrace.c                                     |   18 ++++++
 net/bluetooth/smp.c                                 |    9 +++
 sound/firewire/Kconfig                              |    4 -
 sound/firewire/bebob/bebob.c                        |    2 
 sound/firewire/oxfw/oxfw.c                          |    1 
 sound/isa/sb/sb8.c                                  |    4 -
 sound/usb/midi.c                                    |    4 +
 28 files changed, 158 insertions(+), 103 deletions(-)

Anirudh Rayabharam (2):
      net: stmicro: handle clk_prepare() failure during init
      video: hgafb: correctly handle card detect failure during probe

Atul Gopinathan (1):
      cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Christophe JAILLET (1):
      openrisc: Fix a memory leak

Du Cheng (1):
      ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Greg Kroah-Hartman (14):
      Revert "ALSA: sb8: add a check for request_region"
      Revert "video: hgafb: fix potential NULL pointer dereference"
      Revert "net: stmicro: fix a missing check of clk_prepare"
      Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
      Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"
      Revert "video: imsttfb: fix potential NULL pointer dereferences"
      Revert "ecryptfs: replace BUG_ON with error handling code"
      Revert "gdrom: fix a memory leak bug"
      cdrom: gdrom: initialize global variable at init time
      Revert "rtlwifi: fix a potential NULL pointer dereference"
      Revert "qlcnic: Avoid potential NULL pointer dereference"
      Revert "niu: fix missing checks of niu_pci_eeprom_read"
      net: rtlwifi: properly check for alloc_workqueue() failure
      Linux 4.4.270

Igor Matheus Andrade Torrente (1):
      video: hgafb: fix potential NULL pointer dereference

Jan Beulich (1):
      xen-pciback: reconfigure also from backend watch handler

Luiz Augusto von Dentz (1):
      Bluetooth: SMP: Fail if remote and local public keys are identical

Maciej W. Rozycki (2):
      vgacon: Record video mode changes with VT_RESIZEX
      vt: Fix character height handling with VT_RESIZEX

Mikulas Patocka (1):
      dm snapshot: fix crash with transient storage and zero chunk size

Oleg Nesterov (1):
      ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

Phillip Potter (1):
      leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Ronnie Sahlberg (1):
      cifs: fix memory leak in smb2_copychunk_range

Takashi Iwai (1):
      ALSA: usb-audio: Validate MS endpoint descriptors

Takashi Sakamoto (1):
      ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro

Tetsuo Handa (1):
      tty: vt: always invoke vc->vc_sw->con_resize callback

Tom Seewald (1):
      qlcnic: Add null check after calling netdev_alloc_skb

Zhen Lei (1):
      scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

