Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7DF40A05C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349229AbhIMWic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348597AbhIMWgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6333B61163;
        Mon, 13 Sep 2021 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572506;
        bh=ChKO3yV2jWanbE7mp7KQIXdToMns1bq9wGPUwwiK6r8=;
        h=From:To:Cc:Subject:Date:From;
        b=sWfXMzFKaKoySjbgljtRXgKDt5PX8yFeEW4NXNyD861v8hzglF4sOmcbBlyF3Vlfa
         UFNG06lsSPjWInBadAy/1+vi0S6q4T0rqULklJOzbgcckN+AYzoH6QUx/l1mRzABlm
         F6vvmnXqAozVEBRFt3lnJW5xgaH5R/+H1xXQ+guS65e/nyactymTsPQNWZxq4qmtQW
         j6z4xday5eMnYZcn8u9lvDIZcEc+PR9z265dQHpr4Gjd1GtBtVF9Ijmxu3ENl7NQqZ
         cJvnI2cMP1OFrsr5Xp6Te3afg1gmOzG4fVxm8lgKtRqy58kr+ySK3xKgf2bvlvI8XP
         tzvXyNPi3sGvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/12] dmaengine: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 13 Sep 2021 18:34:53 -0400
Message-Id: <20210913223504.436087-1-sashal@kernel.org>
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
index 8546ad034720..b966115bfad1 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1230,6 +1230,7 @@ static const struct of_device_id sprd_dma_match[] = {
 	{ .compatible = "sprd,sc9860-dma", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sprd_dma_match);
 
 static int __maybe_unused sprd_dma_runtime_suspend(struct device *dev)
 {
-- 
2.30.2

