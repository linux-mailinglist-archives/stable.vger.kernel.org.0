Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A7DD211
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfJRWIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387638AbfJRWIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF44205F4;
        Fri, 18 Oct 2019 22:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436496;
        bh=pmfg6LHYW/5retXYbGcvyYYHCQHShynOoxt3PYSYyg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYLsAUbm9akWUaM6kTRcRQnakWZUE9x4Tg08B4M76rmMkk9u/Y0lGz3dqXp87eUVK
         nrvsdANMKNZhZDiv0i7eYbjxHBuLHMq0MoTIXBP9BKM3IyYz7lT4oIBPN7vP7vzic2
         WJoU7B4CGyznwTp74vqsv0i9sDGq/eDC9FsZ7uu4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NOGUCHI Hiroshi <drvlabo@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/56] HID: Add ASUS T100CHI keyboard dock battery quirks
Date:   Fri, 18 Oct 2019 18:07:07 -0400
Message-Id: <20191018220753.10002-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NOGUCHI Hiroshi <drvlabo@gmail.com>

[ Upstream commit a767ffea05d2737f6542cd78458a84a157fa216d ]

Add ASUS Transbook T100CHI/T90CHI keyboard dock into battery quirk list, in
order to add specific implementation in hid-asus.

Signed-off-by: NOGUCHI Hiroshi <drvlabo@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d723185de3ba2..9d24fb0715ba3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -328,6 +328,9 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYMBOL,
 		USB_DEVICE_ID_SYMBOL_SCANNER_3),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
+		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.20.1

