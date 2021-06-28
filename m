Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7543B5FF1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhF1OVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232768AbhF1OVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941A961C80;
        Mon, 28 Jun 2021 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889931;
        bh=94Dk+RyswTwYCQi4Pdh5ngigt3yLDRnjcPT93oze534=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyTc/AADqvscJdjYVtK/x8qDM8FmXApvgk5vTUZR01O/kaDatvpb2x5s6BlKmuwuq
         SfZK71mATbKRFfTUZFBn88zPQ013O8mWlau2811zvpgaWH0KmTwDAWDlIi9h+tXT03
         enYafjn43MhQR4W76Io7yOeeBXvpbW9loNHHaaKFitP1/EcAUH82DyiyHJRxIEGBLQ
         2bWqVKxl9ZPLBPtJhtPHcb98V4Bk8dX1pYDJqbPeG4az8bBH/uuqldvg2wVPQDqyw0
         o1EfFnVE5msF8hmSxEAnGBnJooy/DRU4LhmJ0dkeSaMnnAWKBFxdHolODlmbNCY55Z
         Jcm6fwWvGFgHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 024/110] dmaengine: xilinx: dpdma: Add missing dependencies to Kconfig
Date:   Mon, 28 Jun 2021 10:17:02 -0400
Message-Id: <20210628141828.31757-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index 03b1b0334947..c42b17b76640 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -690,6 +690,7 @@ config XILINX_ZYNQMP_DMA
 
 config XILINX_ZYNQMP_DPDMA
 	tristate "Xilinx DPDMA Engine"
+	depends on HAS_IOMEM && OF
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.30.2

