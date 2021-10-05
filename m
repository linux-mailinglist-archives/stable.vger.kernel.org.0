Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23339422882
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhJENws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235464AbhJENwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDAE961B05;
        Tue,  5 Oct 2021 13:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441849;
        bh=5e7Sw77oXbElVdGKegv3F1SKV4xyAxsp0hWW5XW1Jpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cofGO+3Dk6XcX0smhhyXzlQ+30dAst3xr0UeieCESFky1Ehbfj3nJx72C1aFgcvu0
         oDisDX6P5fOn2hF+6EJT7zGWD4mqNdDbRtPo877FuIy7KFvqhi8AKNkdqI+NG6fn/f
         +X7uNgZ+Oe0XbOM/+1WKW16AmluMdqmbUIZrC3FrA2JgBuYIFkf0KoQhMT++21VEuP
         wHF/LU2UxPbs3cGYtBvYJwDokLZ2AzWhFsIGe5NSpaxGrxx5DhVJo9mP8L8mXpsq7R
         uKs2oplwjFcKZb5+B1+QIo12CQos8JgCbzqKC0sKlOw4D/m9wGhw0GxIk4W70Sh3k6
         DXH+gHP+xkBoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joshua-Dickens <Joshua@Joshua-Dickens.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 13/40] HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs
Date:   Tue,  5 Oct 2021 09:49:52 -0400
Message-Id: <20211005135020.214291-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua-Dickens <Joshua@Joshua-Dickens.com>

[ Upstream commit 0c8fbaa553077630e8eae45bd9676cfc01836aeb ]

Add the new PIDs to wacom_wac.c to support the new models in the Intuos series.

[jkosina@suse.cz: fix changelog]
Signed-off-by: Joshua Dickens <joshua.dickens@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 81ba642adcb7..528d94ccd76f 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4720,6 +4720,12 @@ static const struct wacom_features wacom_features_0x393 =
 	{ "Wacom Intuos Pro S", 31920, 19950, 8191, 63,
 	  INTUOSP2S_BT, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 7,
 	  .touch_max = 10 };
+static const struct wacom_features wacom_features_0x3c6 =
+	{ "Wacom Intuos BT S", 15200, 9500, 4095, 63,
+	  INTUOSHT3_BT, WACOM_INTUOS_RES, WACOM_INTUOS_RES, 4 };
+static const struct wacom_features wacom_features_0x3c8 =
+	{ "Wacom Intuos BT M", 21600, 13500, 4095, 63,
+	  INTUOSHT3_BT, WACOM_INTUOS_RES, WACOM_INTUOS_RES, 4 };
 
 static const struct wacom_features wacom_features_HID_ANY_ID =
 	{ "Wacom HID", .type = HID_GENERIC, .oVid = HID_ANY_ID, .oPid = HID_ANY_ID };
@@ -4893,6 +4899,8 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x37A) },
 	{ USB_DEVICE_WACOM(0x37B) },
 	{ BT_DEVICE_WACOM(0x393) },
+	{ BT_DEVICE_WACOM(0x3c6) },
+	{ BT_DEVICE_WACOM(0x3c8) },
 	{ USB_DEVICE_WACOM(0x4001) },
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
-- 
2.33.0

