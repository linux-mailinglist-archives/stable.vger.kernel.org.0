Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C3C40A035
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbhIMWhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348676AbhIMWgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 405956124D;
        Mon, 13 Sep 2021 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572484;
        bh=C2jMisGe6Hpa3CETJrk1NnMegofXErxuA/YmCw7WfKc=;
        h=From:To:Cc:Subject:Date:From;
        b=m0MoSTmz4gEUs+fwV/K7MO0PtrEKSYIGxF1QHamTJ03pIQZerlHdwj4yiViVAnq3v
         lWzWI9KkCV/AgsQDD+oxiWMFof6aq7X5Hz9u2QNGrLZaqyFuDczex8rVLTxydzNv+D
         tD8iMLsGCmvHpjpa7qwHSYx48u3Jbu5PWmFpbIcLNzxzQBqpRE8WS/wBeXDlEOYSiK
         bh9rlcZ+D3hSsEQgo4fxvaNn3hKHZ/oNUFWNNbVJE/PMx33U5p3c06ouP2fNpTPa8U
         OB0YwRrLI0Zmrw8E7+4HTglghGok0u3f+l5fJq5BohBilM343BQF9d5HCzFYspG45z
         Lykr9mWBaImSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/16] dmaengine: idxd: depends on !UML
Date:   Mon, 13 Sep 2021 18:34:27 -0400
Message-Id: <20210913223442.435885-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b2296eeac91555bd13f774efa7ab7d4b12fb71ef ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20210625103810.fe877ae0aef4.If240438e3f50ae226f3f755fc46ea498c6858393@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f28bb2334e74..3a745e8a0f42 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -285,7 +285,7 @@ config INTEL_IDMA64
 
 config INTEL_IDXD
 	tristate "Intel Data Accelerators support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	depends on PCI_MSI
 	depends on SBITMAP
 	select DMA_ENGINE
-- 
2.30.2

