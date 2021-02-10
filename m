Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819463169A5
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 16:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBJPBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 10:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231897AbhBJPBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 10:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC9964E74;
        Wed, 10 Feb 2021 15:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612969230;
        bh=ycGQM9jkny+M5DCQWtTxQW4Z5PwfBr/4kqIkqhKDr1g=;
        h=Subject:To:From:Date:From;
        b=pu2u3s7AOPV7kuhSWL28b/1jzIFZGIpXCPc5vLEYfylQUz9x4TJJLKl4/cDcwmnxC
         88Uq1v6z0oyHbvEPGfcgKf9qbY8nuSSg8BlJOTYX2lFcJ/2PA8QIrTG5hqgfdVxpli
         +fPVBGmxwHGNHCb7F8JG05g60qyAtDMByrljR39Y=
Subject: patch "usb: quirks: add quirk to start video capture on ELMO L-12F document" added to usb-testing
To:     stefan.ursella@wolfvision.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 10 Feb 2021 15:59:33 +0100
Message-ID: <1612969173240128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: quirks: add quirk to start video capture on ELMO L-12F document

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1ebe718bb48278105816ba03a0408ecc2d6cf47f Mon Sep 17 00:00:00 2001
From: Stefan Ursella <stefan.ursella@wolfvision.net>
Date: Wed, 10 Feb 2021 15:07:11 +0100
Subject: usb: quirks: add quirk to start video capture on ELMO L-12F document
 camera reliable

Without this quirk starting a video capture from the device often fails with

kernel: uvcvideo: Failed to set UVC probe control : -110 (exp. 34).

Signed-off-by: Stefan Ursella <stefan.ursella@wolfvision.net>
Link: https://lore.kernel.org/r/20210210140713.18711-1-stefan.ursella@wolfvision.net
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 66a0dc618dfc..6ade3daf7858 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -391,6 +391,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
+	/* ELMO L-12F document camera */
+	{ USB_DEVICE(0x09a1, 0x0028), .driver_info = USB_QUIRK_DELAY_CTRL_MSG },
+
 	/* Broadcom BCM92035DGROM BT dongle */
 	{ USB_DEVICE(0x0a5c, 0x2021), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.30.1


