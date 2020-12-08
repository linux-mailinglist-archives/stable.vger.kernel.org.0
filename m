Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4362D267A
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 09:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgLHImQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 03:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgLHImQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 03:42:16 -0500
Subject: patch "USB: add RESET_RESUME quirk for Snapscan 1212" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607416890;
        bh=ELrYeSkTU4+X5NEszurV5D0penMJ6lvSIRDAJMeUmGw=;
        h=To:From:Date:From;
        b=0OnylfwvsU/HeH0IWeJ7q4mPeRPo5jcQ9JOpXxyRDWyQ7iVWKFVuyze3ecsaXqi98
         XTCj8PxmASBtmOjmbZ3KIPRvgDVP6VilKLqC5afH1nV+Sgvk4OMUvKAshdinsPqSem
         yYesYLUpWspuzjJ5WOZk88L9pQVMNFGwY/NUmC8g=
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Dec 2020 09:42:16 +0100
Message-ID: <1607416936167246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: add RESET_RESUME quirk for Snapscan 1212

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 08a02f954b0def3ada8ed6d4b2c7bcb67e885e9c Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Mon, 7 Dec 2020 14:03:23 +0100
Subject: USB: add RESET_RESUME quirk for Snapscan 1212

I got reports that some models of this old scanner need
this when using runtime PM.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201207130323.23857-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index fad31ccd1fa8..1b4eb7046b07 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -342,6 +342,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Agfa SNAPSCAN 1212U */
+	{ USB_DEVICE(0x06bd, 0x0001), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Guillemot Webcam Hercules Dualpix Exchange (2nd ID) */
 	{ USB_DEVICE(0x06f8, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.29.2


