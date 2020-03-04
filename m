Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48C3178DE5
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgCDJ6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:58:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgCDJ6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:58:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2A82072D;
        Wed,  4 Mar 2020 09:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315886;
        bh=3I91OHf0nE3LaiF7Rms0webWoel/5jTcYb2/ruCQVsE=;
        h=Subject:To:From:Date:From;
        b=pk/q87d5J4y5Hdu0IiQm7N3eMbwVYlnC3CIEBnu9vr2yI6ZKv+eX7Bv5D4R3iqBA4
         baRthr6IoL9NEGKMNnb+JxZqTpRUmOm1uC5Py7wnM0i5kmOJQDvMlpoZr4xYDGIgYQ
         FEZTijB+nwHSaqSEiHSKJOGdXndmdXX+9BTZyMhI=
Subject: patch "usb: quirks: add NO_LPM quirk for Logitech Screen Share" added to usb-linus
To:     dlaz@chromium.org, gregkh@linuxfoundation.org,
        gustavo.padovan@collabora.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:52 +0100
Message-ID: <158331587240147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: quirks: add NO_LPM quirk for Logitech Screen Share

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b96ed52d781a2026d0c0daa5787c6f3d45415862 Mon Sep 17 00:00:00 2001
From: Dan Lazewatsky <dlaz@chromium.org>
Date: Wed, 26 Feb 2020 14:34:38 +0000
Subject: usb: quirks: add NO_LPM quirk for Logitech Screen Share

LPM on the device appears to cause xHCI host controllers to claim
that there isn't enough bandwidth to support additional devices.

Signed-off-by: Dan Lazewatsky <dlaz@chromium.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Link: https://lore.kernel.org/r/20200226143438.1445-1-gustavo.padovan@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 2b24336a72e5..2dac3e7cdd97 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -231,6 +231,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Logitech PTZ Pro Camera */
 	{ USB_DEVICE(0x046d, 0x0853), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Logitech Screen Share */
+	{ USB_DEVICE(0x046d, 0x086c), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Logitech Quickcam Fusion */
 	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.25.1


