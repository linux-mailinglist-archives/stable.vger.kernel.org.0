Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B83322C43
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhBWO3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:29:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhBWO2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:28:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B1D64E61;
        Tue, 23 Feb 2021 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614090494;
        bh=RqWadiT0Lw4YIx8v/iSEiIejGTTiI1xnnfkXzHe78UA=;
        h=From:To:Cc:Subject:Date:From;
        b=0e1s/tgEjllaLLBBpiZphNcAL4nFopszmtnbMHkJRGnnWYkH8jDADPk218CNO4OTT
         MtNHnEo0tcI2GRMQVkv9QJbU0CLPfSxw9OGVHflH6TEwZhms3BhRkKLocZId9R6n+a
         WzSyOrcJeFi9LkZLmQ+/tBdayFvJflbR05Lss8BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.100
Date:   Tue, 23 Feb 2021 15:28:07 +0100
Message-Id: <161409048718778@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.100 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 -
 arch/arm/xen/p2m.c                  |    6 +++--
 arch/x86/kvm/svm.c                  |    1 
 arch/x86/xen/p2m.c                  |   15 ++++++--------
 drivers/block/xen-blkback/blkback.c |   30 +++++++++++++++--------------
 drivers/media/usb/pwc/pwc-if.c      |   22 ++++++++++++---------
 drivers/net/xen-netback/netback.c   |    4 ---
 drivers/xen/gntdev.c                |   37 +++++++++++++++++++-----------------
 drivers/xen/xen-scsiback.c          |    4 +--
 fs/btrfs/ctree.h                    |    6 ++---
 include/xen/grant_table.h           |    1 
 net/bridge/br.c                     |    5 +++-
 net/qrtr/qrtr.c                     |    2 -
 13 files changed, 73 insertions(+), 62 deletions(-)

David Sterba (1):
      btrfs: fix backport of 2175bf57dc952 in 5.4.95

Greg Kroah-Hartman (1):
      Linux 5.4.100

Jan Beulich (8):
      Xen/x86: don't bail early from clear_foreign_p2m_mapping()
      Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
      Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
      Xen/gntdev: correct error checking in gntdev_map_grant_pages()
      xen-blkback: don't "handle" error by BUG()
      xen-netback: don't "handle" error by BUG()
      xen-scsiback: don't "handle" error by BUG()
      xen-blkback: fix error handling in xen_blkbk_map()

Loic Poulain (1):
      net: qrtr: Fix port ID for control messages

Matwey V. Kornilov (1):
      media: pwc: Use correct device for DMA

Paolo Bonzini (1):
      KVM: SEV: fix double locking due to incorrect backport

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Wang Hai (1):
      net: bridge: Fix a warning when del bridge sysfs

