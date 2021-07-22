Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D173D29C4
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhGVQGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbhGVQFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE4761CAD;
        Thu, 22 Jul 2021 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972353;
        bh=OuL3nFFxsHIefUp/w9WmZlloQZUmHBrSmakM+iMhcMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppYrqu5fVQnDG7ruqnNYTVqenudt/f6e55oiLG3K7+WZG6z4yCzsrGJuPHfqgHJxB
         t3Px+kTLO+6T610VdI+kkjNb3wsKK1L91oMoBjpTDhPPWUq+fKqHWxuMm/1jwxB3GR
         yzFcLzxqUQYpHRQMndEur3ApCJ3xs2mVGYejvBwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 082/156] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Thu, 22 Jul 2021 18:30:57 +0200
Message-Id: <20210722155631.042042041@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1369,7 +1369,7 @@ free_tz:
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2



