Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59FE2FB91A
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395430AbhASOTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbhASNUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 08:20:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA64C20644;
        Tue, 19 Jan 2021 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611061857;
        bh=eGk4X1b+O7jN5X1PqotXy9ziqVx9lk3giDhOH9rXxnA=;
        h=Subject:To:From:Date:From;
        b=Wlf4YAQidA7bCb6TmWmE6nLRrt++brJyqsj8Tns6j8im627Xe0mytcGV9AhaGnIem
         9ETG107GKFgqN0wb8ht/vmJWuz7Usay+Uf+J0z7UvPFZ9rCMU1jQyz5Lmc6ih9EWwB
         Gh9xgT9R3SWKnnnSHILJOMJhCWY06y33iPqR0DGw=
Subject: patch "usb: bdc: Make bdc pci driver depend on BROKEN" added to usb-linus
To:     patrik.r.jakobsson@gmail.com, alcooperx@gmail.com,
        balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 19 Jan 2021 14:10:54 +0100
Message-ID: <1611061854113147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: bdc: Make bdc pci driver depend on BROKEN

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ef02684c4e67d8c35ac83083564135bc7b1d3445 Mon Sep 17 00:00:00 2001
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Date: Mon, 18 Jan 2021 21:36:15 +0100
Subject: usb: bdc: Make bdc pci driver depend on BROKEN

The bdc pci driver is going to be removed due to it not existing in the
wild. This patch turns off compilation of the driver so that stable
kernels can also pick up the change. This helps the out-of-tree
facetimehd webcam driver as the pci id conflicts with bdc.

Cc: Al Cooper <alcooperx@gmail.com>
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://lore.kernel.org/r/20210118203615.13995-1-patrik.r.jakobsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bdc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/bdc/Kconfig b/drivers/usb/gadget/udc/bdc/Kconfig
index 3e88c7670b2e..fb01ff47b64c 100644
--- a/drivers/usb/gadget/udc/bdc/Kconfig
+++ b/drivers/usb/gadget/udc/bdc/Kconfig
@@ -17,7 +17,7 @@ if USB_BDC_UDC
 comment "Platform Support"
 config	USB_BDC_PCI
 	tristate "BDC support for PCIe based platforms"
-	depends on USB_PCI
+	depends on USB_PCI && BROKEN
 	default USB_BDC_UDC
 	help
 		Enable support for platforms which have BDC connected through PCIe, such as Lego3 FPGA platform.
-- 
2.30.0


