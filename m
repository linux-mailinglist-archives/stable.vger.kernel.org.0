Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFC23AF253
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhFURyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhFURyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A746D6115B;
        Mon, 21 Jun 2021 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297923;
        bh=6Ux5b6a9qHKsFP5h01H/H9/xS8S+LH1LvFk7iEG6NtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfgBucrmXImsq5IneI6/czjcotHOT0mn1qp+azZjXjZb1KOOk/vPFWf6/qBOqfUNA
         1Ym3jfE048cbVZYXKjitlGOia+eJm3C4c9IR5j89LDvfXh8yt0PQkXVMKQb2+K4DYw
         QtNPJBkXenRpoeZIaa7n5SIHSHqz85D4Kso0p9+SV0vlz2MQE0YGLZZuhlUIt2qznf
         cHKbePe4AjkA2NwQGr7/Y9oiCWhW1FyX7shL6+sK50P/kTRbIV9eg8ttRKuqsflC0B
         TXakC/QZxubAUzJyUL8oBaMgfkQh2yVu5VM80ffd/Z2KECQmHWb9VX5XOwtJHTBKWd
         seibrpO7mkiZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 03/39] dmaengine: xilinx: dpdma: Add missing dependencies to Kconfig
Date:   Mon, 21 Jun 2021 13:51:19 -0400
Message-Id: <20210621175156.735062-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 32828b82fb875b06511918b139d3a3cd93d34262 ]

The driver depends on both OF and IOMEM support, express those
dependencies in Kconfig. This fixes a build failure on S390 reported by
the 0day bot.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Reviewed-by: Jianqiang Chen <jianqiang.chen@xilinx.com>
Link: https://lore.kernel.org/r/20210520152420.23986-2-laurent.pinchart@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 0c2827fd8c19..4ae8f8ff960d 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -689,6 +689,7 @@ config XILINX_ZYNQMP_DMA
 
 config XILINX_ZYNQMP_DPDMA
 	tristate "Xilinx DPDMA Engine"
+	depends on HAS_IOMEM && OF
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.30.2

