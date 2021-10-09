Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E6427A30
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 14:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhJIMk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 08:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233139AbhJIMk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 08:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 371FB60F6C;
        Sat,  9 Oct 2021 12:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633783140;
        bh=4NumlGnm9f76//1DfX4Q74Gz6aNkl3mJVsiAskgHEh0=;
        h=From:To:Cc:Subject:Date:From;
        b=DcF3/jHQufD0wQhxDUbr9L5B4+Uu3PK7hg2JRMWU0Io4K89O5Aj0oOg1i3WGxL5VS
         8t+HEauffSxIhPRghaATxFAFDOuxbQ1AL3qhAH2DA1yX9YIl/zDzmFGz0Gr3eixomi
         /0nWSTT5VBAooTuMFXRMyPBZZc90xYhz/x1Szy3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.210
Date:   Sat,  9 Oct 2021 14:38:54 +0200
Message-Id: <16337831348850@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.210 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
 tools/testing/selftests/lib.mk    |    1 +
 tools/usb/testusb.c               |   14 ++++++++------
 tools/vm/page-types.c             |    2 +-
 16 files changed, 112 insertions(+), 52 deletions(-)

Changbin Du (1):
      tools/vm/page-types: remove dependency on opt_file for idle page tracking

Dan Carpenter (1):
      ext2: fix sleeping in atomic bugs on error

Davidlohr Bueso (1):
      lib/timerqueue: Rely on rbtree semantics for next timer

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Greg Kroah-Hartman (1):
      Linux 4.19.210

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Li Zhijian (1):
      selftests: be sure to make khdr before other targets

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

