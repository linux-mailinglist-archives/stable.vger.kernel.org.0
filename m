Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC22E3F60
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503674AbgL1Ojp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503381AbgL1Ojo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D0E20715;
        Mon, 28 Dec 2020 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166344;
        bh=MEm+eW2fh5w+hZD4u4d80L7uDB/Vye7cWFaMaCFNveM=;
        h=Subject:To:From:Date:From;
        b=X66HbdvDyLuVI50MhkeiB9VH0W7MCvU/6NduYpXRwcgTqBCMjPXf/R9sRfcqZpsi8
         XaslPqXomfOb13uOAVuKqj9S1dylUw5dDJUvPjIXLJVC2iwUS+kfTpkGllFShdbnY3
         9/U1Hp5Nqia7FkKpbbJKEPRZfmgc9S2MrnQXm5EA=
Subject: patch "USB: cdc-acm: blacklist another IR Droid device" added to usb-linus
To:     sean@mess.org, georgi.bakalski@gmail.com,
        gregkh@linuxfoundation.org, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:39:57 +0100
Message-ID: <16091663979675@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-acm: blacklist another IR Droid device

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0ffc76539e6e8d28114f95ac25c167c37b5191b3 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Sun, 27 Dec 2020 13:45:02 +0000
Subject: USB: cdc-acm: blacklist another IR Droid device

This device is supported by the IR Toy driver.

Reported-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201227134502.4548-2-sean@mess.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f52f1bc0559f..781905745812 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1895,6 +1895,10 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x04d8, 0xfd08),
 	.driver_info = IGNORE_DEVICE,
 	},
+
+	{ USB_DEVICE(0x04d8, 0xf58b),
+	.driver_info = IGNORE_DEVICE,
+	},
 #endif
 
 	/*Samsung phone in firmware update mode */
-- 
2.29.2


