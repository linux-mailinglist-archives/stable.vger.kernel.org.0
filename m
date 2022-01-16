Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A69848FBA2
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiAPI3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiAPI3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:29:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D319C06173E;
        Sun, 16 Jan 2022 00:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CBE660DD5;
        Sun, 16 Jan 2022 08:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2314EC36AF4;
        Sun, 16 Jan 2022 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642321743;
        bh=1gnFcmvhyvvy5OkJilpnsNlrLNpKumpVbQRG0DBG/Ng=;
        h=From:To:Cc:Subject:Date:From;
        b=C5PRW15wSs4L2j26WjHMOUTTQpXaJ+fdYFuREhNPLskJ0KHrakfVPGavTUuKF2lzY
         Ab5XVWf/bvPHJ9LjXfzL4dsytDFimAwu5JsePAElML1P7ETEtyurntPCN0tjyez0Aa
         yyOIyeQK/nfsMOueEoQLB18e+QzZsNac01Wqkxa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.15
Date:   Sun, 16 Jan 2022 09:28:56 +0100
Message-Id: <16423217374154@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.15 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/arm/boot/dts/exynos4210-i9100.dts   |    2 
 arch/s390/kernel/machine_kexec_file.c    |    4 +
 drivers/bluetooth/bfusb.c                |    3 
 drivers/bluetooth/btbcm.c                |   51 +++++++++++++
 drivers/bluetooth/btintel.c              |   20 ++---
 drivers/bluetooth/btintel.h              |    2 
 drivers/bluetooth/btusb.c                |   61 ++++++++++++++--
 drivers/char/random.c                    |  117 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |    6 -
 drivers/media/usb/uvc/uvc_driver.c       |    7 -
 drivers/mfd/intel-lpss-acpi.c            |    7 +
 drivers/mmc/host/sdhci-pci-core.c        |    1 
 drivers/mmc/host/sdhci-pci.h             |    1 
 drivers/net/can/usb/gs_usb.c             |    5 +
 drivers/net/veth.c                       |    1 
 drivers/net/wireless/ath/ath11k/wmi.c    |    6 -
 drivers/platform/x86/intel/hid.c         |    7 +
 drivers/staging/greybus/audio_topology.c |   92 +++++++++++-------------
 drivers/staging/r8188eu/core/rtw_led.c   |    1 
 drivers/staging/wlan-ng/hfa384x_usb.c    |   22 ++---
 drivers/usb/core/hcd.c                   |    9 ++
 drivers/usb/core/hub.c                   |    2 
 fs/file.c                                |   72 ++++++++++++++-----
 include/net/bluetooth/hci.h              |    9 ++
 kernel/bpf/verifier.c                    |    6 -
 kernel/workqueue.c                       |    9 ++
 net/bluetooth/hci_core.c                 |    3 
 net/can/isotp.c                          |    4 -
 29 files changed, 368 insertions(+), 164 deletions(-)

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

Alexander Egorenkov (1):
      s390/kexec: handle R_390_PLT32DBL rela in arch_kexec_apply_relocations_add()

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
      Linux 5.15.15

Johan Hovold (1):
      Bluetooth: bfusb: fix division by zero in send path

Larry Finger (2):
      Bbluetooth: btusb: Add another Bluetooth part for Realtek 8852AE
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Linus Torvalds (1):
      fget: clarify and improve __fget_files() implementation

Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: isotp: convert struct tpcon::{idx,len} to unsigned int

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Martin Kaiser (1):
      staging: r8188eu: switch the led off during deinit

Max Chou (1):
      Bluetooth: btusb: Add the new support ID for Realtek RTL8852A

Nathan Chancellor (2):
      staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

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

mark-yw.chen (3):
      Bluetooth: btusb: Add protocol for MediaTek bluetooth devices(MT7922)
      Bluetooth: btusb: Add support for IMC Networks Mediatek Chip(MT7921)
      Bluetooth: btusb: enable Mediatek to support AOSP extension

tjiang@codeaurora.org (1):
      Bluetooth: btusb: Add the new support IDs for WCN6855

