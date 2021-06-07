Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F439E2FE
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhFGQUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhFGQSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C1DF61407;
        Mon,  7 Jun 2021 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082466;
        bh=rUw7BP8oocyKNmIl1hMRQzzuNIHS6uWhK3wZKD7ChF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCxp3tc/AhhHESICk59d3Ne/V46Y3Qbqo9RjeUaodE1ihWquCv/kRFryoz0fLwGoq
         yjg12GPEpbDcYxq9wdi2CrN1R0lkUnNNRv4J24sEs3LVPMXGbAjZVot2OqYS2T7M7c
         095QDcr9TQr01XuFLBOOYQ8Fw/IxAyfMppUGG/QuugNQr+2pDTTQUGVnAvknAXaW3+
         s2HJV7X5VrHxADqXMQXBEPS7t1PaHl2Xp2bw0DMpMikd9fk0h+R8KOz0vGvnfrfUAM
         +4zAj57zVzHgJ1cAkhVL0537AoAb49bv5j0xu/mc77PrNroI7DONypyuUg88vntr4Y
         v8fbVjJtF/Lyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/29] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:13:53 -0400
Message-Id: <20210607161410.3584036-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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

