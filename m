Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72E44A8099
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 09:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349578AbiBCIrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 03:47:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349577AbiBCIrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 03:47:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0F58B82123;
        Thu,  3 Feb 2022 08:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B98C340E4;
        Thu,  3 Feb 2022 08:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643878018;
        bh=jWoOlEQauLfpZZsKR0mUzPMpJIfDqukG/hN1opLdiEU=;
        h=From:To:Cc:Subject:Date:From;
        b=uLTzdydpXSYCCZYhijRt0n6IB3lpHRHPsoQdkJAyWIUs5zv9icfLsA9t3LRUC7n2l
         oYYwesbtxz4xXluZ3sufxqKhPvCk0OJq5qlRRB0uPMOOLzO0/umCq97lVgwUtwVjnY
         GAPX92H7ReDvb4GNCA7+cIyF3RziX/YgBrbIbSQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.302
Date:   Thu,  3 Feb 2022 09:46:49 +0100
Message-Id: <1643877137240249@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.302 kernel.

This kernel branch is now END-OF-LIFE.  It will not be getting any more
updates from the kernel stable team, and will most likely quickly become
insecure and out-of-date.  Do not use it anymore unless you really know
what you are doing.

Note, the CIP project at https://www.cip-project.org/ is considering to
maintain the 4.4 branch in a limited capability going forward.  If you
really need to use this kernel version, please contact them.

Some simple statistics for the 4.4.y kernel branch:
	First release:		January 10, 2016
	Last release:		Febuary 3, 2022
	Days supported:		2216
	Changes added:		18712
	Changes added per day:	8.44
	Unique developers:	3532
	Unique companies:	503

It was a good kernel branch, helped out by many to work as well as it
has, thanks to all for your help with this.  It has powered many
millions, maybe a few billion, devices out in the world, but now it's
time to say good-bye.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 
 arch/s390/hypfs/hypfs_vm.c            |    6 +-
 arch/x86/kvm/x86.c                    |   14 ++--
 drivers/gpu/drm/msm/msm_drv.c         |    2 
 drivers/gpu/drm/radeon/ci_dpm.c       |    6 --
 drivers/hwmon/lm90.c                  |    2 
 drivers/input/serio/i8042-x86ia64io.h |   11 ++-
 drivers/media/i2c/tc358743.c          |    2 
 drivers/s390/scsi/zfcp_fc.c           |   13 ++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c     |   20 +-----
 drivers/tty/n_gsm.c                   |    4 +
 drivers/tty/serial/8250/8250_pci.c    |  100 +++++++++++++++++++++++++++++++++-
 drivers/tty/serial/stm32-usart.c      |    2 
 drivers/usb/core/hcd.c                |   14 ++++
 drivers/usb/core/urb.c                |   12 ++++
 drivers/usb/storage/unusual_devs.h    |   10 +++
 fs/udf/inode.c                        |    9 +--
 include/linux/netdevice.h             |    1 
 include/net/ip.h                      |   21 +++----
 kernel/power/wakelock.c               |   12 +---
 net/bluetooth/hci_event.c             |   10 +--
 net/bluetooth/mgmt.c                  |    8 +-
 net/can/bcm.c                         |   20 +++---
 net/core/net-procfs.c                 |   38 +++++++++++-
 net/ipv4/ip_output.c                  |   11 +++
 net/ipv4/raw.c                        |    5 +
 net/ipv6/ip6_tunnel.c                 |    8 +-
 net/packet/af_packet.c                |    2 
 28 files changed, 267 insertions(+), 98 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

Eric Dumazet (3):
      ipv4: avoid using shared IP generator for connected sockets
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages

Greg Kroah-Hartman (2):
      PM: wakeup: simplify the output logic of pm_show_wakelocks()
      Linux 4.4.302

Guenter Roeck (1):
      hwmon: (lm90) Reduce maximum conversion rate for G781

Guillaume Bertholon (5):
      Bluetooth: MGMT: Fix misplaced BT_HS check
      Revert "drm/radeon/ci: disable mclk switching for high refresh rates (v2)"
      Revert "tc358743: fix register i2c_rd/wr function fix"
      KVM: x86: Fix misplaced backport of "work around leak of uninitialized stack contents"
      Input: i8042 - Fix misplaced backport of "add ASUS Zenbook Flip to noselftest list"

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

John Meneghini (1):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Steffen Maier (1):
      scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Ziyang Xuan (1):
      can: bcm: fix UAF of bcm op

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

