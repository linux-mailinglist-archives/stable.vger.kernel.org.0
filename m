Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D8C47FEC2
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhL0Pcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbhL0PcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A16DC06173E;
        Mon, 27 Dec 2021 07:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61919CE10C4;
        Mon, 27 Dec 2021 15:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F77BC36AE7;
        Mon, 27 Dec 2021 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619141;
        bh=AeXf9CUPHaX5o4aodq+le/lqmNSOCCjahm+AXGnTDE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+7174rByYadQUH48/Hy6B5MBmkdnF+5TbhusiTSDLRzOmjmVc0aqDeMEHHdUfZvZ
         s+xAo9DK1GKqGGxfE866cFzTsBb0RSJfmV7Hhq+wrMMZSH0CX/MnbhEc6pj6JmXd4c
         iZORwUsLQAoWehx0s4Tr0E9SHEdE0N2ces/o4p/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Greg Jesionowski <jesionowskigreg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 01/38] net: usb: lan78xx: add Allied Telesis AT29M2-AF
Date:   Mon, 27 Dec 2021 16:30:38 +0100
Message-Id: <20211227151319.427867164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Jesionowski <jesionowskigreg@gmail.com>

commit ef8a0f6eab1ca5d1a75c242c5c7b9d386735fa0a upstream.

This adds the vendor and product IDs for the AT29M2-AF which is a
lan7801-based device.

Signed-off-by: Greg Jesionowski <jesionowskigreg@gmail.com>
Link: https://lore.kernel.org/r/20211214221027.305784-1-jesionowskigreg@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -75,6 +75,8 @@
 #define LAN7801_USB_PRODUCT_ID		(0x7801)
 #define LAN78XX_EEPROM_MAGIC		(0x78A5)
 #define LAN78XX_OTP_MAGIC		(0x78F3)
+#define AT29M2AF_USB_VENDOR_ID		(0x07C9)
+#define AT29M2AF_USB_PRODUCT_ID	(0x0012)
 
 #define	MII_READ			1
 #define	MII_WRITE			0
@@ -4170,6 +4172,10 @@ static const struct usb_device_id produc
 	/* LAN7801 USB Gigabit Ethernet Device */
 	USB_DEVICE(LAN78XX_USB_VENDOR_ID, LAN7801_USB_PRODUCT_ID),
 	},
+	{
+	/* ATM2-AF USB Gigabit Ethernet Device */
+	USB_DEVICE(AT29M2AF_USB_VENDOR_ID, AT29M2AF_USB_PRODUCT_ID),
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(usb, products);


