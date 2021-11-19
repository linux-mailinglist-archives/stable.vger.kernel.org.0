Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318164575E2
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbhKSRmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhKSRmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D513611BF;
        Fri, 19 Nov 2021 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343570;
        bh=2YVwLPmZGWZb3ezW1upsHby5OLwNjv77Vg58smY/6fw=;
        h=From:To:Cc:Subject:Date:From;
        b=a3I5XL19G/8GFRk3gbpYc7EgXnvNb8oRXpAO2RFa28VdCAxZ7Hf4t7jrhuh3bNnfa
         TBvjnpM/ywXYrPGTErW8spWPPqhHziYST+uFrJRCyAIaYaDRLks2j+AirsYVkmg3qy
         5cCzqGzv4XyHzF16OX4LP/fxBrkFe/SWntKn/gI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/15] 5.14.21-rc1 review
Date:   Fri, 19 Nov 2021 18:38:33 +0100
Message-Id: <20211119171443.724340448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.21-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.21-rc1
X-KernelTest-Deadline: 2021-11-21T17:14+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--------------------

Note, this will be the LAST 5.14.y kernel release.  After this one it
will be marked end-of-life.  Please move to the 5.15.y tree at this
point in time.

--------------------

This is the start of the stable review cycle for the 5.14.21 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.21-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.21-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: scan: Release PM resources blocked by unused objects"

Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
    thermal: Fix NULL pointer dereferences in of_thermal_ functions

Greg Thelen <gthelen@google.com>
    perf/core: Avoid put_page() when GUP fails

Marc Zyngier <maz@kernel.org>
    PCI: Add MSI masking quirk for Nvidia ION AHCI

Marc Zyngier <maz@kernel.org>
    PCI/MSI: Deal with devices lying about their MSI mask capability

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Destroy sysfs before freeing entries

Sven Schnelle <svens@stackframe.org>
    parisc/entry: fix trace test in syscall exit path

Nicholas Flintham <nick@flinny.org>
    Bluetooth: btusb: Add support for TP-Link UB500 Adapter

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: init: Fix memblock leak in xbc_make_cmdline()

Xie Yongji <xieyongji@bytedance.com>
    loop: Use blk_validate_block_size() to validate block size

Xie Yongji <xieyongji@bytedance.com>
    block: Add a helper to validate the block size

Kees Cook <keescook@chromium.org>
    fortify: Explicitly disable Clang support

David Woodhouse <dwmw@amazon.co.uk>
    KVM: Fix steal time asm constraints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm: fb_helper: fix CONFIG_FB dependency"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm: fb_helper: improve CONFIG_FB dependency"


-------------

Diffstat:

 Makefile                     |  4 ++--
 arch/parisc/kernel/entry.S   |  2 +-
 arch/x86/kvm/x86.c           |  6 +++---
 drivers/acpi/glue.c          | 25 -------------------------
 drivers/acpi/internal.h      |  1 -
 drivers/acpi/scan.c          |  6 ------
 drivers/block/loop.c         | 17 ++---------------
 drivers/bluetooth/btusb.c    |  4 ++++
 drivers/gpu/drm/Kconfig      |  5 +++--
 drivers/pci/msi.c            | 27 +++++++++++++++------------
 drivers/pci/quirks.c         |  6 ++++++
 drivers/thermal/thermal_of.c |  9 ++++++---
 include/linux/blkdev.h       |  8 ++++++++
 include/linux/pci.h          |  2 ++
 init/main.c                  |  1 +
 kernel/events/core.c         | 10 +++++-----
 security/Kconfig             |  3 +++
 17 files changed, 61 insertions(+), 75 deletions(-)


