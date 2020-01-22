Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D312F144E5C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgAVJNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVJNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:13:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E98BA24655;
        Wed, 22 Jan 2020 09:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579684396;
        bh=eF7fYS9TPlbHskC5S9fH+9tgOMrA/DTU1Y5OMIzQXkQ=;
        h=Subject:To:From:Date:From;
        b=AVouckIfY4KEndLskEZTjM9ntzRHH3YAdEjlDNJcoNWzSOgg/lGTDali9PxbQfDCm
         ssMvSxsYpR9STGLP9MgFBvIdm1GGNBpdmdHBe8eOhWP6ShY5mTufmu0D23Jce09cPr
         hIhXr+7UGaK6k+14b2/onpdcGOAas+dLaDj+miQ8=
Subject: patch "usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186" added to usb-testing
To:     pbrobinson@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, treding@nvidia.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 22 Jan 2020 10:13:14 +0100
Message-ID: <1579684394184195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e1f236efd9c579a29d7df75aa052127d0d975267 Mon Sep 17 00:00:00 2001
From: Peter Robinson <pbrobinson@gmail.com>
Date: Mon, 20 Jan 2020 14:19:10 +0000
Subject: usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

Set the MODULE_FIRMWARE for tegra186, it's registered for 124/210 and
ensures the firmware is available at the appropriate time such as in
the initrd, else if the firmware is unavailable the driver fails with
the following errors:

tegra-xusb 3530000.usb: Direct firmware load for nvidia/tegra186/xusb.bin failed with error -2
tegra-xusb 3530000.usb: failed to request firmware: -2
tegra-xusb 3530000.usb: failed to load firmware: -2
tegra-xusb: probe of 3530000.usb failed with error -2

Fixes: 5f9be5f3f899 ("usb: host: xhci-tegra: Add Tegra186 XUSB support")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200120141910.116097-1-pbrobinson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 0b58ef3a7f7f..8163aefc6c6b 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1744,6 +1744,7 @@ MODULE_FIRMWARE("nvidia/tegra210/xusb.bin");
 
 static const char * const tegra186_supply_names[] = {
 };
+MODULE_FIRMWARE("nvidia/tegra186/xusb.bin");
 
 static const struct tegra_xusb_phy_type tegra186_phy_types[] = {
 	{ .name = "usb3", .num = 3, },
-- 
2.25.0


