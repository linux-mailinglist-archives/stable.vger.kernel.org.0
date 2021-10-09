Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE6427A2C
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 14:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhJIMku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 08:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230418AbhJIMkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 08:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A373860F6C;
        Sat,  9 Oct 2021 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633783133;
        bh=viFBKVGOo2wbj0/TYY9msVv67fU3QESpOUe2pFdUlps=;
        h=From:To:Cc:Subject:Date:From;
        b=gfT/hea+j4TigqfBvQTNbQCEKTV2szGVyrGw9+3hjn8mxc0xhBcDeYonavERxT3wU
         ZeThfB4IFTT3JINAI2+VIeg+oZWMuvs3j+DXdTjDTbYsZ8HIlR6hILtzx7Jaefq1He
         pDq9rHJW5YRRifdpsVQg07PHF/JTGJLkrOgrIeS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.250
Date:   Sat,  9 Oct 2021 14:38:49 +0200
Message-Id: <163378313021875@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.250 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 arch/sparc/lib/iomap.c            |    2 ++
 drivers/ata/libata-core.c         |   34 ++++++++++++++++++++++++++++++++--
 drivers/net/phy/mdio_device.c     |   11 +++++++++++
 drivers/net/xen-netback/netback.c |    2 +-
 drivers/scsi/sd.c                 |    9 +++++----
 drivers/scsi/ses.c                |   22 ++++++++++++++++++----
 drivers/usb/dwc2/hcd.c            |    4 ++++
 fs/ext2/balloc.c                  |   14 ++++++--------
 include/linux/libata.h            |    1 +
 include/linux/mdio.h              |    3 +++
 include/linux/timerqueue.h        |   13 ++++++-------
 lib/timerqueue.c                  |   30 ++++++++++++------------------
 tools/usb/testusb.c               |   14 ++++++++------
 14 files changed, 110 insertions(+), 51 deletions(-)

Dan Carpenter (1):
      ext2: fix sleeping in atomic bugs on error

Davidlohr Bueso (1):
      lib/timerqueue: Rely on rbtree semantics for next timer

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Greg Kroah-Hartman (1):
      Linux 4.14.250

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Linus Torvalds (1):
      sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

Vladimir Oltean (1):
      net: mdio: introduce a shutdown method to mdio device drivers

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Yang Yingliang (1):
      usb: dwc2: check return value after calling platform_get_resource()

