Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031FA1FEDF8
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgFRInN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRInN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:43:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E789C2089D;
        Thu, 18 Jun 2020 08:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469792;
        bh=bcy9/SD2NuMBp1TgWOFfhzAA77K/K2R/V7rt1xjjce8=;
        h=Subject:To:From:Date:From;
        b=Xy/JVlSjJXMFQ1Ag5O2kiNi7D9DfBqIPuHSlMlRj6fLhgl6KvxchbSRhK7PhQ9SzL
         7g8VrCf1bwOkQvf9Qd2LWLQlmFwza1FnTJ9VvuIrUbUVGxmTmy1rgmSo0DMgT24kJ1
         YhT1zCr7J2i9+S4cxMY6aLe52z/WzcVvjk8bcd7s=
Subject: patch "usb: add USB_QUIRK_DELAY_INIT for Logitech C922" added to usb-linus
To:     tomasz@meresinski.eu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:43:05 +0200
Message-ID: <15924697852050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: add USB_QUIRK_DELAY_INIT for Logitech C922

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5d8021923e8a8cc37a421a64e27c7221f0fee33c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Tomasz=20Meresi=C5=84ski?= <tomasz@meresinski.eu>
Date: Wed, 3 Jun 2020 22:33:46 +0200
Subject: usb: add USB_QUIRK_DELAY_INIT for Logitech C922
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Logitech C922, just like other Logitech webcams,
needs the USB_QUIRK_DELAY_INIT or it will randomly
not respond after device connection

Signed-off-by: Tomasz Meresiński <tomasz@meresinski.eu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200603203347.7792-1-tomasz@meresinski.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3e8efe759c3e..e0b77674869c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -218,11 +218,12 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Logitech HD Webcam C270 */
 	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech HD Pro Webcams C920, C920-C, C925e and C930e */
+	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0841), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x085b), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x085c), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Logitech ConferenceCam CC3000e */
 	{ USB_DEVICE(0x046d, 0x0847), .driver_info = USB_QUIRK_DELAY_INIT },
-- 
2.27.0


