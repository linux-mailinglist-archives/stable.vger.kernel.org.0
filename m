Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20F51E2C37
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404234AbgEZTNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404202AbgEZTNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF44208B6;
        Tue, 26 May 2020 19:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520399;
        bh=O0RPL3irJhWBZ5F2H3BdlvfzT93fhcXBDbqTToK9uYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iREhB2WHabqupBHJTM4z6VnmcNH13fDlzCn9nftkYn2VBS1CvRymtKAbOmoSNvrzz
         nmDp8mDUa14F7wiUzguCehej5jz27Y7pPkVhi/kaJzdlL77avX5AbsN/PvQhi3Hx3U
         Qmmi27riace2Lb5x1ZCvcVG6zemX3GTpSwbhXfhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Borisov <dedsa2002@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 027/126] HID: alps: Add AUI1657 device ID
Date:   Tue, 26 May 2020 20:52:44 +0200
Message-Id: <20200526183940.032179250@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fa704153cb00..c2a2bd528890 100644
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
index 40697af0ca35..7d769ca864a7 100644
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
2.25.1



