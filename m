Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E068212E5C6
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 12:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgABLiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 06:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbgABLiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 06:38:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A36215A4;
        Thu,  2 Jan 2020 11:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577965088;
        bh=/dOLnGBT8MdXvEVFVtANGfvvTS0lD+j3WQIZ0Agu4Z8=;
        h=Subject:To:From:Date:From;
        b=R5rqeOlWQp3w/mKkMWeL4fUJJNeDdgkknuvdkJKX2LmxNwQqV2EnHAn10vBv1r+Ji
         MJ2Gs6TSzuHOfBFao6AS8jQyWgsGd0DRYBiJBZ7peXyS2dsb2DCksaaCJkHOKKWrGf
         zIBrzYArdJXv7ztwb6zwOOeLzxvkLap/ZemfXlzM=
Subject: patch "USB: serial: option: add Telit ME910G1 0x110a composition" added to usb-linus
To:     dnlplm@gmail.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 02 Jan 2020 12:38:06 +0100
Message-ID: <1577965086129161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: option: add Telit ME910G1 0x110a composition

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0d3010fa442429f8780976758719af05592ff19f Mon Sep 17 00:00:00 2001
From: Daniele Palmas <dnlplm@gmail.com>
Date: Fri, 13 Dec 2019 14:56:15 +0100
Subject: USB: serial: option: add Telit ME910G1 0x110a composition

This patch adds the following Telit ME910G1 composition:

0x110a: tty, tty, tty, rmnet

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e9491d400a24..fea09a3f491f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1172,6 +1172,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1102, 0xff),	/* Telit ME910 (ECM) */
 	  .driver_info = NCTRL(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x110a, 0xff),	/* Telit ME910G1 */
+	  .driver_info = NCTRL(0) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910_USBCFG4),
-- 
2.24.1


