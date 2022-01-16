Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59448FB9E
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiAPI24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiAPI24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:28:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20942C061574;
        Sun, 16 Jan 2022 00:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF1060DCB;
        Sun, 16 Jan 2022 08:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E40C36AE7;
        Sun, 16 Jan 2022 08:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642321734;
        bh=4pBd9U9E9x+ac6tL6aHjLWgqJv6JPGT+PufgVZiSuCA=;
        h=From:To:Cc:Subject:Date:From;
        b=QOVpH+kHq1wz3fHLSsEJPFDEpFhonbrN1vPi8Viycsos3/jIRqtKHCNan0K5aHmvs
         JuGXt3xxTM5f93rQU2JBQb1JKLfqL1Nh37Qj1mTRpRjUvlLS298D1+EAOIua0xvf9H
         FRpVpn0PBVusIOTU7oyOoVVua4ZWmnMb3mjKSsAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.1
Date:   Sun, 16 Jan 2022 09:28:50 +0100
Message-Id: <1642321730215246@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.16.1 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/boot/dts/exynos4210-i9100.dts   |    2 
 arch/parisc/include/uapi/asm/pdc.h       |   32 ++++++--
 drivers/bluetooth/bfusb.c                |    3 
 drivers/bluetooth/btbcm.c                |   51 +++++++++++++
 drivers/bluetooth/btintel.c              |   20 ++---
 drivers/bluetooth/btintel.h              |    2 
 drivers/bluetooth/btusb.c                |   49 +++++++++++-
 drivers/char/random.c                    |  117 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |    6 -
 drivers/media/usb/uvc/uvc_driver.c       |    7 -
 drivers/mfd/intel-lpss-acpi.c            |    7 +
 drivers/mfd/intel-lpss-pci.c             |    2 
 drivers/mmc/host/sdhci-pci-core.c        |    1 
 drivers/mmc/host/sdhci-pci.h             |    1 
 drivers/net/can/usb/gs_usb.c             |    5 +
 drivers/net/veth.c                       |    1 
 drivers/net/wireless/ath/ath11k/wmi.c    |    6 -
 drivers/platform/x86/intel/hid.c         |    7 +
 drivers/staging/greybus/audio_topology.c |   92 +++++++++++-------------
 drivers/staging/r8188eu/core/rtw_led.c   |    1 
 drivers/usb/core/hcd.c                   |    9 ++
 drivers/usb/core/hub.c                   |    2 
 include/net/bluetooth/hci.h              |    9 ++
 kernel/bpf/verifier.c                    |    6 -
 kernel/workqueue.c                       |   19 +++++
 net/bluetooth/hci_core.c                 |    3 
 net/can/isotp.c                          |    4 -
 28 files changed, 322 insertions(+), 144 deletions(-)

Aaron Ma (2):
      Bluetooth: btusb: Add support for Foxconn MT7922A
      Bluetooth: btusb: Add support for Foxconn QCA 0xe0d0

Aditya Garg (3):
      Bluetooth: add quirk disabling LE Read Transmit Power
      Bluetooth: btbcm: disable read tx power for some Macs with the T2 Security chip
      Bluetooth: btbcm: disable read tx power for MacBook Air 8,1 and 8,2

Adrian Hunter (1):
      mmc: sdhci-pci: Add PCI ID for Intel ADL

Alan Stern (2):
      USB: core: Fix bug in resuming hub's handling of wakeup requests
      USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alex Hung (1):
      platform/x86/intel: hid: add quirk to support Surface Go 3

Andy Shevchenko (1):
      mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Arnd Bergmann (1):
      staging: greybus: fix stack size warning with UBSAN

Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Daniel Borkmann (2):
      bpf: Fix out of bounds access from invalid *_or_null type verification
      veth: Do not record rx queue hint in veth_xmit

David Yang (1):
      Bluetooth: btusb: Fix application of sizeof to pointer

Dominik Brodowski (1):
      random: fix crash on multiple early calls to add_bootloader_randomness()

Eric Biggers (2):
      random: fix data race on crng_node_pool
      random: fix data race on crng init time

Frederic Weisbecker (2):
      workqueue: Fix unbind_workers() VS wq_worker_running() race
      workqueue: Fix unbind_workers() VS wq_worker_sleeping() race

Greg Kroah-Hartman (1):
      Linux 5.16.1

Helge Deller (1):
      parisc: Fix pdc_toc_pim_11 and pdc_toc_pim_20 definitions

Johan Hovold (1):
      Bluetooth: bfusb: fix division by zero in send path

Larry Finger (1):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: isotp: convert struct tpcon::{idx,len} to unsigned int

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Martin Kaiser (1):
      staging: r8188eu: switch the led off during deinit

Nathan Chancellor (1):
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Orlando Chamberlain (1):
      mfd: intel-lpss-pci: Fix clock speed for 38a8 UART

Paul Cercueil (1):
      ARM: dts: exynos: Fix BCM4330 Bluetooth reset polarity in I9100

Ricardo Ribalda (1):
      media: Revert "media: uvcvideo: Set unique vdev name based in type"

Sven Eckelmann (1):
      ath11k: Fix buffer overflow when scanning with extraie

Tedd Ho-Jeong An (1):
      Bluetooth: btintel: Fix broken LED quirk for legacy ROM devices

Zijun Hu (2):
      Bluetooth: btusb: Add one more Bluetooth part for WCN6855
      Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

mark-yw.chen (1):
      Bluetooth: btusb: enable Mediatek to support AOSP extension

tjiang@codeaurora.org (1):
      Bluetooth: btusb: Add the new support IDs for WCN6855

