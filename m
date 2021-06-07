Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2B39E34C
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhFGQWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233163AbhFGQUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7058561919;
        Mon,  7 Jun 2021 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082499;
        bh=iX2oTkmqyn78O4KlibLV5yCnz9KKb3Q9Wkez32DsvKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZG91LBNt7X2PdbBTppDwW4anqCUov+PF9Gcmbja00e6U/FriB+FgJDauw4i3oLYc
         nKOoEay5HSzM2RSR7m70Ldxhqe4Dbz0iPj0S9E/XNX9d5g9TgKK4EpEjOsP3ZHgNth
         gD5R/L4QrsXDSZZFju2M5h6MYFtqMlAAbJLwecOM8Af0iF7CdmZE19s8eP6NxoeQ2q
         ZQKPYFJHW/yvz041gNcHLM2+v8x/VbU4naGZFP1Hf+idveAZ/nzNlR/SRZwcvXIwYg
         EvlDkaeKyNuBEuPlAzaZAUjWlmKI+ZP/6bLoG5f22qIJcbNwFKkWYyKNHaxTwHbhE9
         eiM1agEbGLkVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/21] HID: gt683r: add missing MODULE_DEVICE_TABLE
Date:   Mon,  7 Jun 2021 12:14:35 -0400
Message-Id: <20210607161448.3584332-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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

