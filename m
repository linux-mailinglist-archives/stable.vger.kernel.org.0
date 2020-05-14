Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57D1D39F7
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgENSxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgENSxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D170820675;
        Thu, 14 May 2020 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482399;
        bh=RynSNIU6sbVrOBG5pwb//yZ0YoV84kck7xwd8Gr2kB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw0cCK5yyXRR4un2Cwh7TJW9Azo0SrHfhH/FfbN4CqskHimb2X8OHI6gLZBtW+XrD
         ULIOvwOO1M0HAnng585UtwG2+UxtGGBcCWYgAUPrJ2Dxq5ItPEG/jSCtN74d6LSsRP
         D3h4fGtbOL4dkEK51iA2LouP7WUMwb9UOsSzpR8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artem Borisov <dedsa2002@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/49] HID: alps: Add AUI1657 device ID
Date:   Thu, 14 May 2020 14:52:27 -0400
Message-Id: <20200514185311.20294-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Borisov <dedsa2002@gmail.com>

[ Upstream commit 640e403b1fd24e7f31ac6f29f0b6a21d285ed729 ]

This device is used on Lenovo V130-15IKB variants and uses
the same registers as U1.

Signed-off-by: Artem Borisov <dedsa2002@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 1 +
 drivers/hid/hid-ids.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index fa704153cb00d..c2a2bd5288906 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -802,6 +802,7 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		break;
 	case HID_DEVICE_ID_ALPS_U1_DUAL:
 	case HID_DEVICE_ID_ALPS_U1:
+	case HID_DEVICE_ID_ALPS_1657:
 		data->dev_type = U1;
 		break;
 	default:
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ecb5ff8202ef3..cc2b6f497f539 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -81,7 +81,7 @@
 #define HID_DEVICE_ID_ALPS_U1		0x1215
 #define HID_DEVICE_ID_ALPS_T4_BTNLESS	0x120C
 #define HID_DEVICE_ID_ALPS_1222		0x1222
-
+#define HID_DEVICE_ID_ALPS_1657         0x121E
 
 #define USB_VENDOR_ID_AMI		0x046b
 #define USB_DEVICE_ID_AMI_VIRT_KEYBOARD_AND_MOUSE	0xff10
-- 
2.20.1

