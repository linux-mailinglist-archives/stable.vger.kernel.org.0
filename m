Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3B44E84E
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 15:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhKLORC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 09:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235127AbhKLORB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 09:17:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73E2C60F5B;
        Fri, 12 Nov 2021 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636726451;
        bh=VpBla+0dMLtszlpttJaHfMLswTc7uX1iMDX3tZY5SRY=;
        h=From:To:Cc:Subject:Date:From;
        b=1hU3Gtl/jAPGkJHJfVIQ6x/mkoX0Mt4YEmWFUnt/hI4h/PjIkAbhxSF9B15tDkISP
         Me/4kN3F27rUpwaPtduR6N0aagMjaJkMvAcWrZ6CNMWWmXBWcbQwj4QMhGqxDf7lBK
         GL9jJnrrk/Wyy9DJaZi/aDj+vv69ahMshIL9aJR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.159
Date:   Fri, 12 Nov 2021 15:13:56 +0100
Message-Id: <16367264369188@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.159 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/x86/kvm/ioapic.c                       |    2 
 arch/x86/kvm/ioapic.h                       |    4 
 drivers/android/binder.c                    |   14 +--
 drivers/net/wireless/rsi/rsi_91x_usb.c      |    2 
 drivers/staging/comedi/drivers/dt9812.c     |  115 ++++++++++++++++++++--------
 drivers/staging/comedi/drivers/ni_usb6501.c |   10 ++
 drivers/staging/comedi/drivers/vmk80xx.c    |   28 +++---
 drivers/staging/media/ipu3/ipu3-css-fw.c    |    7 -
 drivers/staging/media/ipu3/ipu3-css-fw.h    |    2 
 drivers/staging/rtl8192u/r8192U_core.c      |   18 ++--
 drivers/staging/rtl8712/usb_ops_linux.c     |    2 
 drivers/usb/gadget/udc/Kconfig              |    1 
 drivers/usb/host/ehci-hcd.c                 |   11 ++
 drivers/usb/host/ehci-platform.c            |    6 +
 drivers/usb/host/ehci.h                     |    1 
 drivers/usb/musb/musb_gadget.c              |    4 
 drivers/usb/storage/unusual_devs.h          |   10 ++
 fs/isofs/inode.c                            |    2 
 kernel/printk/printk.c                      |    9 +-
 20 files changed, 178 insertions(+), 72 deletions(-)

Geert Uytterhoeven (1):
      usb: gadget: Mark USB_FSL_QE broken on 64-bit

Greg Kroah-Hartman (1):
      Linux 5.4.159

Gustavo A. R. Silva (1):
      media: staging/intel-ipu3: css: Fix wrong size comparison imgu_css_fw_init

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

Juergen Gross (1):
      Revert "x86/kvm: fix vcpu-id indexed array sizes"

Neal Liu (1):
      usb: ehci: handshake CMD_RUN instead of STS_HALT

Petr Mladek (1):
      printk/console: Allow to disable console output by using console="" or console=null

Todd Kjos (1):
      binder: don't detect sender/target during buffer cleanup

Viraj Shah (1):
      usb: musb: Balance list entry in musb_gadget_queue

