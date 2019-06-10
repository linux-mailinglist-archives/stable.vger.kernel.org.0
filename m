Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47DC3B76D
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403910AbfFJOb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403864AbfFJOb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:31:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81876208E3;
        Mon, 10 Jun 2019 14:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560177116;
        bh=tufJKS4VMZLSCEMOZZ5uhssbl3eGBwgPrdMvwhAhaAg=;
        h=Subject:To:From:Date:From;
        b=F2gUPliFsL7YLH7dtn5sEEcREp6yINsMykYcSKTypA31Biiarv+BJDKiT9EkbyI6T
         p5+OhhY0Nq5aTpmoiPl4gcOkeHpQy/zvwEokaW0ebFaYXkrVwlw0SAbpOxBZkY6Kc1
         KQjKP3lqmWciLqdgL0tnAUuPGKnHdxR3Lq1KrfLA=
Subject: patch "USB: serial: option: add Telit 0x1260 and 0x1261 compositions" added to usb-linus
To:     dnlplm@gmail.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Jun 2019 16:31:43 +0200
Message-ID: <15601771038179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add Telit 0x1260 and 0x1261 compositions

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f3dfd4072c3ee6e287f501a18b5718b185d6a940 Mon Sep 17 00:00:00 2001
From: Daniele Palmas <dnlplm@gmail.com>
Date: Wed, 15 May 2019 17:27:49 +0200
Subject: USB: serial: option: add Telit 0x1260 and 0x1261 compositions

Added support for Telit LE910Cx 0x1260 and 0x1261 compositions.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 100a5c0ec3e7..a0aaf0635359 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1171,6 +1171,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920A4_1213, 0xff) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920A4_1214),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) | RSVD(3) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1260),
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1261),
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x1900),				/* Telit LN940 (QMI) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1901, 0xff),	/* Telit LN940 (MBIM) */
-- 
2.22.0


