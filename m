Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56F40A08C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343736AbhIMWjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349008AbhIMWh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB46161221;
        Mon, 13 Sep 2021 22:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572523;
        bh=5cCgx6kaz6HnDbPBulzbUIo35Q1e4DmFSGYnXaTROBo=;
        h=From:To:Cc:Subject:Date:From;
        b=o/69E4g9wJsCCu4EZEBjM2RzH9h0IirYd8jgbwbN11T1TgEWD34Yd6sqPBXZHrpI8
         MZ9M24C6agfiZkuD5KRd79Qxw/XW9TCyq1exY3P0Qe6BjcJWVaH4YNTA5+aWvt+QJm
         l+73I7KaYw180aPgPtzSa/j86+rCKp4BqzGrnuyHOEcNx4Hd+mg/fS32vLuWqVgDJg
         9D4GHlRInWMpu+IFN7HeF73GFVjZNGV3fVI+PI/QQld78zoW/Tb/e7qqoxwM26rSzv
         zRwLmJBpLp0WB/8NzZ8nQmR0scXyqf2FTVVX0r8N7g5kOEIYtdu7RZx0X0Pibhougp
         y3DlsBoF66iYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/10] dmaengine: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 13 Sep 2021 18:35:12 -0400
Message-Id: <20210913223521.436250-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 4faee8b65ec32346f8096e64c5fa1d5a73121742 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/1620094977-70146-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index 9e8ce56a83d8..0fadf6a08494 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1016,6 +1016,7 @@ static const struct of_device_id sprd_dma_match[] = {
 	{ .compatible = "sprd,sc9860-dma", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sprd_dma_match);
 
 static int __maybe_unused sprd_dma_runtime_suspend(struct device *dev)
 {
-- 
2.30.2

