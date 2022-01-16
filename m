Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C041348FBB9
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 09:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiAPIfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 03:35:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33160 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbiAPIfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 03:35:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C171E60DD0;
        Sun, 16 Jan 2022 08:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C6AC36AE3;
        Sun, 16 Jan 2022 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642322147;
        bh=BaAJM9at3qMT4CkDKcH6wEbStJCfP4loGONEhMz8hNk=;
        h=From:To:Cc:Subject:Date:From;
        b=X9OZrVtIh0mturNUl1I6VgXW2ekiNBxwjLEPrCi5uoXY3KyiafdK4h0CFlhylohh8
         g9pbXkPPefiFcdZyuQ2cnQ5dd40xXQouXtAu4FJOmPQYj6tCPke4dyqrsNoXyqg3em
         1N8POCPjDdxGPk1dlSO3WljwAD19bXSBep1RbwmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.172
Date:   Sun, 16 Jan 2022 09:35:40 +0100
Message-Id: <164232214025192@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.172 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 drivers/base/arch_topology.c             |    2 
 drivers/base/cacheinfo.c                 |   18 ++--
 drivers/base/core.c                      |    8 +-
 drivers/base/cpu.c                       |   39 ++++------
 drivers/base/firmware_loader/fallback.c  |    2 
 drivers/base/memory.c                    |   24 +++---
 drivers/base/node.c                      |   28 +++----
 drivers/base/platform.c                  |    2 
 drivers/base/power/sysfs.c               |   50 ++++++-------
 drivers/base/power/wakeup_stats.c        |   12 +--
 drivers/base/soc.c                       |   10 +-
 drivers/bluetooth/bfusb.c                |    3 
 drivers/bluetooth/btusb.c                |    5 +
 drivers/char/random.c                    |  118 ++++++++++++++++++-------------
 drivers/gpu/drm/i915/intel_pm.c          |    6 -
 drivers/media/usb/uvc/uvc_driver.c       |    7 -
 drivers/mfd/intel-lpss-acpi.c            |    7 +
 drivers/mmc/host/sdhci-pci-core.c        |    1 
 drivers/mmc/host/sdhci-pci.h             |    1 
 drivers/net/can/usb/gs_usb.c             |    5 +
 drivers/net/veth.c                       |    1 
 drivers/staging/greybus/audio_topology.c |   92 +++++++++++-------------
 drivers/staging/wlan-ng/hfa384x_usb.c    |   22 ++---
 drivers/usb/core/hcd.c                   |    9 ++
 drivers/usb/core/hub.c                   |    2 
 kernel/workqueue.c                       |    9 ++
 27 files changed, 264 insertions(+), 221 deletions(-)

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

Daniel Borkmann (1):
      veth: Do not record rx queue hint in veth_xmit

Dominik Brodowski (1):
      random: fix crash on multiple early calls to add_bootloader_randomness()

Eric Biggers (2):
      random: fix data race on crng_node_pool
      random: fix data race on crng init time

Frederic Weisbecker (1):
      workqueue: Fix unbind_workers() VS wq_worker_running() race

Greg Kroah-Hartman (1):
      Linux 5.4.172

Joe Perches (1):
      drivers core: Use sysfs_emit and sysfs_emit_at for show(device *...) functions

Johan Hovold (1):
      Bluetooth: bfusb: fix division by zero in send path

Marc Kleine-Budde (1):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Nathan Chancellor (2):
      staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Ricardo Ribalda (1):
      media: Revert "media: uvcvideo: Set unique vdev name based in type"

