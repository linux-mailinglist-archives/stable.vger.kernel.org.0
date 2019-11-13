Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89ABCFA4AA
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfKMBzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfKMBzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8257522469;
        Wed, 13 Nov 2019 01:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610146;
        bh=Hk1LfhPBk8mf4j0A6gLA3Gxbg20jEn3kThQ4rBD+a2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Khmou61yh0tFUK8KFT1/bc4QXZAD1izlob7H8/8jZdPHNndd/ZNdz2pJfsqdkaRoK
         fMTla7MxzfVvWhnKS//UvgTPq8uSohLGzWlJkt5w1R7wiGMOaMIAf7xWCB4b31HLaf
         2hzOWvZVqmNf935fNildLJwGgXFrFpY8qgX/EaYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kun Yi <kunyi@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 192/209] hwmon: (npcm-750-pwm-fan) Change initial pwm target to 255
Date:   Tue, 12 Nov 2019 20:50:08 -0500
Message-Id: <20191113015025.9685-192-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kun Yi <kunyi@google.com>

[ Upstream commit f21c8e753b1dcb8f9e5b096db1f7f4e6fdfa7258 ]

Change initial PWM target to 255 to prevent overheating, for example
when BMC hangs in userspace or when userspace fan control application is
not implemented yet.

Signed-off-by: Kun Yi <kunyi@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/npcm750-pwm-fan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/npcm750-pwm-fan.c b/drivers/hwmon/npcm750-pwm-fan.c
index b998f9fbed41e..979b579bc118f 100644
--- a/drivers/hwmon/npcm750-pwm-fan.c
+++ b/drivers/hwmon/npcm750-pwm-fan.c
@@ -52,7 +52,7 @@
 
 /* Define the Counter Register, value = 100 for match 100% */
 #define NPCM7XX_PWM_COUNTER_DEFAULT_NUM		255
-#define NPCM7XX_PWM_CMR_DEFAULT_NUM		127
+#define NPCM7XX_PWM_CMR_DEFAULT_NUM		255
 #define NPCM7XX_PWM_CMR_MAX			255
 
 /* default all PWM channels PRESCALE2 = 1 */
-- 
2.20.1

