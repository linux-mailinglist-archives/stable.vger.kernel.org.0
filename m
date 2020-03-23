Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3069718F2E2
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 11:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgCWKeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 06:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgCWKeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 06:34:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65D012072E;
        Mon, 23 Mar 2020 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584959649;
        bh=QOve1Nkcq01E4uy1xBSDhlX+5kjgK7a8ThvrBTeQp1k=;
        h=Subject:To:From:Date:From;
        b=YTzyTilgpdyEw3sJo+NsPmv4H/32EEF9uBUwOyoodKClVMwmZaegU/cVTV18fyXnO
         4letY8UptC/qpXzBlDWHSDQU9hPwjhw8Gx9G32vvI/6EMz4NRU0iZMqkDPgit227/h
         OdVtvwmom2cgO+OesiohOpzciHtDbYsEe6KiEKQU=
Subject: patch "staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table" added to staging-testing
To:     Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, zraetn@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 11:33:53 +0100
Message-ID: <158495963398240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 38ef48f7d4b7342f145a1b4f96023bde99aeb245 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sat, 21 Mar 2020 13:00:11 -0500
Subject: staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

The ASUS USB-N10 Nano B1 has been reported as a new RTL8188EU device.
Add it to the device tables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: kovi <zraetn@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200321180011.26153-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 845c8817281c..f7f09c0d273f 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -32,6 +32,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x056e, 0x4008)}, /* Elecom WDC-150SU2M */
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
+	{USB_DEVICE(0x0B05, 0x18F0)}, /* ASUS USB-N10 Nano B1 */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
-- 
2.25.2


