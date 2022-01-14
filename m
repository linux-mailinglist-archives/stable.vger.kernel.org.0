Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23C448E55B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbiANIRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56990 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239545AbiANIR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3387D61E0B;
        Fri, 14 Jan 2022 08:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6993C36AEA;
        Fri, 14 Jan 2022 08:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148247;
        bh=dIAyJ7ksfsYooApI+MjRUtMhL+KgNp2aLQ1inv/+wi4=;
        h=From:To:Cc:Subject:Date:From;
        b=IiGUnBX7uf5wg3tMPxiZECFUjXHd4ShCDaQH4LsF/nIf0ATKWIfFSwfLvxIPPxZfM
         kWEhCp1t+FuS2csstTZYzk09GC1rRgfJu2ziiskludA988R4PYYlcGHiZgFZ/2Eyhk
         7ewEOZ70hB4EtWWbA1YprUvgzTeruU3x0m/9l7Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/18] 5.4.172-rc1 review
Date:   Fri, 14 Jan 2022 09:16:07 +0100
Message-Id: <20220114081541.465841464@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.172-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.172-rc1
X-KernelTest-Deadline: 2022-01-16T08:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.172 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.172-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.172-rc1

Arnd Bergmann <arnd@arndb.de>
    staging: greybus: fix stack size warning with UBSAN

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Nathan Chancellor <nathan@kernel.org>
    staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()

Ricardo Ribalda <ribalda@chromium.org>
    media: Revert "media: uvcvideo: Set unique vdev name based in type"

Dominik Brodowski <linux@dominikbrodowski.net>
    random: fix crash on multiple early calls to add_bootloader_randomness()

Eric Biggers <ebiggers@google.com>
    random: fix data race on crng init time

Eric Biggers <ebiggers@google.com>
    random: fix data race on crng_node_pool

Brian Silverman <brian.silverman@bluerivertech.com>
    can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data

Joe Perches <joe@perches.com>
    drivers core: Use sysfs_emit and sysfs_emit_at for show(device *...) functions

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Daniel Borkmann <daniel@iogearbox.net>
    veth: Do not record rx queue hint in veth_xmit

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add PCI ID for Intel ADL

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug in resuming hub's handling of wakeup requests

Johan Hovold <johan@kernel.org>
    Bluetooth: bfusb: fix division by zero in send path

Mark-YW.Chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Frederic Weisbecker <frederic@kernel.org>
    workqueue: Fix unbind_workers() VS wq_worker_running() race


-------------

Diffstat:

 Makefile                                 |   4 +-
 drivers/base/arch_topology.c             |   2 +-
 drivers/base/cacheinfo.c                 |  18 ++---
 drivers/base/core.c                      |   8 +--
 drivers/base/cpu.c                       |  39 +++++-----
 drivers/base/firmware_loader/fallback.c  |   2 +-
 drivers/base/memory.c                    |  24 +++----
 drivers/base/node.c                      |  28 ++++----
 drivers/base/platform.c                  |   2 +-
 drivers/base/power/sysfs.c               |  50 ++++++-------
 drivers/base/power/wakeup_stats.c        |  12 ++--
 drivers/base/soc.c                       |  10 +--
 drivers/bluetooth/bfusb.c                |   3 +
 drivers/bluetooth/btusb.c                |   5 ++
 drivers/char/random.c                    | 118 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |   6 +-
 drivers/media/usb/uvc/uvc_driver.c       |   7 +-
 drivers/mfd/intel-lpss-acpi.c            |   7 +-
 drivers/mmc/host/sdhci-pci-core.c        |   1 +
 drivers/mmc/host/sdhci-pci.h             |   1 +
 drivers/net/can/usb/gs_usb.c             |   5 +-
 drivers/net/veth.c                       |   1 -
 drivers/staging/greybus/audio_topology.c |  92 ++++++++++++------------
 drivers/staging/wlan-ng/hfa384x_usb.c    |  22 +++---
 drivers/usb/core/hcd.c                   |   9 ++-
 drivers/usb/core/hub.c                   |   2 +-
 kernel/workqueue.c                       |   9 +++
 27 files changed, 265 insertions(+), 222 deletions(-)


