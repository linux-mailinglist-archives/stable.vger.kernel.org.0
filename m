Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3101C2F3091
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbhALNHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388997AbhALM6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ECDC23333;
        Tue, 12 Jan 2021 12:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456257;
        bh=hYeILsnaxK+KNOA/EPB5IzZ+PmRqMc6c+QsaY+EWZpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBsiv3Cv8BQa+K6hvFMnWjjWFGpVkAiwTWJRTi7mmvJdpRi7sjjE6af3KhfIQZUcR
         Ohd9E7ur4XSndpAbngM2mKV1J0kVnBxeP+5kovC3gAd31FyojHx8KLn0KrofV9osF3
         FrrJt18PLjST6VQuuXO9C7lSjvAWh0GXRdjRKA6YPF7/f/GeDzmnVzW50rAjSE+/tI
         CG84Vs2HWxWstKkbcOp7HHFtlvcbVcplCyuoeu1uMGlkK5GBPfmke+tedgxHNm5a5q
         nNp7KmKItp2PXrns2NVsbMjMn+4b90zn8dfWZyw+y/jt4KZEJOgHICUQuUpY6WLKbM
         BZ2hqGrLO2xhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 08/16] dmaengine: stm32-mdma: fix STM32_MDMA_VERY_HIGH_PRIORITY value
Date:   Tue, 12 Jan 2021 07:57:17 -0500
Message-Id: <20210112125725.71014-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
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
index 9c6867916e890..0681c0fa44cfb 100644
--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -209,7 +209,7 @@
 #define STM32_MDMA_MAX_CHANNELS		63
 #define STM32_MDMA_MAX_REQUESTS		256
 #define STM32_MDMA_MAX_BURST		128
-#define STM32_MDMA_VERY_HIGH_PRIORITY	0x11
+#define STM32_MDMA_VERY_HIGH_PRIORITY	0x3
 
 enum stm32_mdma_trigger_mode {
 	STM32_MDMA_BUFFER,
-- 
2.27.0

