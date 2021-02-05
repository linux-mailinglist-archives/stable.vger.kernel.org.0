Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F98C3112A1
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhBESzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233032AbhBEPEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:04:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95FE664DB1;
        Fri,  5 Feb 2021 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612542197;
        bh=XHjz83QTMmG8sZm/oQBplgJUikTv4NcoOWAzNTl/O9Y=;
        h=Subject:To:From:Date:From;
        b=IDv6CIUZRqQ0npHHyr5QPeeQppks5zvGNx/aCITxvQLpSr+XGCEUpGpcCmwVBfKyN
         zm3mlrwokEYZZeFeEHa9ZRqK+gg0EZbzWg2y/s+sbb2yhn4jW0k45zrkJ3ZeR3pB2U
         f0FDC7U/a4/QGxyn3khc8oHWyMRdwBFckBp6qJSU=
Subject: patch "staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table" added to staging-next
To:     martin@kaiser.cx, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 05 Feb 2021 17:23:02 +0100
Message-ID: <1612542182236209@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


