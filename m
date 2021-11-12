Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF3B44E79C
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhKLNoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231436AbhKLNoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:44:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5FA361054;
        Fri, 12 Nov 2021 13:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724481;
        bh=1EWQxxZf7Tg2OgXla/2EFmKmZUhu+4ZGI9QjyyCx0eg=;
        h=From:To:Cc:Subject:Date:From;
        b=FdfTdH3YIyQlOWt4HXowJ91iA/suCmROkgRng4CuTb2rl+OUe9LTSZ6GqaXhZAypC
         XHiuG9ur1Tp4OhHVCPe5aQAHtusYwlpcFasX7M4CfXmUSiMKRsIQI9DGR+k1Pm4Jgv
         7DyQQHoiBwd7fmxOxBEpq5r+UZQdIKflcvv88NwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.292
Date:   Fri, 12 Nov 2021 14:41:17 +0100
Message-Id: <1636724477210236@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.292 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 drivers/amba/bus.c                          |    3 
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   35 +++++---
 drivers/net/usb/hso.c                       |   45 ++++++----
 drivers/net/wireless/rsi/rsi_91x_usb.c      |    2 
 drivers/scsi/scsi.c                         |    4 
 drivers/scsi/scsi_sysfs.c                   |    9 ++
 drivers/staging/comedi/drivers/dt9812.c     |  119 ++++++++++++++++++++--------
 drivers/staging/comedi/drivers/ni_usb6501.c |   14 ++-
 drivers/staging/comedi/drivers/vmk80xx.c    |   34 ++++----
 drivers/staging/rtl8192u/r8192U_core.c      |   18 ++--
 drivers/staging/rtl8712/usb_ops_linux.c     |    2 
 drivers/usb/gadget/udc/Kconfig              |    1 
 drivers/usb/storage/unusual_devs.h          |   10 ++
 fs/isofs/inode.c                            |    2 
 kernel/printk/printk.c                      |    9 +-
 16 files changed, 217 insertions(+), 92 deletions(-)

Andreas Kemnade (1):
      net: hso: register netdev later to avoid a race condition

Cheah Kok Cheong (1):
      staging: comedi: drivers: replace le16_to_cpu() with usb_endpoint_maxp()

Dongliang Mu (1):
      usb: hso: fix error handling code of hso_create_net_device

Geert Uytterhoeven (1):
      usb: gadget: Mark USB_FSL_QE broken on 64-bit

Greg Kroah-Hartman (1):
      Linux 4.4.292

Gustavo A. R. Silva (1):
      IB/qib: Use struct_size() helper

James Buren (1):
      usb-storage: Add compatibility quirk flags for iODD 2531/2541

Jan Kara (1):
      isofs: Fix out of bound access for corrupted isofs image

Johan Hovold (8):
      comedi: dt9812: fix DMA buffers on stack
      comedi: ni_usb6501: fix NULL-deref in command paths
      comedi: vmk80xx: fix transfer-buffer overflows
      comedi: vmk80xx: fix bulk-buffer overflow
      comedi: vmk80xx: fix bulk and interrupt message timeouts
      staging: r8712u: fix control-message timeout
      staging: rtl8192u: fix control-message timeouts
      rsi: fix control-message timeout

Mike Marciniszyn (1):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Petr Mladek (1):
      printk/console: Allow to disable console output by using console="" or console=null

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

