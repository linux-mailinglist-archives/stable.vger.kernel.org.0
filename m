Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3B3B60EB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhF1ObM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234589AbhF1OaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06ADE61C97;
        Mon, 28 Jun 2021 14:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890390;
        bh=6DUZlkFR3/bdI7g2/CgAjsD1Rm3oC4ULjjzGd/lZAHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDpTV4t04KO57+LA8Ot2DSe03DBc2BtIQLsGvxl2fG9VJ3DSymfqMt5jTx34kNMkH
         i3BffSlETFhjaMseQ4p22tZnOnZSnQIr0qeZXi+XseLaxdoPEQq4UcWm0Q4B0/SMKo
         FEBJPOD8UPVTaKayEO0yqZ/hor7lT0wzlrSE6VMflG/Es90mVe19CEIx+4CnFE1L3l
         Y87booAGpHaea3IOy2UFloDyMNIHDuJ0xwGIA/p2pV8QxJx0Gv8J4as6AInOqAbM2c
         alBq+aYOx4rppM9AcDSlASST2PHQreC0HktFaNN988LR/ZOkK6AHZhxbaikyn6mIaF
         7dWPEqkFRGqDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel test robot <lkp@intel.com>,
        Jianqiang Chen <jianqiang.chen@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/101] dmaengine: xilinx: dpdma: Add missing dependencies to Kconfig
Date:   Mon, 28 Jun 2021 10:24:50 -0400
Message-Id: <20210628142607.32218-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index f2db761ee548..f28bb2334e74 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -693,6 +693,7 @@ config XILINX_ZYNQMP_DMA
 
 config XILINX_ZYNQMP_DPDMA
 	tristate "Xilinx DPDMA Engine"
+	depends on HAS_IOMEM && OF
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.30.2

