Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059D84279E9
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 13:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244784AbhJIMBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 08:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhJIMBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 08:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDE160F70;
        Sat,  9 Oct 2021 11:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633780779;
        bh=6svTyHT6tF5UtMF4hFWcBmqnMCfPX1OfHw7wW6t7bPM=;
        h=From:To:Cc:Subject:Date:From;
        b=oBvEZbYP+vOUBLh0ealCUsOLIZ7kaD+ahSGP018vyIPWhOOu8pgYiACcU3DKZk2Tg
         jrMM9ZQX1ru9LtPYqki4IDmUzEX0mLL//Nz4uc41bIn8Rs5uCtwLHBpc7jKhK+ZB55
         D2eyHRJrpkFI3nMuSsU8ZldS6W/AeJb2StssuBDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.288
Date:   Sat,  9 Oct 2021 13:59:35 +0200
Message-Id: <163378077523426@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.288 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 arch/sparc/lib/iomap.c            |    2 ++
 drivers/ata/libata-core.c         |   34 ++++++++++++++++++++++++++++++++--
 drivers/net/xen-netback/netback.c |    2 +-
 drivers/scsi/sd.c                 |    9 +++++----
 fs/ext2/balloc.c                  |   14 ++++++--------
 include/linux/libata.h            |    1 +
 include/net/sock.h                |    2 ++
 net/core/sock.c                   |   12 +++++++++---
 net/unix/af_unix.c                |   34 ++++++++++++++++++++++++++++------
 tools/usb/testusb.c               |   14 ++++++++------
 11 files changed, 95 insertions(+), 31 deletions(-)

Dan Carpenter (1):
      ext2: fix sleeping in atomic bugs on error

Eric Dumazet (1):
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Faizel K B (1):
      usb: testusb: Fix for showing the connection speed

Greg Kroah-Hartman (1):
      Linux 4.4.288

Jan Beulich (1):
      xen-netback: correct success/error reporting for the SKB-with-fraglist case

Kate Hsuan (1):
      libata: Add ATA_HORKAGE_NO_NCQ_ON_ATI for Samsung 860 and 870 SSD.

Linus Torvalds (1):
      sparc64: fix pci_iounmap() when CONFIG_PCI is not set

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

