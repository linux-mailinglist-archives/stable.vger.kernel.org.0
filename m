Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9683CE5DE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350157AbhGSPyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350564AbhGSPvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EAFD613BB;
        Mon, 19 Jul 2021 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712227;
        bh=0LbTZl/GtSu1ou7FYQwLRq1cIOY8xCp9qEaU6uDpBGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfQlDkiNDbFTRvCmagf5lxV9myHVbGuo5VlpL3E2W2I2alnu+huXQwfKvJqMwjE+6
         ywstGbo4A7sb0a3XL+aiB8u1I5YoPrI336j1XcSRCK/89qvFe9mg7gHp+GpLoxm3h0
         Q/YRoNtmWTfBBuq6zgZIO03/74yj8sxLpI6VzUIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 267/292] thermal/drivers/sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:55:29 +0200
Message-Id: <20210719144951.700846367@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit 4d57fd9aeaa013a245bf1fade81e2c30a5efd491 ]

MODULE_DEVICE_TABLE is used to extract the device information out of the
driver and builds a table when being compiled. If using this macro,
kernel can find the driver if available when the device is plugged in,
and then loads that driver and initializes the device.

Fixes: 554fdbaf19b18 ("thermal: sprd: Add Spreadtrum thermal driver support")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210512093752.243168-1-zhang.lyra@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/sprd_thermal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/sprd_thermal.c b/drivers/thermal/sprd_thermal.c
index 3682edb2f466..fe06cccf14b3 100644
--- a/drivers/thermal/sprd_thermal.c
+++ b/drivers/thermal/sprd_thermal.c
@@ -532,6 +532,7 @@ static const struct of_device_id sprd_thermal_of_match[] = {
 	{ .compatible = "sprd,ums512-thermal", .data = &ums512_data },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sprd_thermal_of_match);
 
 static const struct dev_pm_ops sprd_thermal_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(sprd_thm_suspend, sprd_thm_resume)
-- 
2.30.2



