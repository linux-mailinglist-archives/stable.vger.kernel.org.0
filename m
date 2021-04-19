Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9323A364BD8
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242959AbhDSUqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242753AbhDSUp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3258F613B0;
        Mon, 19 Apr 2021 20:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865097;
        bh=HYKxwTLN0oShRRBPQB5BGy/UE/OCRiHE9AFP81f2wH8=;
        h=From:To:Cc:Subject:Date:From;
        b=UOqSlCMIL2fseHOBfER5lqxZbe67IrBEnijNF3UxRLlHtANt64WuyLswGCMJUq2qw
         0dAvxEBHGC++DNoPfEEsbdZ/CtljhCRJHZ4pZ7J2ddjuIFmZ4jmKN54GDudqR/azb4
         RBaNldERFfYcRcgzz5E++/JTcSIGx6wxttcZTZQKICSh43PNnxYfO/X8PQMDef6ar2
         y5CbvvBuIneOKw7gX89N7MUjcLKn1dvhIISWdoYrzsKzvEu8+iVMBPoozXtpPcex0x
         QW2MsEDy6yd+nIXlR8Al+SlTntc72ah4pAhMEumK+RXUtRIvV34IF4jKrO/SRstdlF
         IoMJHWUQ8NlCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shou-Chieh Hsu <shouchieh@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/14] HID: google: add don USB id
Date:   Mon, 19 Apr 2021 16:44:41 -0400
Message-Id: <20210419204454.6601-1-sashal@kernel.org>
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
index aeb351658ad3..505ed76a830e 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -467,6 +467,8 @@ static int hammer_probe(struct hid_device *hdev,
 
 
 static const struct hid_device_id hammer_devices[] = {
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_DON) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_HAMMER) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d004f5645b30..d9e8105045a6 100644
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

