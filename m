Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E891D3BC0
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgENTFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgENSyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F5C2065F;
        Thu, 14 May 2020 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482459;
        bh=dI6E9BtFZXihxAb90DGuTg/JK1pbhVNFfmOLycUnEE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuSB1KXoSEUK2/YysQIWWtLj2bjpAQ2YqMgQ9H+BUrbsfYdKjMGNmhzeEJfMQW5jw
         YY148muwdliAJJSFzcrZWlxv5hXudFixBi3z+W9qz+GosUw5ZUIpMBQPG9tq/yl/bU
         LgFOT122T3TYeYUW2HNsDmMlAnqs5slLkl5QlXak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Artem Borisov <dedsa2002@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/31] HID: alps: Add AUI1657 device ID
Date:   Thu, 14 May 2020 14:53:46 -0400
Message-Id: <20200514185413.20755-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185413.20755-1-sashal@kernel.org>
References: <20200514185413.20755-1-sashal@kernel.org>
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
index 895f49b565ee1..28ca21014bbe4 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -806,6 +806,7 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		break;
 	case HID_DEVICE_ID_ALPS_U1_DUAL:
 	case HID_DEVICE_ID_ALPS_U1:
+	case HID_DEVICE_ID_ALPS_1657:
 		data->dev_type = U1;
 		break;
 	default:
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ae145bdcd83d5..53ac5e1ab4bc5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -83,7 +83,7 @@
 #define HID_DEVICE_ID_ALPS_U1		0x1215
 #define HID_DEVICE_ID_ALPS_T4_BTNLESS	0x120C
 #define HID_DEVICE_ID_ALPS_1222		0x1222
-
+#define HID_DEVICE_ID_ALPS_1657         0x121E
 
 #define USB_VENDOR_ID_AMI		0x046b
 #define USB_DEVICE_ID_AMI_VIRT_KEYBOARD_AND_MOUSE	0xff10
-- 
2.20.1

