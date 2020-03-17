Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77F6188525
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 14:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCQNSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 09:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgCQNSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 09:18:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A05D20724;
        Tue, 17 Mar 2020 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584451081;
        bh=Blb1OCk5Gfrvt8zqKw+rGEJLrl+nV93zIWzvnPdBvdY=;
        h=Subject:To:From:Date:From;
        b=umPp6cmfWr5h7gUcZoVLu28JY7S2i8kzoyoWgSWP/WAxzVswYyQt8CGw3X/lOR9pz
         LOyv9PWFOlXTKBHPGEgG0qZovEAZ77p3hh0PwYMTa5VKWfaMOtZJQ/SK/s947bNmrj
         ik8UVuYZfJVsdPfvj3+pnCs7ozk9zSCmUHDhvrQM=
Subject: patch "staging: rtl8188eu: Add device id for MERCUSYS MW150US v2" added to staging-linus
To:     straube.linux@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Mar 2020 14:17:49 +0100
Message-ID: <1584451069239183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bb5786b9286c253557a0115bc8d21879e61b7b94 Mon Sep 17 00:00:00 2001
From: Michael Straube <straube.linux@gmail.com>
Date: Thu, 12 Mar 2020 10:36:52 +0100
Subject: staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

This device was added to the stand-alone driver on github.
Add it to the staging driver as well.

Link: https://github.com/lwfinger/rtl8188eu/commit/2141f244c3e7
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312093652.13918-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index b5d42f411dd8..845c8817281c 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -38,6 +38,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	{USB_DEVICE(0x2001, 0x331B)}, /* D-Link DWA-121 rev B1 */
 	{USB_DEVICE(0x2357, 0x010c)}, /* TP-Link TL-WN722N v2 */
 	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
+	{USB_DEVICE(0x2C4E, 0x0102)}, /* MERCUSYS MW150US v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */
-- 
2.25.1


