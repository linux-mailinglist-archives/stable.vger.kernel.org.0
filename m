Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E3E44E873
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 15:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhKLOVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 09:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhKLOVO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 09:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0615760E9B;
        Fri, 12 Nov 2021 14:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636726703;
        bh=+Og/dAIpvbQYBOpfYkxyATUDgLnCgtUHTcdTCS4XLos=;
        h=From:To:Cc:Subject:Date:From;
        b=ncXfOCHYgBsivSa19teHeqvaKMHinYmtQENoONyOZBsx6I4+6HjU49Y8U2SuyIzrQ
         liGz9f9eIjo6hMBMhVduanXXSvo2UnvUjbN122+qb+e4uxAyygRqGW5a4z93Iiqc4R
         W18JTTMgaICQkCJ+hxuDfUVltMntQWTlNDrXrnkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.18
Date:   Fri, 12 Nov 2021 15:18:17 +0100
Message-Id: <163672669712109@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.18 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/x86/kvm/ioapic.c                    |    2 
 arch/x86/kvm/ioapic.h                    |    4 -
 arch/x86/kvm/mmu/spte.h                  |    7 -
 drivers/android/binder.c                 |   41 ++++-------
 drivers/android/binder_internal.h        |    4 +
 drivers/comedi/drivers/dt9812.c          |  115 +++++++++++++++++++++++--------
 drivers/comedi/drivers/ni_usb6501.c      |   10 ++
 drivers/comedi/drivers/vmk80xx.c         |   28 ++++---
 drivers/net/wireless/rsi/rsi_91x_usb.c   |    2 
 drivers/staging/media/ipu3/ipu3-css-fw.c |    7 -
 drivers/staging/media/ipu3/ipu3-css-fw.h |    2 
 drivers/staging/rtl8192u/r8192U_core.c   |   18 ++--
 drivers/staging/rtl8712/usb_intf.c       |    4 -
 drivers/staging/rtl8712/usb_ops_linux.c  |    2 
 drivers/usb/gadget/udc/Kconfig           |    1 
 drivers/usb/host/ehci-hcd.c              |   11 ++
 drivers/usb/host/ehci-platform.c         |    6 +
 drivers/usb/host/ehci.h                  |    1 
 drivers/usb/musb/musb_gadget.c           |    4 -
 drivers/usb/storage/unusual_devs.h       |   10 ++
 fs/isofs/inode.c                         |    2 
 fs/proc/base.c                           |   19 ++---
 include/linux/lsm_hook_defs.h            |   14 +--
 include/linux/lsm_hooks.h                |   14 +--
 include/linux/security.h                 |   33 +++++---
 security/security.c                      |   14 +--
 security/selinux/hooks.c                 |   48 +++---------
 sound/core/pcm_native.c                  |    9 +-
 sound/pci/cs46xx/cs46xx_lib.c            |   30 ++------
 30 files changed, 266 insertions(+), 198 deletions(-)

Geert Uytterhoeven (1):
      usb: gadget: Mark USB_FSL_QE broken on 64-bit

Greg Kroah-Hartman (1):
      Linux 5.14.18

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

Kees Cook (1):
      Revert "proc/wchan: use printk format instead of lookup_symbol_name()"

Neal Liu (1):
      usb: ehci: handshake CMD_RUN instead of STS_HALT

Paolo Bonzini (1):
      KVM: x86: avoid warning with -Wbitwise-instead-of-logical

Pavel Skripkin (1):
      staging: rtl8712: fix use-after-free in rtl8712_dl_fw

Takashi Iwai (2):
      ALSA: pcm: Check mmap capability of runtime dma buffer at first
      ALSA: pci: cs46xx: Fix set up buffer type properly

Todd Kjos (4):
      binder: use euid from cred instead of using task
      binder: use cred instead of task for selinux checks
      binder: use cred instead of task for getsecid
      binder: don't detect sender/target during buffer cleanup

Viraj Shah (1):
      usb: musb: Balance list entry in musb_gadget_queue

