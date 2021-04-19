Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E64364B52
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhDSUoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242276AbhDSUoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8813C61104;
        Mon, 19 Apr 2021 20:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865027;
        bh=QQpF9z+ZTPzjlkgV2lwczH4mcDIjUkqrOmE6/yfrle0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9gSTpXD36chAXHtbWtpvPLxIdIdlFa+o8/VUusKi+ydJA1QYVcDHKOSWS9sa1Vzv
         k3GwlV/LpYdwa4QTGfhknaoMU0q5cKl0tav41sdxDYVYT+t14QmS5wqNfZ0iCHzTVE
         A/B6t34kuNJ+GvJySVYCfRnh+yYYa4/dlLotfvhkuAriNEHfDsszQgzn2ssMbH/0yt
         abetBTocOHUsuElYIyTB4cV6HlU5XDF2m2aXUqox6+qyUuWBDHjgcTjeCSUmhSVT4p
         ElcTarswDyzVwN4edo9MhMoKK36o32JCV2WpPz677G2jGQSr4T4uxJZD5Sc8HDZJSX
         XwDfxMuySttiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luke D Jones <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 02/23] HID: asus: Add support for 2021 ASUS N-Key keyboard
Date:   Mon, 19 Apr 2021 16:43:21 -0400
Message-Id: <20210419204343.6134-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204343.6134-1-sashal@kernel.org>
References: <20210419204343.6134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

[ Upstream commit 9a0b44fbfea1932196a4879b44a37dd182e984c5 ]

Some new 2021 version of ASUS gamer laptops are using an updated
N-Key keyboard with the PID of 0x19b6. This version is using the
same init sequence and brightness control as the 0x1866 keyboard.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 1dfe184ebf5a..2ab22b925941 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1221,6 +1221,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 		USB_DEVICE_ID_ASUSTEK_T100TA_KEYBOARD),
 	  QUIRK_T100_KEYBOARD | QUIRK_NO_CONSUMER_USAGES },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 570bd0103a86..09d049986516 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -191,6 +191,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_KEYBOARD2 0x1837
 #define USB_DEVICE_ID_ASUSTEK_ROG_KEYBOARD3 0x1822
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD	0x1866
+#define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2	0x19b6
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
 
 #define USB_VENDOR_ID_ATEN		0x0557
-- 
2.30.2

