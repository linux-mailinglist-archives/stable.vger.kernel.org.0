Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741C4F7E77
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfKKSn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbfKKSn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2ED920674;
        Mon, 11 Nov 2019 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497835;
        bh=hbb7MuaPZaqdvEjSeViM3WM9/Zb0UaWiSQzu5+zwwjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJCkj0Fq/QMZxTZbvmuLAqFTQtwYiPjUkbM5LinKQAbaasOm3WJg2bjNFsVE+V7gH
         VgSWDI/CcYgqZv2ht2YobRtHhnQ97q0408mRSm7PxnjHifYCJ0TDM+thWPGbiy3D8w
         VsQl7SfBjG9hcGLa4KK3zwXql1FdP4+OUDEfr5fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/125] HID: google: add magnemite/masterball USB ids
Date:   Mon, 11 Nov 2019 19:28:29 +0100
Message-Id: <20191111181449.479293828@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 9e4dbc4646a84b2562ea7c64a542740687ff7daf ]

Add 2 additional hammer-like devices.

Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-google-hammer.c | 4 ++++
 drivers/hid/hid-ids.h           | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-google-hammer.c b/drivers/hid/hid-google-hammer.c
index 6bf4da7ad63a5..8cb63ea9977d6 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -120,6 +120,10 @@ static int hammer_input_configured(struct hid_device *hdev,
 static const struct hid_device_id hammer_devices[] = {
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_HAMMER) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MAGNEMITE) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MASTERBALL) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_STAFF) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6b33117ca60e5..02c263a4c0836 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,6 +466,8 @@
 #define USB_DEVICE_ID_GOOGLE_STAFF	0x502b
 #define USB_DEVICE_ID_GOOGLE_WAND	0x502d
 #define USB_DEVICE_ID_GOOGLE_WHISKERS	0x5030
+#define USB_DEVICE_ID_GOOGLE_MASTERBALL	0x503c
+#define USB_DEVICE_ID_GOOGLE_MAGNEMITE	0x503d
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f
-- 
2.20.1



