Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7839E1FE
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhFGQOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhFGQOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D919F613F9;
        Mon,  7 Jun 2021 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082365;
        bh=rUw7BP8oocyKNmIl1hMRQzzuNIHS6uWhK3wZKD7ChF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUo2Wrn3T8+Vbv4kztbeI5rd5ZCtglZf84L7Fnr9miaOgpxfZZse50hrf5uROrl9V
         +a9tciGdLjwKWR4EQ2OauoZUYn6HazjuSMErtGLxVRADXFQh+U+jRFBBojg634sbh9
         Ak0aGdX5cpIK3VrQoRvD78Vyb9sGCOjP/zFyivw+/lxNCZIL74Mvbwi4oTIC/LOKo2
         0+2ZKsHE/zjo5QQaYX1iV8QA4OZ1d4GlQEmWPgKeWFohl4zS4AIkC/w8cOjy2sODHF
         IxNDOTe3ye/+g1pxnOOgBDyDfdhZMW1aFlnlXyPuGWPMyckNroPQ1WjkefIsXqF9UL
         503UFafgRCATg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 24/49] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:11:50 -0400
Message-Id: <20210607161215.3583176-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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

