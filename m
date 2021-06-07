Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D78839E3AD
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhFGQ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233755AbhFGQY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ED9461947;
        Mon,  7 Jun 2021 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082552;
        bh=iX2oTkmqyn78O4KlibLV5yCnz9KKb3Q9Wkez32DsvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5XXqcVSDewznlHjWgmilccIkUGH4if9nr2nfJlX4KBZMrPishF1HHwm4Cspeo0eq
         0FIkagAyQ+MHvudoA0KZEDW/bumAbd+u5pKsM+4pFwHNll2NoXmOrkkjgz9FvnISn3
         5LXOpFyZGjfW3+Rm9HozZqfHqFgzS5euBg0cVDm0NqWy98E5BkOg4aWAqTL4gFoOy7
         3lU9MhAwnpwO68knaG6r1jEqT//XQrFyTdo2HXd5WYIekKXLz7TYG9Jk/4lOlrezuO
         q5TpYhfqz5BJgfNGQKV5IVBwJzkdVLmlZtGfxgSjb0vMFG8XQvNFu/XM9JyPYAsidi
         ceD7NHx7q3wAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/15] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:15:34 -0400
Message-Id: <20210607161543.3584778-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161543.3584778-1-sashal@kernel.org>
References: <20210607161543.3584778-1-sashal@kernel.org>
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
index a298fbd8db6b..8ca4c1baeda8 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -64,6 +64,7 @@ static const struct hid_device_id gt683r_led_id[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MSI, USB_DEVICE_ID_MSI_GT683R_LED_PANEL) },
 	{ }
 };
+MODULE_DEVICE_TABLE(hid, gt683r_led_id);
 
 static void gt683r_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
-- 
2.30.2

