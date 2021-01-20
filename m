Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAED02FC7FC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhATCai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA8D722509;
        Wed, 20 Jan 2021 01:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106007;
        bh=JvIH/5lkdHXQCODBz/Zth687PtRqCjPoQeuwe5CdNoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCct37YYl3VyC/5ato9AQXfstq2DHwKdqmswa6Q7EM9QPTYK4tmnnpa/4Bg1DzH9F
         Ozq88ZZ0ulZLXA6l8Ne45puot8P9/MNUYZ5HL4hW5nF+AFRrJ8Q9tfB3KgRWGoB8E+
         2ExT0kfhz2TPf0Lyps9xk9iFcUuFSTkVN8j78XmZ9P9VtR/f1uFVwRdMGrZSV+kLNE
         B2ntqt8cawuekInR58u80xqKbj4JTq6krsqdfzDsr6xDQJBdvoir+pdxBd2Iauetec
         +8ymws+NSbi6SSshF9ml7r2rrUwiScRp9gz8sO6thMU6Dao6xsCzYSP6FBwlCmAUMf
         Wk35HMhRTH0hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Miell <nmiell@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 34/45] HID: logitech-hidpp: Add product ID for MX Ergo in Bluetooth mode
Date:   Tue, 19 Jan 2021 20:25:51 -0500
Message-Id: <20210120012602.769683-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Miell <nmiell@gmail.com>

[ Upstream commit 7de843dbaaa68aa514090e6226ed7c6374fd7e49 ]

The Logitech MX Ergo trackball supports HID++ 4.5 over Bluetooth. Add its
product ID to the table so we can get battery monitoring support.
(The hid-logitech-hidpp driver already recognizes it when connected via
a Unifying Receiver.)

[jkosina@suse.cz: fix whitespace damage]
Signed-off-by: Nicholas Miell <nmiell@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 0ca7231195473..74ebfb12c360e 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4051,6 +4051,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* MX Master mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb012),
 	  .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
+	{ /* MX Ergo trackball over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01d) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e),
 	  .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ /* MX Master 3 mouse over Bluetooth */
-- 
2.27.0

