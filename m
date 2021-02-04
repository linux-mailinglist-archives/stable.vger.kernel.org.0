Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E5930F77A
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbhBDQQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237697AbhBDQQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 11:16:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B814664E2C;
        Thu,  4 Feb 2021 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612455352;
        bh=5ub1dljYTGXTzkV+xCM5ew6PHCCj48LH1JkFGnK01No=;
        h=Subject:To:From:Date:From;
        b=YkcUMhHrXhhn3/USOie/fGBtuzB+wef+dA97KVre7mQePV55g1IbCjVivBiocWz+N
         y2GzAKuZBDDKJCSFa9hLu+o02VeZLGsA3kefnrVLOePpjPqQUOC72V5CnMUzc2Dg6c
         5+EaOWQYG/72qxOk5Yr8z5LQpSH0PTYEx1FsKSFc=
Subject: patch "staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table" added to staging-testing
To:     martin@kaiser.cx, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Feb 2021 17:15:41 +0100
Message-ID: <1612455341212202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7a8d2f1908a59003e55ef8691d09efb7fbc51625 Mon Sep 17 00:00:00 2001
From: Martin Kaiser <martin@kaiser.cx>
Date: Thu, 4 Feb 2021 09:52:17 +0100
Subject: staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

The Edimax EW-7811UN V2 uses an RTL8188EU chipset and works with this
driver.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210204085217.9743-1-martin@kaiser.cx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 43ebd11b53fe..efad43d8e465 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -41,6 +41,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	{USB_DEVICE(0x2357, 0x0111)}, /* TP-Link TL-WN727N v5.21 */
 	{USB_DEVICE(0x2C4E, 0x0102)}, /* MERCUSYS MW150US v2 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
+	{USB_DEVICE(0x7392, 0xb811)}, /* Edimax EW-7811UN V2 */
 	{USB_DEVICE(USB_VENDER_ID_REALTEK, 0xffef)}, /* Rosewill RNX-N150NUB */
 	{}	/* Terminating entry */
 };
-- 
2.30.0


