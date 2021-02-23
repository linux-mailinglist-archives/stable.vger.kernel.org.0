Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ADE322BCE
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhBWOAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBWOAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D23F64E4B;
        Tue, 23 Feb 2021 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614088791;
        bh=xrLlyLBz4iUe57fRQfL8r17GCFFYdouFFW2MZKUTqr0=;
        h=From:To:Cc:Subject:Date:From;
        b=ErU6Pc2n9iwj+1V2kP4ZcVbZejRgqLMmBEITs/4di3ydG/HBRHyNJtlDzxgqg/vFg
         g4d6nzBx6QnPGpMviZJF9IAwWmc7BhRzwsq0udelvcXVB7XAI6zXrONe/ZuPoXQr71
         KiuDA3UrWSWpLRu8mDBuzUjByBpbe7irRmf2kEMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.1
Date:   Tue, 23 Feb 2021 14:59:47 +0100
Message-Id: <1614088759150127@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.1 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 -
 arch/arm/xen/p2m.c                  |    6 +++--
 arch/x86/xen/p2m.c                  |   15 ++++++--------
 drivers/block/xen-blkback/blkback.c |   32 +++++++++++++++++--------------
 drivers/bluetooth/btusb.c           |   20 +++++--------------
 drivers/media/usb/pwc/pwc-if.c      |   22 ++++++++++++---------
 drivers/net/xen-netback/netback.c   |    4 ---
 drivers/tty/tty_io.c                |    5 +++-
 drivers/xen/gntdev.c                |   37 +++++++++++++++++++-----------------
 drivers/xen/xen-scsiback.c          |    4 +--
 include/xen/grant_table.h           |    1 
 11 files changed, 77 insertions(+), 71 deletions(-)

Greg Kroah-Hartman (1):
      Linux 5.11.1

Jan Beulich (8):
      Xen/x86: don't bail early from clear_foreign_p2m_mapping()
      Xen/x86: also check kernel mapping in set_foreign_p2m_mapping()
      Xen/gntdev: correct dev_bus_addr handling in gntdev_map_grant_pages()
      Xen/gntdev: correct error checking in gntdev_map_grant_pages()
      xen-blkback: don't "handle" error by BUG()
      xen-netback: don't "handle" error by BUG()
      xen-scsiback: don't "handle" error by BUG()
      xen-blkback: fix error handling in xen_blkbk_map()

Linus Torvalds (1):
      tty: protect tty_write from odd low-level tty disciplines

Matwey V. Kornilov (1):
      media: pwc: Use correct device for DMA

Stefano Stabellini (1):
      xen/arm: don't ignore return errors from set_phys_to_machine

Trent Piepho (1):
      Bluetooth: btusb: Always fallback to alt 1 for WBS

