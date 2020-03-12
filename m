Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5D6182B64
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCLIhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 04:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLIhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 04:37:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B22A206B7;
        Thu, 12 Mar 2020 08:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584002258;
        bh=Rgs+7jayyIAhT4ebr+UYdzKjnJfk8M3UPDVonsk5obQ=;
        h=Subject:To:From:Date:From;
        b=oXhyDrWxZYpOQ/Z32cyOrV6hOYQH9qhlNfRxBfqsCekh15y8m51l3IhGUoiVC8/+B
         I6z9hlvSpwT+7XBrm6HlCUoY94BHxbnweD4F1NVWAsIHFoV7oH/+XNNjYmrh4AsIX5
         qNZV2z2eUHlLZFvgCUz0PRVxQJS6uW0dhl42QFWY=
Subject: patch "usb: host: xhci-plat: add a shutdown" added to usb-linus
To:     ran.wang_1@nxp.com, gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org, swboyd@chromium.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Mar 2020 09:37:36 +0100
Message-ID: <1584002256194157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-plat: add a shutdown

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b433e340e7565110b0ce9ca4b3e26f4b97a1decf Mon Sep 17 00:00:00 2001
From: Ran Wang <ran.wang_1@nxp.com>
Date: Fri, 6 Mar 2020 17:23:28 +0800
Subject: usb: host: xhci-plat: add a shutdown

When loading new kernel via kexec, we need to shutdown host controller to
avoid any un-expected memory accessing during new kernel boot.

Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Cc: stable <stable@vger.kernel.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200306092328.41253-1-ran.wang_1@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d90cd5ec09cf..315b4552693c 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -445,6 +445,7 @@ MODULE_DEVICE_TABLE(acpi, usb_xhci_acpi_match);
 static struct platform_driver usb_xhci_driver = {
 	.probe	= xhci_plat_probe,
 	.remove	= xhci_plat_remove,
+	.shutdown = usb_hcd_platform_shutdown,
 	.driver	= {
 		.name = "xhci-hcd",
 		.pm = &xhci_plat_pm_ops,
-- 
2.25.1


