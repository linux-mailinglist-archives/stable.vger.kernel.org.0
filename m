Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78373C90AF
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239973AbhGNT4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238046AbhGNTuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DE47613D1;
        Wed, 14 Jul 2021 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292076;
        bh=YOgllG/rTEmQTDw1A015Rm1sGiBtgaiqWBPhjMR2xtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPfuphhw+PgbVzeTDHqlcd8vMwAfKdb40d8XDw8RwcAhQdglxSGSKpMb2JQr6V/O1
         1U5Hy77oLUyRE56EXn2axMMutadlvkYdKmb4VxZ3+KYIop6TCigp90Jv50eu2fGJjs
         uivWzQnXy299fI+YTeDYSBfYXdluoyzbf2VB/xkMmWt4LcWa5iIVaJOW2kRQJENC/i
         BzXnVYgHDVn4r7rL0wLDjpIPB43rLHfvFM21M/pOdjgZsfe0+G7W0OTECZq9jYx0wR
         698Qzhk5wRVF62NAkKqjHD1RfFvsT/pbal2uMYXeeQirdnEQdFOwplvF58dmA/5WNz
         U0qntlGWHfWMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/28] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Wed, 14 Jul 2021 15:47:17 -0400
Message-Id: <20210714194723.55677-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
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
index fcefafe7df48..2db83b555e59 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1304,7 +1304,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2

