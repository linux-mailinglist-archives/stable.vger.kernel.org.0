Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A63475BA
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhCXKTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhCXKTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC0761A04;
        Wed, 24 Mar 2021 10:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616581156;
        bh=qj3M8v5HftyfSYiTpazVoFJstBgWGgysQzaRjC+eOFs=;
        h=From:To:Cc:Subject:Date:From;
        b=DGw+fRuHI+5UGUdj56zDCFx90tKNSSxy3nWRylmjE5+ALKFhh0Ye1+6Iwyqr2aQDB
         tjosuQFHK1mTgArSPqnEpfOgj4c7yuiLqyfIzI2tGVYfty1pHJH96xxcq0wJUsGsvX
         Owt5sIyidgpRQpN7T1O2axcJSe+zUarcovL/zHAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.263
Date:   Wed, 24 Mar 2021 11:19:13 +0100
Message-Id: <161658115316149@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.263 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/x86/kernel/apic/io_apic.c          |   10 ++++
 drivers/pci/hotplug/rpadlpar_sysfs.c    |   14 ++----
 drivers/platform/chrome/cros_ec_dev.c   |    4 +
 drivers/platform/chrome/cros_ec_proto.c |    4 -
 drivers/scsi/lpfc/lpfc_debugfs.c        |    4 -
 drivers/usb/gadget/composite.c          |    4 -
 drivers/usb/gadget/configfs.c           |   16 ++++---
 drivers/usb/gadget/usbstring.c          |    4 -
 fs/btrfs/ctree.c                        |    2 
 fs/ext4/block_validity.c                |   71 ++++++++++++++------------------
 fs/ext4/ext4.h                          |    6 +-
 fs/ext4/extents.c                       |   16 ++-----
 fs/ext4/indirect.c                      |    6 --
 fs/ext4/inode.c                         |   13 ++---
 fs/ext4/mballoc.c                       |    4 -
 fs/ext4/namei.c                         |   29 ++++++++++++-
 fs/ext4/super.c                         |    5 +-
 include/linux/mfd/cros_ec.h             |    6 +-
 include/uapi/linux/usb/ch9.h            |    3 +
 kernel/irq/manage.c                     |    4 +
 net/sunrpc/svc_xprt.c                   |    4 -
 22 files changed, 138 insertions(+), 93 deletions(-)

Dan Carpenter (1):
      scsi: lpfc: Fix some error codes in debugfs

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Greg Kroah-Hartman (1):
      Linux 4.4.263

Gwendal Grignou (1):
      platform/chrome: cros_ec_dev - Fix security issue

Jan Kara (3):
      ext4: handle error of ext4_setup_system_zone() on remount
      ext4: don't allow overlapping system zones
      ext4: check journal inode extents more carefully

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

Joe Korty (1):
      NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Macpaul Lin (1):
      USB: replace hardcode maximum usb string length by definition

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

zhangyi (F) (1):
      ext4: find old entry again if failed to rename whiteout

