Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D389136AE9C
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhDZHpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233996AbhDZHoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47832613ED;
        Mon, 26 Apr 2021 07:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422866;
        bh=7axQs0weAloM0DecjN6AkOJZnqMhEl1Hs9cTab+fIIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeNv9X9y97IJHOeKg12anjujiCK6Sp2auKcCJpwkuVh+kIP133pICP+2+MD2TaD5J
         7tf38CHHZ9J2mr5Uw2hyCklyoHtXQBGG6BDGP5TgbV+DalFBVrvf81vHI1VVKEAUaz
         SM9FWasYHOnYZnQ7kf/zdLSfOL276KAU97zCjeqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shou-Chieh Hsu <shouchieh@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 22/41] HID: google: add don USB id
Date:   Mon, 26 Apr 2021 09:30:09 +0200
Message-Id: <20210426072820.439020481@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shou-Chieh Hsu <shouchieh@chromium.org>

[ Upstream commit 36b87cf302a4f13f8b4344bcf98f67405a145e2f ]

Add 1 additional hammer-like device.

Signed-off-by: Shou-Chieh Hsu <shouchieh@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-google-hammer.c | 2 ++
 drivers/hid/hid-ids.h           | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-google-hammer.c b/drivers/hid/hid-google-hammer.c
index 85a054f1ce38..2a176f77b32e 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -526,6 +526,8 @@ static void hammer_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id hammer_devices[] = {
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_DON) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_HAMMER) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b60279aaed43..570bd0103a86 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -488,6 +488,7 @@
 #define USB_DEVICE_ID_GOOGLE_MASTERBALL	0x503c
 #define USB_DEVICE_ID_GOOGLE_MAGNEMITE	0x503d
 #define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
+#define USB_DEVICE_ID_GOOGLE_DON	0x5050
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f
-- 
2.30.2



