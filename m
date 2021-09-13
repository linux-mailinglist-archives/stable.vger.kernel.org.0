Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ABF409FF9
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348705AbhIMWgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348557AbhIMWff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BCEB6112D;
        Mon, 13 Sep 2021 22:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572459;
        bh=KcQKMXCHSf32V5kefUSAG6IKXTR47MANSbljlgPuYF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KS+K55rRI7UlnLsexzR8kklCVmJE+EPwMrzyZvvqw4SKTVCjExUD6nZ3v62LgG/hO
         obJZyk75aBJXJWjX3tGp1TbfMuZPd29gGbelNiAT2pO662SfW71QMSxe7aiE2+QQnB
         boSqusJG/4cIflBNh5zkAN5sSCp06CclgXFs+cWQSDgzhn4jtnbPtOC1gpD026MMqX
         G6Cqe7qp+TBN2xJ7vIJPdiX+0eBF5ymiwQbvzqsUv3u7fKjrEYHBBB++1isKS+xqAx
         E4YUK5w9alj7ION2ST4LXqChrMcy0497r90YinqfMt7stwAndm7oj1Ly0nyRJy7OYG
         7cOepeCwGu3JQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 02/19] dmaengine: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 13 Sep 2021 18:33:58 -0400
Message-Id: <20210913223415.435654-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
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
index 0ef5ca81ba4d..4357d2395e6b 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -1265,6 +1265,7 @@ static const struct of_device_id sprd_dma_match[] = {
 	{ .compatible = "sprd,sc9860-dma", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sprd_dma_match);
 
 static int __maybe_unused sprd_dma_runtime_suspend(struct device *dev)
 {
-- 
2.30.2

