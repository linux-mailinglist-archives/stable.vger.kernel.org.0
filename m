Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91AC26C981
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 21:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgIPTMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 15:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgIPRkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:40:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA79F20838;
        Wed, 16 Sep 2020 11:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600254476;
        bh=/9g64sk8NnhZo1HCAservfblHfGTdKugEHcDi5b7Av4=;
        h=Subject:To:From:Date:From;
        b=v3BFoDFmmeQRga1Ag8DeiEwapW53PhZYuQDNdfliwKF5YGXgAosT/NTAVPY77VhFG
         bHsbTyMYCFI6r+HwtDjZDNmlw7CQAegXTaZ02juJjPPP01Tl8HqrHVT0ODdXtpyW4p
         8vPia0TQPIrI0di/GiEkY7YvS+ypcBMPgBMnTLMo=
Subject: patch "USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin" added to usb-linus
To:     penghao@uniontech.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 13:08:30 +0200
Message-ID: <1600254510139135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bcea6dafeeef7d1a6a8320a249aabf981d63b881 Mon Sep 17 00:00:00 2001
From: Penghao <penghao@uniontech.com>
Date: Mon, 7 Sep 2020 10:30:26 +0800
Subject: USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin
 notebook

Add a USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for the BYD zhaoxin notebook.
This notebook come with usb touchpad. And we would like to disable
touchpad wakeup on this notebook by default.

Signed-off-by: Penghao <penghao@uniontech.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200907023026.28189-1-penghao@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f232914de5fd..10574fa3f927 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -397,6 +397,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Generic RTL8153 based ethernet adapters */
 	{ USB_DEVICE(0x0bda, 0x8153), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* SONiX USB DEVICE Touchpad */
+	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },
-- 
2.28.0


