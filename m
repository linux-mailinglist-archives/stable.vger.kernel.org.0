Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6472F30D3
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbhALNL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:11:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404467AbhALM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FEA2312F;
        Tue, 12 Jan 2021 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456225;
        bh=1QwLMri3SSpbBR2zKEJETlU4KFc1vge8Amlgwsv0Q4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggKin2tkgY8CXigN0XEfgXQapLJUP3hsVwGsqjXkpw8RntHZpZqBjOqXAsFDSPlxC
         QeuUuWL4/3MkWWCRfBikBy2Ax3o6UHXanEIu4lprjfBrP/iSBEaKuodYBeIFeg2yhh
         213idhxl3G0A9EtJzMdlAVh3LE5MKye/WNlifl0tZHQC8JPKJY6kLeF6EZuVP/EUud
         k40DckaM8/27TeOFqkfYHh25sL4OXxjckyosyjSrgO8Ey7KmpQY7N3qJE+60aQ7mku
         q5Au5LMEWWlETFi2px7vbcWibENlKO2vvfFSbx+7FSZ2n2pwOKC+lH+gWjN8qfk24F
         TefSGCyrKdmJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 15/28] dmaengine: stm32-mdma: fix STM32_MDMA_VERY_HIGH_PRIORITY value
Date:   Tue, 12 Jan 2021 07:56:31 -0500
Message-Id: <20210112125645.70739-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit e1263f9277bad198c2acc8092a41aea1edbea0e4 ]

STM32_MDMA_VERY_HIGH_PRIORITY is b11 not 0x11, so fix it with 0x3.

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20210104142045.25583-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32-mdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32-mdma.c b/drivers/dma/stm32-mdma.c
index ee1cbf3be75d5..718f0779ac598 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -199,7 +199,7 @@
 #define STM32_MDMA_MAX_CHANNELS		63
 #define STM32_MDMA_MAX_REQUESTS		256
 #define STM32_MDMA_MAX_BURST		128
-#define STM32_MDMA_VERY_HIGH_PRIORITY	0x11
+#define STM32_MDMA_VERY_HIGH_PRIORITY	0x3
 
 enum stm32_mdma_trigger_mode {
 	STM32_MDMA_BUFFER,
-- 
2.27.0

