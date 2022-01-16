Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAF48FBB5
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiAPIfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:35:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60790 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiAPIfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:35:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 761DEB80CDD;
        Sun, 16 Jan 2022 08:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D0EC36AE3;
        Sun, 16 Jan 2022 08:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642322139;
        bh=oDzK3pmMqY5Ti7b896/IhDxA94kEawJPV4BMtSdU0YM=;
        h=From:To:Cc:Subject:Date:From;
        b=RofeMBhx+0aoF6Ydm4khLUzHDbKIOnSPm+hj5VIYCuZY94EyibuBTythjKF1P7fpC
         NJHWSM2thZicyQxfwIvUymC1R8JG3qUHc0n5nkI7XUjLMLk5ab7h/r0ahYcl3EeLDx
         7lLeMpIypY6oS/Fj2ryI5Qr2f652EmoNgvIvY4HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.92
Date:   Sun, 16 Jan 2022 09:35:35 +0100
Message-Id: <164232213518208@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.92 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/boot/dts/exynos4210-i9100.dts   |    2 
 drivers/bluetooth/bfusb.c                |    3 
 drivers/bluetooth/btusb.c                |   22 +++++
 drivers/char/random.c                    |  117 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |    6 -
 drivers/md/md.c                          |   57 +++------------
 drivers/md/md.h                          |    1 
 drivers/media/usb/uvc/uvc_driver.c       |    7 -
 drivers/mfd/intel-lpss-acpi.c            |    7 +
 drivers/mmc/host/sdhci-pci-core.c        |    1 
 drivers/mmc/host/sdhci-pci.h             |    1 
 drivers/net/can/usb/gs_usb.c             |    5 +
 drivers/net/veth.c                       |    1 
 drivers/net/wireless/ath/ath11k/wmi.c    |    6 -
 drivers/staging/greybus/audio_topology.c |   92 +++++++++++-------------
 drivers/staging/wlan-ng/hfa384x_usb.c    |   22 ++---
 drivers/usb/core/hcd.c                   |    9 ++
 drivers/usb/core/hub.c                   |    2 
 kernel/bpf/verifier.c                    |    6 -
 kernel/workqueue.c                       |    9 ++
 net/can/isotp.c                          |    4 -
 22 files changed, 206 insertions(+), 176 deletions(-)

Aaron Ma (2):
      Bluetooth: btusb: Add support for Foxconn MT7922A
      Bluetooth: btusb: Add support for Foxconn QCA 0xe0d0

Adrian Hunter (1):
      mmc: sdhci-pci: Add PCI ID for Intel ADL

Alan Stern (2):
      USB: core: Fix bug in resuming hub's handling of wakeup requests
      USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Andy Shevchenko (1):
      mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Arnd Bergmann (1):
      staging: greybus: fix stack size warning with UBSAN

Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Daniel Borkmann (2):
      bpf: Fix out of bounds access from invalid *_or_null type verification
      veth: Do not record rx queue hint in veth_xmit

Dominik Brodowski (1):
      random: fix crash on multiple early calls to add_bootloader_randomness()

Eric Biggers (2):
      random: fix data race on crng_node_pool
      random: fix data race on crng init time

Frederic Weisbecker (1):
      workqueue: Fix unbind_workers() VS wq_worker_running() race

Greg Kroah-Hartman (1):
      Linux 5.10.92

Guoqing Jiang (1):
      md: revert io stats accounting

Johan Hovold (1):
      Bluetooth: bfusb: fix division by zero in send path

Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: isotp: convert struct tpcon::{idx,len} to unsigned int

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Nathan Chancellor (2):
      staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Paul Cercueil (1):
      ARM: dts: exynos: Fix BCM4330 Bluetooth reset polarity in I9100

Ricardo Ribalda (1):
      media: Revert "media: uvcvideo: Set unique vdev name based in type"

Sven Eckelmann (1):
      ath11k: Fix buffer overflow when scanning with extraie

Zijun Hu (1):
      Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

