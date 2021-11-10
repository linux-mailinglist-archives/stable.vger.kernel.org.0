Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19644C78D
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhKJSwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:52:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233206AbhKJSun (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:50:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9842D60FC2;
        Wed, 10 Nov 2021 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570033;
        bh=rOELypSd6cQi+dmsFMG5VA5EvKDnDLOwZtu53DIgSh8=;
        h=From:To:Cc:Subject:Date:From;
        b=S1ptYucYeHTT74VEe6rf1Tlobpzgx79QIngrP2oMBW1GMMjzCiwj51OG7zNPaNn/Q
         Ie08BJxXETVDe0znePTITYSEJ96is6N9p8kmLPwQ00bFAYDO8Ro/AXOQOzociNsE41
         dqv4IZ9ftID1ypQb6CU13c9DQfzQSOU/NurSBzyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/16] 4.19.217-rc1 review
Date:   Wed, 10 Nov 2021 19:43:33 +0100
Message-Id: <20211110182001.994215976@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.217-rc1
X-KernelTest-Deadline: 2021-11-12T18:20+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.217 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.217-rc1

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

Neal Liu <neal_liu@aspeedtech.com>
    usb: ehci: handshake CMD_RUN instead of STS_HALT

Juergen Gross <jgross@suse.com>
    Revert "x86/kvm: fix vcpu-id indexed array sizes"

Ming Lei <ming.lei@redhat.com>
    block: introduce multi-page bvec helpers


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/x86/kvm/ioapic.c                       |   2 +-
 arch/x86/kvm/ioapic.h                       |   4 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   2 +-
 drivers/staging/comedi/drivers/dt9812.c     | 115 +++++++++++++++++++++-------
 drivers/staging/comedi/drivers/ni_usb6501.c |  10 +++
 drivers/staging/comedi/drivers/vmk80xx.c    |  28 +++----
 drivers/staging/rtl8192u/r8192U_core.c      |  18 ++---
 drivers/staging/rtl8712/usb_ops_linux.c     |   2 +-
 drivers/usb/gadget/udc/Kconfig              |   1 +
 drivers/usb/host/ehci-hcd.c                 |  11 ++-
 drivers/usb/host/ehci-platform.c            |   6 ++
 drivers/usb/host/ehci.h                     |   1 +
 drivers/usb/musb/musb_gadget.c              |   4 +-
 drivers/usb/storage/unusual_devs.h          |  10 +++
 fs/isofs/inode.c                            |   2 +
 include/linux/bvec.h                        |  30 +++++++-
 kernel/printk/printk.c                      |   9 ++-
 18 files changed, 195 insertions(+), 64 deletions(-)


