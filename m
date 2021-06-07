Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9939E3BE
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhFGQ1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234109AbhFGQZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4642861968;
        Mon,  7 Jun 2021 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082573;
        bh=HwpxsgAChI3appF7vYXNAKvtNsTrqaZtbpQMfXgyQ8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvxjrgo2/ArdvheGsV0oGEfCc/9f93qsdnVBH4kCXNzbgrR3SaURNPStu8eS5FSxg
         40CsgnO8LmbTMNm3c2POh39XQBt7TgBE8/ZXmx7zryDDkBrJ5qfs1M7+1qWF6u8bCl
         +S2NS22jWqOU60f4uzuKMW9D2bh8P9eXagfZsPOI5yV1F2kqmkQR1H9XBIpi7WSzuL
         5jtzw0t91tsWur9ZLw6HVfbVyOsL9ivAkPU/i6Lr1TBKRqIi/Jp9D4JXLbBkpnMhFn
         vs1yxHAbq0YRAzKdfNKFM70mCQLaAK6/buZKT1rbTuJAw3hfFERj1cv8rUuoNNUYEd
         7Pck5D7PbhW1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/14] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:15:56 -0400
Message-Id: <20210607161605.3584954-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161605.3584954-1-sashal@kernel.org>
References: <20210607161605.3584954-1-sashal@kernel.org>
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
index 0d6f135e266c..2991957bbb7f 100644
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

