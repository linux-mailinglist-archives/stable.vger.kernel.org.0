Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C263C900F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbhGNTxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240861AbhGNTuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9112A61447;
        Wed, 14 Jul 2021 19:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291971;
        bh=gJ97MK3ZaNLMzhFjGcee0H7XxD36w6LwNHEXwliqj1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FP0NSlO4CXlKFaJ4ba6N1dVTyxAP1LjgkqN7mg6rBnGvTmkirzSKGtGUzqRzqWEIV
         Lbpj32+8r3A1GY/aoZhRI/ChDYdJC0sBdFd7tbMW7vysiK4pwMWc8rRvY52oZkjKv/
         K8CoVjwi/p26QUvX3aDJwT8utRzRG3F3HpsJscq/zzCFU346pghrs0tJk6yrS7svOA
         wWfWbWSYIegAj4C7r1L8ZaA5K5U+9MkhPGgd5nuTciwbGmjmx8Gs6OQXKU35sFtfvP
         AB3d0wh45U6fytGeNXIF+2MTga75AHCel51GJcQBugmzhI3xQxueN8eCAgEQRevKqo
         HMr7ZEHv9acIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/51] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:45:03 -0400
Message-Id: <20210714194513.54827-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index c28271817e43..f526ce31f5a2 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1368,7 +1368,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

