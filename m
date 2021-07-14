Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704383C8D0F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhGNTng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235678AbhGNTnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA044613E3;
        Wed, 14 Jul 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291609;
        bh=w9tZZFUqI1/bAuznRfISYH+s4IBmqn8OqZSsZtScZjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/K7JCCHXO9uLsFlxPY5WuMk3caosRvkCuuIzgvzVawCyzZPjeG01VBwzkNNrYbRW
         CL6fW4Rq7MCpRXczkNrB+Yxu7RN+MsCW39IwIYQmJnyWx2DmUu5ycR5SFVNu/6TAHp
         nwsa5peocYH2BNYvUqYqnQzf7hi+SvvVQsOpixBHgN1Pvp8KCk+/DHKgB6CS0TRqlL
         oYBqOsOF9tH/nR2lNg90ed0djKy1db9pRLJz8dGqoUdnbsc5gK3nNV8iucPrKRh8fj
         rDP0ri23dHcwpfkuN4BLB49764ya499GiiQn7rnVoIAyZ3zC2N6/3KYpu/7ypto1JH
         SPX72wdorFQAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 089/108] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:37:41 -0400
Message-Id: <20210714193800.52097-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index d20b25f40d19..142dcf5e4a18 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1369,7 +1369,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

