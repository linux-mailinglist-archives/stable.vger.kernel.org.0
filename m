Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC8544E7A3
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbhKLNoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235087AbhKLNoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:44:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB0B61054;
        Fri, 12 Nov 2021 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724491;
        bh=YZQfxUhqVkCmi2qtXYtSrSWMDQg1aGKn/Bt9f8KjdPY=;
        h=From:To:Cc:Subject:Date:From;
        b=oV9ZhYhR8OT4VUlqi4IfWSNaqYhMYu2uKHCDAVgdew1/tL8FHP7hNG36qdnEWqHY7
         IL+/EpmTYZ5WY8NRFn9M5ONo6c1f9mI49nlmfsCiMk4qwen6KMQmfNR2ji+NGZvEWv
         G1mzKKjNXJtAWva1CgEeLybRTpET0C1ovj4ccWaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.290
Date:   Fri, 12 Nov 2021 14:41:22 +0100
Message-Id: <1636724482103131@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.290 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arc/include/asm/pgtable.h              |    2 
 arch/arm/include/asm/pgtable-2level.h       |    2 
 arch/arm/include/asm/pgtable-3level.h       |    2 
 arch/mips/include/asm/pgtable-32.h          |    3 
 arch/powerpc/include/asm/pte-common.h       |    2 
 arch/x86/include/asm/pgtable-3level_types.h |    1 
 arch/x86/kvm/ioapic.c                       |    2 
 arch/x86/kvm/ioapic.h                       |    4 
 drivers/amba/bus.c                          |    3 
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   35 ++++++--
 drivers/net/usb/hso.c                       |   45 +++++++---
 drivers/net/wireless/rsi/rsi_91x_usb.c      |    2 
 drivers/scsi/scsi.c                         |    4 
 drivers/scsi/scsi_sysfs.c                   |    9 ++
 drivers/staging/comedi/drivers/dt9812.c     |  115 ++++++++++++++++++++--------
 drivers/staging/comedi/drivers/ni_usb6501.c |   10 ++
 drivers/staging/comedi/drivers/vmk80xx.c    |   28 +++---
 drivers/staging/rtl8192u/r8192U_core.c      |   18 ++--
 drivers/staging/rtl8712/usb_ops_linux.c     |    2 
 drivers/usb/gadget/udc/Kconfig              |    1 
 drivers/usb/musb/musb_gadget.c              |    4 
 drivers/usb/storage/unusual_devs.h          |   10 ++
 fs/isofs/inode.c                            |    2 
 include/asm-generic/pgtable.h               |   13 +++
 kernel/printk/printk.c                      |    9 +-
 mm/zsmalloc.c                               |   13 +--
 27 files changed, 248 insertions(+), 95 deletions(-)

Andreas Kemnade (1):
      net: hso: register netdev later to avoid a race condition

Arnd Bergmann (1):
      arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Dongliang Mu (1):
      usb: hso: fix error handling code of hso_create_net_device

Geert Uytterhoeven (1):
      usb: gadget: Mark USB_FSL_QE broken on 64-bit

Greg Kroah-Hartman (1):
      Linux 4.9.290

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

Juergen Gross (1):
      Revert "x86/kvm: fix vcpu-id indexed array sizes"

Kirill A. Shutemov (1):
      mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS

Mike Marciniszyn (1):
      IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Petr Mladek (1):
      printk/console: Allow to disable console output by using console="" or console=null

Viraj Shah (1):
      usb: musb: Balance list entry in musb_gadget_queue

Wang Kefeng (1):
      ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

