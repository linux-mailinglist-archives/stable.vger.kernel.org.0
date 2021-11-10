Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0244C708
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhKJSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232876AbhKJSrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 032C461186;
        Wed, 10 Nov 2021 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569867;
        bh=E/1F/uLSXz5eaPY9WDOyt6HffJjzlsNkefA+H1LkuRw=;
        h=From:To:Cc:Subject:Date:From;
        b=boNJnbInbQzrvOI9JaqEbzxF9pp0DWdp/XwYCJ01Eb2DezlKp/fP9pTdF1MuhHxy6
         D6PuNykL5aFBKi6Xnl9KZkWl7Q43kiS12IgET2sWbbery/xuuOnRzaawI5Ib50FQDs
         bZSv/QrlNXkhBSn6TqZyfCEV0cJuzfGXMD55B5z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/19] 4.4.292-rc1 review
Date:   Wed, 10 Nov 2021 19:43:02 +0100
Message-Id: <20211110182001.257350381@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.292-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.292-rc1
X-KernelTest-Deadline: 2021-11-12T18:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.292 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.292-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.292-rc1

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

Cheah Kok Cheong <thrust73@gmail.com>
    staging: comedi: drivers: replace le16_to_cpu() with usb_endpoint_maxp()

Johan Hovold <johan@kernel.org>
    comedi: ni_usb6501: fix NULL-deref in command paths

Johan Hovold <johan@kernel.org>
    comedi: dt9812: fix DMA buffers on stack

Jan Kara <jack@suse.cz>
    isofs: Fix out of bound access for corrupted isofs image

Dongliang Mu <mudongliangabcd@gmail.com>
    usb: hso: fix error handling code of hso_create_net_device

Petr Mladek <pmladek@suse.com>
    printk/console: Allow to disable console output by using console="" or console=null

James Buren <braewoods+lkml@braewoods.net>
    usb-storage: Add compatibility quirk flags for iODD 2531/2541

Geert Uytterhoeven <geert@linux-m68k.org>
    usb: gadget: Mark USB_FSL_QE broken on 64-bit

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields

Gustavo A. R. Silva <gustavo@embeddedor.com>
    IB/qib: Use struct_size() helper

Andreas Kemnade <andreas@kemnade.info>
    net: hso: register netdev later to avoid a race condition

Wang Kefeng <wangkefeng.wang@huawei.com>
    ARM: 9120/1: Revert "amba: make use of -1 IRQs warn"

Ming Lei <ming.lei@redhat.com>
    scsi: core: Put LLD module refcnt after SCSI device is released


-------------

Diffstat:

 Makefile                                    |   4 +-
 drivers/amba/bus.c                          |   3 -
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  35 +++++---
 drivers/net/usb/hso.c                       |  45 +++++++----
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   2 +-
 drivers/scsi/scsi.c                         |   4 +-
 drivers/scsi/scsi_sysfs.c                   |   9 +++
 drivers/staging/comedi/drivers/dt9812.c     | 119 ++++++++++++++++++++--------
 drivers/staging/comedi/drivers/ni_usb6501.c |  14 +++-
 drivers/staging/comedi/drivers/vmk80xx.c    |  34 ++++----
 drivers/staging/rtl8192u/r8192U_core.c      |  18 ++---
 drivers/staging/rtl8712/usb_ops_linux.c     |   2 +-
 drivers/usb/gadget/udc/Kconfig              |   1 +
 drivers/usb/storage/unusual_devs.h          |  10 +++
 fs/isofs/inode.c                            |   2 +
 kernel/printk/printk.c                      |   9 ++-
 16 files changed, 218 insertions(+), 93 deletions(-)


