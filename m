Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCAD3C8F8D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbhGNTws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240197AbhGNTte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24923613F1;
        Wed, 14 Jul 2021 19:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291889;
        bh=LAWtmPwq4OKsIbbQhQU9irTB3MUcZE1xFLU1T4MabYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I72XSoC59dbznbes3c7/HR8P5xxfL9Z2Izm8k910VNski5B5Me8hXDa1i/p1w8SQn
         kkaAMvgfr00HbHVvsyf0KJe92kbiv/NdjLui4ZEBOS9vL43kdac/2vcF4RIfd2s+ZF
         H9OAHGP5WOe3E8NksWF9ZTos80GOF5uE7Ihu8FNRKaXzls803quoIu4oeMTmH0AiXc
         dPhoN/B1Mi0glXQhTFRrEucsuCw2ASKYWeQTTZ0/Ug/5i4EzZIDY1ZCHE2oguNOMG1
         wRXRcWySoE1oU9Z4bRYETx2iDyQvbYKK4c6v0cW1hURAjn0V1anAhTAMhLJdDy+u1y
         VYElOeuAu0VVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 71/88] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:42:46 -0400
Message-Id: <20210714194303.54028-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a052b5118f13febac1bd901fe0b7a807b9d6b51c ]

Fix the following make W=1 kernel build warning:

  drivers/thermal/thermal_core.c:1376: warning: expecting prototype for thermal_device_unregister(). Prototype was for thermal_zone_device_unregister() instead

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210517051020.3463536-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index c6d74bc1c90b..e669f83faa3c 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1509,7 +1509,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

