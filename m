Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21239318B1E
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 13:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhBKMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 07:46:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhBKMoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 07:44:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B777964E2E;
        Thu, 11 Feb 2021 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613047407;
        bh=bmtOUEqZjCpdhFNwpKPoJgm3UqXxQboTZWdSdoIRZ/w=;
        h=Subject:To:From:Date:From;
        b=yrlZkELGHuJ48TiQfQVl8lEElGsusSrqhpSLKqKDi0G1UbQ9WGwxmbA83cWOlAwFs
         75bkR62v7gphm+mdzJB5TQLOc4k9pAjikx5n0IR3LJBEj4qfn7AbnUI/nVXJ3AnPnM
         NpYda3HtmiaMM5ep4Yw4/hKrAbODApXRVuZ1NdlQ=
Subject: patch "usb: quirks: add quirk to start video capture on ELMO L-12F document" added to usb-next
To:     stefan.ursella@wolfvision.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Feb 2021 13:42:00 +0100
Message-ID: <16130473202323@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


