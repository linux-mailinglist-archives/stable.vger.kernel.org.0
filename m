Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F521008BD
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfKRPzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfKRPzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 10:55:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA78217D6;
        Mon, 18 Nov 2019 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574092506;
        bh=jc5wmQnh2FEGDOoPdkETwSCnDD+uvtT+dI8srOzO0vw=;
        h=Subject:To:From:Date:From;
        b=ep+aP0hS6WZbuavnSRPmFDhgIfCLCaDPiTRHrz3v31BdOp3nx9kmxfECgfX3FnXaE
         PtC9sN1P7EK5SfEMyz9egeJcN22kfIUBv+fyp+ZOP8LbnvhAQ/gQlHtVZ9pO76OaKU
         ty5QRDWDxNBCkwmL6FxYKJSFOJpZ7Q6SBWuicyZw=
Subject: patch "usb-serial: cp201x: support Mark-10 digital force gauge" added to usb-next
To:     gregkh@linuxfoundation.org, joel.jennings@makeitlabs.com,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:53:08 +0100
Message-ID: <15740923888590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-serial: cp201x: support Mark-10 digital force gauge

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 347bc8cb26388791c5881a3775cb14a3f765a674 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 18 Nov 2019 10:21:19 +0100
Subject: usb-serial: cp201x: support Mark-10 digital force gauge

Add support for the Mark-10 digital force gauge device to the cp201x
driver.

Based on a report and a larger patch from Joel Jennings

Reported-by: Joel Jennings <joel.jennings@makeitlabs.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191118092119.GA153852@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 979bef9bfb6b..f5143eedbc48 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -125,6 +125,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */
 	{ USB_DEVICE(0x10C4, 0x83A8) }, /* Amber Wireless AMB2560 */
+	{ USB_DEVICE(0x10C4, 0x83AA) }, /* Mark-10 Digital Force Gauge */
 	{ USB_DEVICE(0x10C4, 0x83D8) }, /* DekTec DTA Plus VHF/UHF Booster/Attenuator */
 	{ USB_DEVICE(0x10C4, 0x8411) }, /* Kyocera GPS Module */
 	{ USB_DEVICE(0x10C4, 0x8418) }, /* IRZ Automation Teleport SG-10 GSM/GPRS Modem */
-- 
2.24.0


