Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674C742DCFB
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhJNPDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhJNPCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 11:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D44611F2;
        Thu, 14 Oct 2021 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223555;
        bh=+QRJHM5QE3mSWvX3TiTNJdhjeKXqCOFpAJ2Z/yOlcyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCxNUNn1vmFioSLnDpOnvcMuaR18Rv8u4CslU06EToYn2E8sZOgKIo2wM9IErDYBk
         0vDqz8ldn0IwOSSDdt4339XI5fMT5fIiZMe6yK+of4e9RaFSZb8zLI/UQoBRY1gqqp
         dLOK0u9tFO6AKXtrP9Sxb3WljvFMtyaLNmLnTqE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/16] HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs
Date:   Thu, 14 Oct 2021 16:54:08 +0200
Message-Id: <20211014145207.495424334@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
References: <20211014145207.314256898@linuxfoundation.org>
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
index d5425bc1ad61..f6be2e70a496 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4715,6 +4715,12 @@ static const struct wacom_features wacom_features_0x393 =
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
@@ -4888,6 +4894,8 @@ const struct hid_device_id wacom_ids[] = {
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



