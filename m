Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B9359AF2
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhDIKHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhDIKDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5134A61261;
        Fri,  9 Apr 2021 10:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962425;
        bh=9YhkDFGXH04Dg0DIRlWte98xmroS63IvkMruyWGNecU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcrsKqo0+YStk++BuER22t7NHSbnQQPKKp8P3N7WxNQz5A+uD00xZLeSkFs/frToj
         LKt2EDktReixe7mdi04VMsuQO6CyWmm4OO+E3LEgnt8EA6OGVolVwIHkYNfko1H/Oc
         O4zhldQvE8QubusnEVJP+UGeN3p0W1qfDfx4c0ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 11/45] can: kvaser_usb: Add support for USBcan Pro 4xHS
Date:   Fri,  9 Apr 2021 11:53:37 +0200
Message-Id: <20210409095305.757553521@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit 7507479c46b120c37ef83e59be7683a526e98e1a ]

Add support for Kvaser USBcan Pro 4xHS.

Link: https://lore.kernel.org/r/20210309091724.31262-2-jimmyassarsson@gmail.com
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/Kconfig                      | 1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index c1e5d5b570b6..538f4d9adb91 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -73,6 +73,7 @@ config CAN_KVASER_USB
 	    - Kvaser Memorator Pro 5xHS
 	    - Kvaser USBcan Light 4xHS
 	    - Kvaser USBcan Pro 2xHS v2
+	    - Kvaser USBcan Pro 4xHS
 	    - Kvaser USBcan Pro 5xHS
 	    - Kvaser U100
 	    - Kvaser U100P
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e2d58846c40c..073c4a39e718 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -86,8 +86,9 @@
 #define USB_U100_PRODUCT_ID			273
 #define USB_U100P_PRODUCT_ID			274
 #define USB_U100S_PRODUCT_ID			275
+#define USB_USBCAN_PRO_4HS_PRODUCT_ID		276
 #define USB_HYDRA_PRODUCT_ID_END \
-	USB_U100S_PRODUCT_ID
+	USB_USBCAN_PRO_4HS_PRODUCT_ID
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
@@ -193,6 +194,7 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_4HS_PRODUCT_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, kvaser_usb_table);
-- 
2.30.2



