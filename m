Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38C409FB6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhIMWe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236640AbhIMWe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E9D660EB4;
        Mon, 13 Sep 2021 22:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572421;
        bh=mZ6OLkFdQUsjQrobdyWliBhZeMi9SF3Lndi68Npfh18=;
        h=From:To:Cc:Subject:Date:From;
        b=EAratEp1U8pwUEsL04DT5bt5m5KxOnERif6MESibQwlgExxD0fO2XfDlv6f+HcU/u
         iPlfueqLTZlQEShiY6Q4wXc8YMdhWU98Vpe8MCOyeRBOQSNp8Apwn9XvQKzQSKX6Qj
         xGUbppcgdxDrHsAo3bypLzRtKelEG+R3qzoC+PbO7aadKAt0OCeeuWka0nEJbt/ZtK
         rtYt8rEN5CwCBuoRnanTey5FyTB73uny6hPfLBDEnc8C1TZtRs2DRFdWkV699hN96E
         qzQ4EIZq0b6m4WeqIZ1RIMBUDQq4xnb6/wwSBjI7yXZDzqfOhLrDfQgRhtQIcQKQUk
         Jr2z0+5D3FzpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 01/25] dmaengine: idxd: depends on !UML
Date:   Mon, 13 Sep 2021 18:33:15 -0400
Message-Id: <20210913223339.435347-1-sashal@kernel.org>
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
index 39b5b46e880f..f450e4231db7 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -279,7 +279,7 @@ config INTEL_IDMA64
 
 config INTEL_IDXD
 	tristate "Intel Data Accelerators support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	depends on PCI_MSI
 	depends on SBITMAP
 	select DMA_ENGINE
-- 
2.30.2

