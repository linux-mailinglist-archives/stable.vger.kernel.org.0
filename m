Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E42D13B6
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgLGOaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgLGOaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 09:30:10 -0500
Subject: patch "USB: add RESET_RESUME quirk for Snapscan 1212" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607351369;
        bh=nYLGjDHkFfrdK0iOIz86/kOFP+2bLyPYjwSzKa/esKo=;
        h=To:From:Date:From;
        b=Q/B7ZSe+WC2FmvXfyUZeSHlhR58ITnzX13n9pXHKv38mJ1Y7tiDDAK/cVP34+ktUH
         K8JeOsrJqoYEfaZLsaFb+gvNuXrFuz+/Kq3bfGTVnTgX6DYandbt71N+DnJOgAtPjT
         1/LaxLxoekUiJr4XwHaOQQwPA55kgSJ7sBmxKM+U=
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Dec 2020 15:30:40 +0100
Message-ID: <160735144011832@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

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


