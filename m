Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3117F417379
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345169AbhIXM4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbhIXMyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C65461353;
        Fri, 24 Sep 2021 12:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487847;
        bh=s9AFFSU76Tc7byx5Fnxe3gcbcaQzNB8UlIPYom6Yna8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7LMIWGJp3TiWv4lDSF0iVLla8MQQK4qF2VzXCJT1TRoch40l8kXEJnkdh8TZ4u5g
         dMS9oPmT9TXkgLPSJZNOEKL2Wn9ugG9vhm6Gq3XhictDqyZlUR7a1d++izWCL+rhVu
         snpx94nE3Nlb6nxjT2TnhfrkoiCt9/o4Lc33jLbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/50] dmaengine: sprd: Add missing MODULE_DEVICE_TABLE
Date:   Fri, 24 Sep 2021 14:44:22 +0200
Message-Id: <20210924124333.364776155@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
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
2.33.0



