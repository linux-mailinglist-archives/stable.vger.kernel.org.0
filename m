Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EEA48E646
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240287AbiANIZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbiANIYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:24:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDB1C06135B;
        Fri, 14 Jan 2022 00:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B0FB82448;
        Fri, 14 Jan 2022 08:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01FC36AE9;
        Fri, 14 Jan 2022 08:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148570;
        bh=NMkYOV7m1yBGUTFp2ummXBf0Rc3h+fSC5Swv2FjcldQ=;
        h=From:To:Cc:Subject:Date:From;
        b=FVgLXAJEITzQRhYr9QfESvpQGkesoe0F3jIBblXZHGPmq/03gMxAo+3svV+cd18aW
         7S5Bcjp7F6g3TlrZ+juC7irsKkPTCt4t0kUJIAy82f5vCZhv3A+BTfq6XZBp3F8hDN
         m1aNhv5YF8QOU6Z+L/N0Aq0rnNTJHrvVjuWexhS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.16 00/37] 5.16.1-rc1 review
Date:   Fri, 14 Jan 2022 09:16:14 +0100
Message-Id: <20220114081544.849748488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.16.1-rc1
X-KernelTest-Deadline: 2022-01-16T08:15+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.16.1 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.16.1-rc1

Helge Deller <deller@gmx.de>
    parisc: Fix pdc_toc_pim_11 and pdc_toc_pim_20 definitions

Arnd Bergmann <arnd@arndb.de>
    staging: greybus: fix stack size warning with UBSAN

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Ricardo Ribalda <ribalda@chromium.org>
    media: Revert "media: uvcvideo: Set unique vdev name based in type"

Alex Hung <alex.hung@canonical.com>
    platform/x86/intel: hid: add quirk to support Surface Go 3

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

Orlando Chamberlain <redecorating@protonmail.com>
    mfd: intel-lpss-pci: Fix clock speed for 38a8 UART

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Daniel Borkmann <daniel@iogearbox.net>
    veth: Do not record rx queue hint in veth_xmit

Aditya Garg <gargaditya08@live.com>
    Bluetooth: btbcm: disable read tx power for MacBook Air 8,1 and 8,2

Aditya Garg <gargaditya08@live.com>
    Bluetooth: btbcm: disable read tx power for some Macs with the T2 Security chip

Aditya Garg <gargaditya08@live.com>
    Bluetooth: add quirk disabling LE Read Transmit Power

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

Tedd Ho-Jeong An <tedd.an@intel.com>
    Bluetooth: btintel: Fix broken LED quirk for legacy ROM devices

Aaron Ma <aaron.ma@canonical.com>
    Bluetooth: btusb: Add support for Foxconn MT7922A

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: btusb: Add one more Bluetooth part for WCN6855

tjiang@codeaurora.org <tjiang@codeaurora.org>
    Bluetooth: btusb: Add the new support IDs for WCN6855

mark-yw.chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: enable Mediatek to support AOSP extension

Mark-YW.Chen <mark-yw.chen@mediatek.com>
    Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

David Yang <davidcomponentone@gmail.com>
    Bluetooth: btusb: Fix application of sizeof to pointer

Larry Finger <Larry.Finger@lwfinger.net>
    Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix out of bounds access from invalid *_or_null type verification

Martin Kaiser <martin@kaiser.cx>
    staging: r8188eu: switch the led off during deinit

Frederic Weisbecker <frederic@kernel.org>
    workqueue: Fix unbind_workers() VS wq_worker_sleeping() race

Frederic Weisbecker <frederic@kernel.org>
    workqueue: Fix unbind_workers() VS wq_worker_running() race


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/arm/boot/dts/exynos4210-i9100.dts   |   2 +-
 arch/parisc/include/uapi/asm/pdc.h       |  32 ++++++---
 drivers/bluetooth/bfusb.c                |   3 +
 drivers/bluetooth/btbcm.c                |  51 ++++++++++++++
 drivers/bluetooth/btintel.c              |  20 +++---
 drivers/bluetooth/btintel.h              |   2 +-
 drivers/bluetooth/btusb.c                |  49 +++++++++++--
 drivers/char/random.c                    | 117 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |   6 +-
 drivers/media/usb/uvc/uvc_driver.c       |   7 +-
 drivers/mfd/intel-lpss-acpi.c            |   7 +-
 drivers/mfd/intel-lpss-pci.c             |   2 +-
 drivers/mmc/host/sdhci-pci-core.c        |   1 +
 drivers/mmc/host/sdhci-pci.h             |   1 +
 drivers/net/can/usb/gs_usb.c             |   5 +-
 drivers/net/veth.c                       |   1 -
 drivers/net/wireless/ath/ath11k/wmi.c    |   6 +-
 drivers/platform/x86/intel/hid.c         |   7 ++
 drivers/staging/greybus/audio_topology.c |  92 ++++++++++++------------
 drivers/staging/r8188eu/core/rtw_led.c   |   1 +
 drivers/usb/core/hcd.c                   |   9 ++-
 drivers/usb/core/hub.c                   |   2 +-
 include/net/bluetooth/hci.h              |   9 +++
 kernel/bpf/verifier.c                    |   6 +-
 kernel/workqueue.c                       |  19 +++++
 net/bluetooth/hci_core.c                 |   3 +-
 net/can/isotp.c                          |   4 +-
 28 files changed, 323 insertions(+), 145 deletions(-)


