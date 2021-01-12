Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2632F3146
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389906AbhALM5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389896AbhALM5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A1B23135;
        Tue, 12 Jan 2021 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456174;
        bh=wYJJZ/HtArnsWwAlshvCqcvA9V9//VhtLhQMxbX0esU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7ibkV5zAwPA2svHqdnBIMJhHLiplgs3/6CuDQ7LX+x92g+eoYE/F2pvdsEdCIfB7
         00WFCDHUxhgi6DlZ9FLO89CCTclXBgZtjt8UrAqi+ismjtkq+4NG2bZJgfIYYPF450
         RxTEEpCCwcquxx326iCbESb+F6YTEat15xGAwt2y9L5TbTxIiN9qVkQm9bdf3Lzx1j
         QByFtGTFaOCSw6h7hmX3mvKXSsTVfqjsomiGCen751VncB9EXsNEDHph3heVqaqu3d
         W1U3l03VmVly9oYarbecstgN3V8fBc9yJnths/E6M8wY8aAsuWhz6f3MNIyq5Tz7gZ
         ouRj16PYP2DGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 30/51] dmaengine: stm32-mdma: fix STM32_MDMA_VERY_HIGH_PRIORITY value
Date:   Tue, 12 Jan 2021 07:55:12 -0500
Message-Id: <20210112125534.70280-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index 08cfbfab837bb..ca97cbe433651 100644
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

