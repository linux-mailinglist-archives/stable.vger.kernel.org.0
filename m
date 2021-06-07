Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23E839E271
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhFGQQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231872AbhFGQPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF69361436;
        Mon,  7 Jun 2021 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082420;
        bh=rUw7BP8oocyKNmIl1hMRQzzuNIHS6uWhK3wZKD7ChF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdeImgUt8rbZs3pdCWg7/rF7ItAxnpCCD+V9n6onBP9rhNlLvjL6RV8opxBNdVX2a
         AM889jgfnIH6zNSz05AJk4Ri4occfBoMTzcawSwLkBn0p9xmaX8TzO1O9qoFugHZ5c
         5C2I1o6TelUuVXY6olUQs8lqf+NJJyGXaY5nG2rARiEpEkSKm0i2mzSfHwgdqLoCCy
         xzRR9NBcSOTmxly7b2yDnSI3+BU5F+lFVJKsJEMzGEJjGlEJlOnUDULbVkxL9GuAc9
         z7AzOQeayVrLQDKeKGmx9lzkuq6JHbpILRy65ilHa98mGlwXtuHtlqJ+Vvu7zwv1O4
         797ZRzVePOF9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/39] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:12:56 -0400
Message-Id: <20210607161318.3583636-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit a4b494099ad657f1cb85436d333cf38870ee95bc ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-gt683r.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
index 898871c8c768..29ccb0accfba 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -54,6 +54,7 @@ static const struct hid_device_id gt683r_led_id[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ }
 };
+MODULE_DEVICE_TABLE(hid, gt683r_led_id);
 
 static void gt683r_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
-- 
2.30.2

