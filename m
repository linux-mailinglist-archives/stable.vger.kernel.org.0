Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E223F364B9D
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhDSUpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242463AbhDSUox (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F64613B0;
        Mon, 19 Apr 2021 20:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865062;
        bh=Bmc3UvqQwnCRxqT2QiwzYnZNbecrLCRtRP3bqL4xAAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=YYPFlnY8q+vuLntLHINfBLDDpT2B7ZgV0eCyhsPEmZl2RVzMBcgU2cNbLScy8IZfJ
         Ev7rVTh+clSuajwLzRFKUgh/IyXVcVXAZCMcarO3FCg4nux3/jl1Y2LpaBuWLn3IF1
         NOTm5srWcCWk9myOVAo2fN5HEuuX0NTPzgjQ/VehJ9aavex5LyEN7sQrvMFP3r43PA
         6KtYBSrxzAYOs2XvyUOv0pnP9fkPvc8zNnlj17mvwb21O6f4uTpjiJ51Fa9j7TnNoe
         sMvXAMoDqoUc6RTJWzZu7XLSikbAHxGf0ts17jA0/jlM/y9mHdlmPpA1n22rTi/tc0
         nVvrPzq22T3jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shou-Chieh Hsu <shouchieh@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/21] HID: google: add don USB id
Date:   Mon, 19 Apr 2021 16:43:59 -0400
Message-Id: <20210419204420.6375-1-sashal@kernel.org>
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
index 06813f297dcc..b93ce0d475e0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -486,6 +486,7 @@
 #define USB_DEVICE_ID_GOOGLE_MASTERBALL	0x503c
 #define USB_DEVICE_ID_GOOGLE_MAGNEMITE	0x503d
 #define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
+#define USB_DEVICE_ID_GOOGLE_DON	0x5050
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f
-- 
2.30.2

