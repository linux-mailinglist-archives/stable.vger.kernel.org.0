Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108029E145
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbfH0ICR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbfH0ICQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E133206BF;
        Tue, 27 Aug 2019 08:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892934;
        bh=Q4357+CLrATKCNN2NdR6Db6rhCBBv0YlO8NsV05X+ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/W8+vtA23jkKHhgU6cnkdM9JpjfM/NDTEZDZIklde9bGEec8ZwSXiH5zG7ge+vzN
         PQsEu6Z1mH49CytL0Bnm5nEw073hW52SQn1dMhPpLsz3oA8YvTzM/EnUcAgRCIKE1Y
         EiW7HJid/aXzfERXWyDsoljzSf70hDL6kxj3AICM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 012/162] HID: logitech-hidpp: add USB PID for a few more supported mice
Date:   Tue, 27 Aug 2019 09:49:00 +0200
Message-Id: <20190827072738.774367486@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 27fc32fd9417968a459d43d9a7c50fd423d53eb9 ]

Add more device IDs to logitech-hidpp driver.

Signed-off-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index cf05816a601f5..34e2b3f9d540d 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3749,15 +3749,45 @@ static const struct hid_device_id hidpp_devices[] = {
 
 	{ L27MHZ_DEVICE(HID_ANY_ID) },
 
-	{ /* Logitech G403 Gaming Mouse over USB */
+	{ /* Logitech G203/Prodigy Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC084) },
+	{ /* Logitech G302 Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07F) },
+	{ /* Logitech G303 Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC080) },
+	{ /* Logitech G400 Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07E) },
+	{ /* Logitech G403 Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
+	{ /* Logitech G403 Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC083) },
+	{ /* Logitech G403 Hero Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08F) },
+	{ /* Logitech G502 Proteus Core Gaming Mouse */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07D) },
+	{ /* Logitech G502 Proteus Spectrum Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC332) },
+	{ /* Logitech G502 Hero Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08B) },
 	{ /* Logitech G700 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC06B) },
+	{ /* Logitech G700s Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07C) },
+	{ /* Logitech G703 Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
+	{ /* Logitech G703 Hero Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC090) },
 	{ /* Logitech G900 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC081) },
+	{ /* Logitech G903 Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC086) },
+	{ /* Logitech G903 Hero Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC091) },
 	{ /* Logitech G920 Wheel over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G920_WHEEL),
 		.driver_data = HIDPP_QUIRK_CLASS_G920 | HIDPP_QUIRK_FORCE_OUTPUT_REPORTS},
+	{ /* Logitech G Pro Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC088) },
 
 	{ /* MX5000 keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb305),
-- 
2.20.1



