Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D4F2D5DB2
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390107AbgLJO2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390091AbgLJO2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:07 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 19/39] USB: serial: ch341: sort device-id entries
Date:   Thu, 10 Dec 2020 15:26:30 +0100
Message-Id: <20201210142601.854048376@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit bf193bfc12dbc3754fc8a6e0e1e3702f1af2f772 upstream.

Keep the device-id entries sorted to make it easier to add new ones in
the right spot.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ch341.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -70,11 +70,11 @@
 
 
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x4348, 0x5523) },
-	{ USB_DEVICE(0x1a86, 0x7522) },
-	{ USB_DEVICE(0x1a86, 0x7523) },
 	{ USB_DEVICE(0x1a86, 0x5512) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
+	{ USB_DEVICE(0x1a86, 0x7522) },
+	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x4348, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


