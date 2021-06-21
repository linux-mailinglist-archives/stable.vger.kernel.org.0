Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22733AF2D3
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 19:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhFUR4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 13:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhFURzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B30F61261;
        Mon, 21 Jun 2021 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297986;
        bh=7EreFG/emYHXrrvb8h8kEu7VTuEN3fg0lEJOjVFNiKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwbZ0xsfwEA++msXb6NFk1zSwCCpftomG1CPzjR489UVYBc6W7PoxvDM829qkBbAD
         C5GOB99zGQF1tmr8Rhe/htJ86xHQsWzC8WC3ahrxAKM/btzwcLEfIEcKpsWi/Jz+e0
         uPNWDp3rM0cFMKvleNWk10igssoVIqigp2X3xlfgEvkv04WBzvzox0v3CTkCUdIYTv
         lN1/XOeX+ENZOEd4GPQ/KRpxZOrE9eXbPU4Y4SSOeg4yE5lbmBn3u/GS8s+GdtzLgW
         WfBkwyGAu0Wj+jjq5/f4HhizEX9AGqbKS2dtaCBzhsijDJl7eT1UuAsGETc4cICax3
         aEJMfb0QEcvoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/35] dmaengine: xilinx: dpdma: Add missing dependencies to Kconfig
Date:   Mon, 21 Jun 2021 13:52:28 -0400
Message-Id: <20210621175300.735437-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index 90284ffda58a..a64529bd6fb4 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -692,6 +692,7 @@ config XILINX_ZYNQMP_DMA
 
 config XILINX_ZYNQMP_DPDMA
 	tristate "Xilinx DPDMA Engine"
+	depends on HAS_IOMEM && OF
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.30.2

