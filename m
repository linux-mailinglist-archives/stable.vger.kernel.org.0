Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D95242DD74
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhJNPHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhJNPGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FF861163;
        Thu, 14 Oct 2021 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223689;
        bh=5e7Sw77oXbElVdGKegv3F1SKV4xyAxsp0hWW5XW1Jpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y466ezWAbFIaleqiGTwiX+RLVbwU54yqZp48nuUCEETiWKSHqqOGSOon8C/7d4xDm
         UZ1XqeN49fTwAQErW+m4+OiioqLt/BuK9vL78l8ST8VGIG6Cxg3qqoDXSQ/4ahBOw7
         vN8gPeWj+DMT00Q/fR7fhhLV5IHeZseB0gglZO2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 09/30] HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs
Date:   Thu, 14 Oct 2021 16:54:14 +0200
Message-Id: <20211014145209.832991204@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145209.520017940@linuxfoundation.org>
References: <20211014145209.520017940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



