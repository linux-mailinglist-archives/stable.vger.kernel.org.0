Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074E2364B50
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242271AbhDSUoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242260AbhDSUoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 317B7611C9;
        Mon, 19 Apr 2021 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865025;
        bh=7axQs0weAloM0DecjN6AkOJZnqMhEl1Hs9cTab+fIIU=;
        h=From:To:Cc:Subject:Date:From;
        b=OTno0p/0TQz5SUmHFW1BF9PB/KwxDCRn79k3O3UbKVBnEiOoLiFpwzNmmFyJyE874
         +ZpZ342m5zzLSsrtVmR5oqwE5l3StIG4XqHZ0jdAcwL6ZAuZXXOGdOMxNgkM0EJapb
         P9JUDAtMZhjo6NsCZLqqfTXYFQVkOE7fAcfDx5NP2C3qQQS60k8zOLGaOsFeDNMC09
         zN/53zFBahCSePO8ns5++JzZvCvDNKjZFdn1W8a3KDemrwziv3nKBrI27Kj1YXv7ku
         XrxW7ZFUcWciFHviMaCkoQHUtZfEbn/KBura30TPEv48lPy3SmTMIuPyrhMeoG8JFF
         XVsgZ0AcstRGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shou-Chieh Hsu <shouchieh@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 01/23] HID: google: add don USB id
Date:   Mon, 19 Apr 2021 16:43:20 -0400
Message-Id: <20210419204343.6134-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

