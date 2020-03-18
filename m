Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6A0189818
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 10:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgCRJnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 05:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgCRJnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 05:43:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F1220674;
        Wed, 18 Mar 2020 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584524595;
        bh=EvN0qOUWlwhrd+uGqwJkVncMtXu7VSLb1XFU0UUAXN4=;
        h=Subject:To:From:Date:From;
        b=dhwMGcYWf5oWR372rlnEKSMbQZVrdWKcPvsyZDEqqc0nbWa9VP6Dhv319strMui2E
         jvYsKe3/KDmnWAynooUO46RB62pTxwP2djw1zgmHIARN8hv4qrFfH1JJMDYMAUPRQw
         wDfJ7/qUcL37g6V7ASc4k/9+pOLcnff+ZzjxnkRk=
Subject: patch "USB: serial: option: add ME910G1 ECM composition 0x110b" added to usb-linus
To:     dnlplm@gmail.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 10:43:12 +0100
Message-ID: <158452459295232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add ME910G1 ECM composition 0x110b

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8e852a7953be2a6ee371449f7257fe15ace6a1fc Mon Sep 17 00:00:00 2001
From: Daniele Palmas <dnlplm@gmail.com>
Date: Wed, 4 Mar 2020 11:43:10 +0100
Subject: USB: serial: option: add ME910G1 ECM composition 0x110b

Add ME910G1 ECM composition 0x110b: tty, tty, tty, ecm

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20200304104310.2938-1-dnlplm@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 084cc2fff3ae..0b5dcf973d94 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1183,6 +1183,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110a, 0xff),	/* Telit ME910G1 */
 	  .driver_info = NCTRL(0) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110b, 0xff),	/* Telit ME910G1 (ECM) */
+	  .driver_info = NCTRL(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),
-- 
2.25.1


