Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB1012F6DE
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbgACKtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgACKtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 05:49:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395A521835;
        Fri,  3 Jan 2020 10:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578048539;
        bh=9mB+0xdr2OvNVq13BQJL7b7sHm20p/7UuVWVb4MO5yM=;
        h=Subject:To:From:Date:From;
        b=YO/bv9FCC3+t6p09ndl0F+P1oZEY/04j3Zr5NHmm/PDEi4ZWwMAIsCPWug+F+Rrg5
         PNXQjSc2nhmhTOTaEYCvZcwM/4a4QcJvl6fQM3GSmJuRtIPuBcIIqHolZfr3dUPK/I
         5iVMel5w7m+Qc4e1VrQrcNrE0NpJEUdJkL6rGlJM=
Subject: patch "staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21" added to staging-linus
To:     straube.linux@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jan 2020 11:48:39 +0100
Message-ID: <157804851921244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 58dcc5bf4030cab548d5c98cd4cd3632a5444d5a Mon Sep 17 00:00:00 2001
From: Michael Straube <straube.linux@gmail.com>
Date: Sat, 28 Dec 2019 15:37:25 +0100
Subject: staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

This device was added to the stand-alone driver on github.
Add it to the staging driver as well.

Link: https://github.com/lwfinger/rtl8188eu/commit/b9b537aa25a8
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191228143725.24455-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index a7cac0719b8b..b5d42f411dd8 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -37,6 +37,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
 	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
+	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */
-- 
2.24.1


