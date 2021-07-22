Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DDA3D27D7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhGVPxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhGVPxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6EF56135A;
        Thu, 22 Jul 2021 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971624;
        bh=Dm44ZTuyFLTe7BC6WcffA5iHC3xPeWaJvcnAeXFd1bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeT53vCn9RdngqYhCPP4VkSY44jVKwb//AW66ERCbVTPWUJXLD+nznq6a6ALm8034
         FFGia2Tx9FFpRESrLQUQmhOZViA8djAI1+oScCjg9zgo4/OJ9z/SXLsT+7Eju+bcTs
         PFSgaLaIruIiChgEOf9JzWph194G31VvOaWVF094=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/71] thermal/core: Correct function name thermal_zone_device_unregister()
Date:   Thu, 22 Jul 2021 18:31:10 +0200
Message-Id: <20210722155619.033835050@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
index c28271817e43..f526ce31f5a2 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1368,7 +1368,7 @@ free_tz:
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
- * thermal_device_unregister - removes the registered thermal zone device
+ * thermal_zone_device_unregister - removes the registered thermal zone device
  * @tz: the thermal zone device to remove
  */
 void thermal_zone_device_unregister(struct thermal_zone_device *tz)
-- 
2.30.2



