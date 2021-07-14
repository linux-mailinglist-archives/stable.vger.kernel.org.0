Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833CE3C90C9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240910AbhGNT4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239612AbhGNTvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0745613E7;
        Wed, 14 Jul 2021 19:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292105;
        bh=BPGP7kAqzRtSLT9c08RnyYtw0hF41Mq4npPZwFu0SwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnJu6s2I/EAU03cLPr74HIzlsDlBAgkdzFGMOv2aKUMioypp4U6ITTbM47vK3zNe/
         SQX+ojBG8PKQ87ILkjXkEJeAVkWLmzIs9GbCmxoCQOaVTFHttUVcpi6MyFH++m/6Nn
         rbccjYgf2iqefcJIysVrsqcKGcFom0Ji9yoaZDHiGbfPsqI4bJ2or7sZrHk/LRSCP4
         PYVFVkjK7VTxm0SzvV+x2dtbOpyzucSkronZrXv5bN3wVn36EfqaChHTTxUlk9nVTU
         xp+/6GMkMAXJ325uVIXI5IgmxfoURPH2DNKDoVs79cRTXC+wk0lfzdToXqgOoUncaP
         4MQ4bdQVD/Wxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/18] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:48:01 -0400
Message-Id: <20210714194806.55962-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
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
index 90c033b4ec98..4c2dc3a59eb5 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -2027,7 +2027,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

