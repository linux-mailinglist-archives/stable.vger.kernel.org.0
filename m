Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63860417517
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhIXNOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346492AbhIXNL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4CB615A2;
        Fri, 24 Sep 2021 12:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488325;
        bh=Fe0u47UtFxmHHLPrc9Z6tjunTngUMbu/DcOtnGOPw1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WW+eFvPuwYz9aJ+4shKmKV8evEWiySu4RVAEwsNfHVt7+xZHhtUJBdXPzdnx66Be
         9u/BscgbY1O6dsi1m/2m9kTJb75OhstbqBgJ9z2/eEixjAEv2LcvXhow87rSViD8+Q
         8e7g2+HzeeXurwNI0nhkQMposKGrFyPvvNE1fyFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/63] dmaengine: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Fri, 24 Sep 2021 14:44:41 +0200
Message-Id: <20210924124335.685755646@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



