Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF203D5E1F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbhGZPFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236118AbhGZPFY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F7460F5C;
        Mon, 26 Jul 2021 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314353;
        bh=j9h5+omN5Hw1yhJgU//fyND+E6Yj6TdXbCZq/YA4d2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew1w6SKAH+2kvgrfw/5EoRAuG/McAphWZbcDJVIFmbzEDNVkwTsub2pXkiyGLr2ri
         I+KOQSZ+CmC2vICLEK1MgKGUH00pUomKUYpGSCV9kbAi9+gzDIDuTNCoSNrjCpn1VP
         1B+glZiZOQKXxtiVNqgEJWUKPqfVCvWmZ9TYLuRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/82] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Mon, 26 Jul 2021 17:38:17 +0200
Message-Id: <20210726153828.720075964@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index fcefafe7df48..2db83b555e59 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1304,7 +1304,7 @@ free_tz:
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2



