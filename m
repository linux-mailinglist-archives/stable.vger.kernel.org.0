Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC00B8C977
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfHNCLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbfHNCLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B727820843;
        Wed, 14 Aug 2019 02:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748677;
        bh=TSBliH0qWd9PJs1EiN+1smbpDa3gXwEEYQr6fkkxRRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfySNg4M4AP5rYJ8gkKF2YCgJZ41rfewkH4+AR0giq782hyVfOHqe08Qs5hwnignJ
         EriKsXSzARRa4A2MPFUqQWWQgO3KDNszLMAwe5f4vdI7L4F22RIAOEbSUtGNoWA4R2
         I+LAN8bPYTovW63NIdri5AD0JW3ByH8kPIb31vBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 016/123] HID: logitech-hidpp: add USB PID for a few more supported mice
Date:   Tue, 13 Aug 2019 22:09:00 -0400
Message-Id: <20190814021047.14828-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Laíns <lains@archlinux.org>

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

