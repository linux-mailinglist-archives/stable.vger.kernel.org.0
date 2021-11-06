Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FAA446E1D
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhKFNmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhKFNmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 09:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B8DD611C0;
        Sat,  6 Nov 2021 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636206009;
        bh=JXCTGd5LiOUrMXxjRBCUHWYF1WKzAEwpr/dXe+uNOmg=;
        h=From:To:Cc:Subject:Date:From;
        b=IUg+ZXrm3j13dDkBxZTz1jeY/ru8FuAn5Os7ghqnKJ01o1Yyxe6qkExBRqBCTnald
         MZ0qXe7L6TmSVvV7493OVl1lPctIR0n4BdOlePzUmdXjE+RSHPWrEG7k/Y2bAHb6tY
         M2B1mNuoSjKOdddg7JSAOtx6KdhvttVAtRb7A1p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.158
Date:   Sat,  6 Nov 2021 14:39:57 +0100
Message-Id: <16362059981340@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.158 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 drivers/amba/bus.c                            |    3 --
 drivers/gpu/drm/ttm/ttm_bo_util.c             |    1 
 drivers/media/firewire/firedtv-avc.c          |   14 +++++++++---
 drivers/media/firewire/firedtv-ci.c           |    2 +
 drivers/net/ethernet/microchip/lan743x_main.c |   10 +++++---
 drivers/net/ethernet/sfc/ethtool.c            |   10 +-------
 drivers/net/vrf.c                             |    4 ---
 drivers/scsi/scsi.c                           |    4 ++-
 drivers/scsi/scsi_sysfs.c                     |    9 ++++++++
 drivers/usb/core/hcd.c                        |   29 +++++---------------------
 drivers/usb/host/xhci.c                       |    1 
 include/linux/usb/hcd.h                       |    2 -
 13 files changed, 40 insertions(+), 51 deletions(-)

Dan Carpenter (1):
      media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Erik Ekman (1):
      sfc: Fix reading non-legacy supported link modes

Eugene Crosser (1):
      vrf: Revert "Reset skb conntrack connection..."

Greg Kroah-Hartman (4):
      Revert "xhci: Set HCD flag to defer primary roothub registration"
      Revert "usb: core: hcd: Add support for deferring roothub registration"
      Revert "drm/ttm: fix memleak in ttm_transfered_destroy"
      Linux 5.4.158

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Yuiko Oshino (1):
      net: ethernet: microchip: lan743x: Fix skb allocation failure

