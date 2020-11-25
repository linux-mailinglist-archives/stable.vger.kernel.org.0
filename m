Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B42E2C43D2
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbgKYPhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730988AbgKYPhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:37:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB9A221F7;
        Wed, 25 Nov 2020 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318636;
        bh=csn/Hk+YBhchIph27lvMqOAt+Ne57dazRGG/PH73ALY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnA4XHE+njS5IAa+2KaNGJKmVdDsJz2TxUHCd8c/2by3OlxPJp1k5UcddYcnBltNv
         ght5/KgCToH1X0lhKBN6kpiLpbMiWrCGnBsQfvLN0xLJipb94cQPSqTFmbhOM9hBnp
         JJzirP9WkCHLthh0/65TbY3e71jlK/mgXpEzdm8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?David=20G=C3=A1miz=20Jim=C3=A9nez?= 
        <david.gamiz@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/15] HID: add support for Sega Saturn
Date:   Wed, 25 Nov 2020 10:36:59 -0500
Message-Id: <20201125153712.810655-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153712.810655-1-sashal@kernel.org>
References: <20201125153712.810655-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 1811977cb11354aef8cbd13e35ff50db716728a4 ]

This device needs HID_QUIRK_MULTI_INPUT in order to be presented to userspace
in a consistent way.

Reported-and-tested-by: David Gámiz Jiménez <david.gamiz@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e9155f7c8c51c..4d2a1d540a821 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -479,6 +479,7 @@
 #define USB_DEVICE_ID_PENPOWER		0x00f4
 
 #define USB_VENDOR_ID_GREENASIA		0x0e8f
+#define USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR 0x3010
 #define USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD	0x3013
 
 #define USB_VENDOR_ID_GRETAGMACBETH	0x0971
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 2d8d20a7f4574..493e2e7e12de0 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -85,6 +85,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_FUTABA, USB_DEVICE_ID_LED_DISPLAY), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_SAT_ADAPTOR), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
-- 
2.27.0

