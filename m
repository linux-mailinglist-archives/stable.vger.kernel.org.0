Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD9348E595
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiANITO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiANISv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766C861E04;
        Fri, 14 Jan 2022 08:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32070C36AEA;
        Fri, 14 Jan 2022 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148329;
        bh=PBmPg2LRVyezLsF5SMi/kqQuDjuSUHIZIMuG0gn4TGg=;
        h=From:To:Cc:Subject:Date:From;
        b=hTEM0tPhzACZiMUjzsNcJDs6+c9CfB+Xr9kGtlWxgTqzxWxCSkwIyMH3v28qC8bQ5
         Vv6PsRSNz7Y9cYaLg0rJxRfzJTS4gWjalrR7qKsImmweTgMbhngawldTOW1Vui/IeA
         BfEP578IwIPGg6RvPWu5o1NupiG30yfPPXakjZPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 00/25] 5.10.92-rc1 review
Date:   Fri, 14 Jan 2022 09:16:08 +0100
Message-Id: <20220114081542.698002137@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.92-rc1
X-KernelTest-Deadline: 2022-01-16T08:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.92 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.92-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.92-rc1

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
    can: isotp: convert struct tpcon::{idx,len} to unsigned int

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Daniel Borkmann <daniel@iogearbox.net>
    veth: Do not record rx queue hint in veth_xmit

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add PCI ID for Intel ADL

Sven Eckelmann <sven@narfation.org>
    ath11k: Fix buffer overflow when scanning with extraie

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug in resuming hub's handling of wakeup requests

Paul Cercueil <paul@crapouillou.net>
    ARM: dts: exynos: Fix BCM4330 Bluetooth reset polarity in I9100

Johan Hovold <johan@kernel.org>
    Bluetooth: bfusb: fix division by zero in send path

Aaron Ma <aaron.ma@canonical.com>
    Bluetooth: btusb: Add support for Foxconn QCA 0xe0d0

Aaron Ma <aaron.ma@canonical.com>
    Bluetooth: btusb: Add support for Foxconn MT7922A

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

Mark-YW.Chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix out of bounds access from invalid *_or_null type verification

Frederic Weisbecker <frederic@kernel.org>
    workqueue: Fix unbind_workers() VS wq_worker_running() race

Guoqing Jiang <jgq516@gmail.com>
    md: revert io stats accounting


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/arm/boot/dts/exynos4210-i9100.dts   |   2 +-
 drivers/bluetooth/bfusb.c                |   3 +
 drivers/bluetooth/btusb.c                |  22 ++++++
 drivers/char/random.c                    | 117 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |   6 +-
 drivers/md/md.c                          |  57 ++++-----------
 drivers/md/md.h                          |   1 -
 drivers/media/usb/uvc/uvc_driver.c       |   7 +-
 drivers/mfd/intel-lpss-acpi.c            |   7 +-
 drivers/mmc/host/sdhci-pci-core.c        |   1 +
 drivers/mmc/host/sdhci-pci.h             |   1 +
 drivers/net/can/usb/gs_usb.c             |   5 +-
 drivers/net/veth.c                       |   1 -
 drivers/net/wireless/ath/ath11k/wmi.c    |   6 +-
 drivers/staging/greybus/audio_topology.c |  92 ++++++++++++------------
 drivers/staging/wlan-ng/hfa384x_usb.c    |  22 +++---
 drivers/usb/core/hcd.c                   |   9 ++-
 drivers/usb/core/hub.c                   |   2 +-
 kernel/bpf/verifier.c                    |   6 +-
 kernel/workqueue.c                       |   9 +++
 net/can/isotp.c                          |   4 +-
 22 files changed, 207 insertions(+), 177 deletions(-)


