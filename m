Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61D83C90D3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238637AbhGNT4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239812AbhGNTwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D0036142C;
        Wed, 14 Jul 2021 19:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292123;
        bh=3cBQ7XdQtWKMtan40ktXOh0D1M3y8inbTR4c5OblRIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpUB03ndlnKKKh1iqAPbwmHypk4Sy5wA3k4pgtRk2awf+PkK/Lzhpr7nW9tFcVRf1
         UiFSu8cRgo3UQ6f2BQ0FRpQ+JotieafHvYuZnWYXgwsaoOJfh76Obc/nmJREjf2k7M
         KhbwBWTmKMh0b2l7nSDxvecc4tpg3pGfyZEeHBpt+e4x2buRNa8KN/tgco0k7Tn22h
         f76Y5HrnxBlmpTqQzQ/rRnxPQLTIRh30yYtbq4xLS7FXjThRqNmfWYBoPMFTssVVu3
         kShyxD+UpkkDHSkjepdgpkCOwglVR+pANWkRPWMQLq6ywDHqEh3yLxQpOZDDjqpDIL
         3vpsheL2Kc69Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/10] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:48:30 -0400
Message-Id: <20210714194833.56197-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194833.56197-1-sashal@kernel.org>
References: <20210714194833.56197-1-sashal@kernel.org>
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
index a6df07786362..94497787a076 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1956,7 +1956,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

