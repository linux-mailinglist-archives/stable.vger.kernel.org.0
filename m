Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177C144C738
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhKJStV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232981AbhKJSsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:48:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4A161267;
        Wed, 10 Nov 2021 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569927;
        bh=9TYMx+t3bL9KC6j/P8eeGCa1LHGdkUfHr2YCKTYEmOA=;
        h=From:To:Cc:Subject:Date:From;
        b=TR9NDhibcD7cDKk865FKklXcCXTXvYixrQSjdFJ83uRoR+91htce+5QT7KfbEB2qK
         SjaoKYIgb81K5RlIoHSaoZ+L4BmrYrZcL+aYwLopK4wxujN4Jc/AqfkkevZG2L6S/8
         awfkubqqKBci76YJu3efrCHI45oFIuaHAW0SYD4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/22] 4.9.290-rc1 review
Date:   Wed, 10 Nov 2021 19:43:07 +0100
Message-Id: <20211110182001.579561273@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.290-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.290-rc1
X-KernelTest-Deadline: 2021-11-12T18:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.290 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.290-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.290-rc1

Johan Hovold <johan@kernel.org>
    rsi: fix control-message timeout

Johan Hovold <johan@kernel.org>
    staging: rtl8192u: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    staging: r8712u: fix control-message timeout

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix bulk and interrupt message timeouts

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix bulk-buffer overflow

Johan Hovold <johan@kernel.org>
    comedi: vmk80xx: fix transfer-buffer overflows

Johan Hovold <johan@kernel.org>
    comedi: ni_usb6501: fix NULL-deref in command paths

Johan Hovold <johan@kernel.org>
    comedi: dt9812: fix DMA buffers on stack

Jan Kara <jack@suse.cz>
    isofs: Fix out of bound access for corrupted isofs image

Petr Mladek <pmladek@suse.com>
    printk/console: Allow to disable console output by using console="" or console=null

James Buren <braewoods+lkml@braewoods.net>
    usb-storage: Add compatibility quirk flags for iODD 2531/2541

Viraj Shah <viraj.shah@linutronix.de>
    usb: musb: Balance list entry in musb_gadget_queue

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: gadget: Mark USB_FSL_QE broken on 64-bit

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/qib: Use struct_size() helper

Juergen Gross <jgross@suse.com>
    Revert "x86/kvm: fix vcpu-id indexed array sizes"

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: fix error handling code of hso_create_net_device

Andreas Kemnade <andreas@kemnade.info>
    net: hso: register netdev later to avoid a race condition

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Arnd Bergmann <arnd@arndb.de>
    arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put LLD module refcnt after SCSI device is released


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/arc/include/asm/pgtable.h              |   2 +
 arch/arm/include/asm/pgtable-2level.h       |   2 +
 arch/arm/include/asm/pgtable-3level.h       |   2 +
 arch/mips/include/asm/pgtable-32.h          |   3 +
 arch/powerpc/include/asm/pte-common.h       |   2 +
 arch/x86/include/asm/pgtable-3level_types.h |   1 +
 arch/x86/kvm/ioapic.c                       |   2 +-
 arch/x86/kvm/ioapic.h                       |   4 +-
 drivers/amba/bus.c                          |   3 -
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  35 ++++++---
 drivers/net/usb/hso.c                       |  45 +++++++----
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   2 +-
 drivers/scsi/scsi.c                         |   4 +-
 drivers/scsi/scsi_sysfs.c                   |   9 +++
 drivers/staging/comedi/drivers/dt9812.c     | 115 +++++++++++++++++++++-------
 drivers/staging/comedi/drivers/ni_usb6501.c |  10 +++
 drivers/staging/comedi/drivers/vmk80xx.c    |  28 +++----
 drivers/staging/rtl8192u/r8192U_core.c      |  18 ++---
 drivers/staging/rtl8712/usb_ops_linux.c     |   2 +-
 drivers/usb/gadget/udc/Kconfig              |   1 +
 drivers/usb/musb/musb_gadget.c              |   4 +-
 drivers/usb/storage/unusual_devs.h          |  10 +++
 fs/isofs/inode.c                            |   2 +
 include/asm-generic/pgtable.h               |  13 ++++
 kernel/printk/printk.c                      |   9 ++-
 mm/zsmalloc.c                               |  13 ++--
 27 files changed, 249 insertions(+), 96 deletions(-)


