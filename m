Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7C740A0D3
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349076AbhIMWmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349386AbhIMWj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5454461247;
        Mon, 13 Sep 2021 22:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572551;
        bh=skyWCzASgpYQ8ky8gcrb8BafQh7LHakiQs289AiZ3Rk=;
        h=From:To:Cc:Subject:Date:From;
        b=eN3QVIdyTnP18Uq1/jYwYgPLQNE36YU4T2J2t9UzRuRsAgeWQ/KfKEKzLShBd+LEk
         65albUyCUJlBmMG1I/Vo0QeKw8c/xY6DLEVr6hVOuFNxTc8G6IK446AL2E1ZER22+p
         Irj4s2ukQ64Uybokp9DHJ/5jB2BCxDcOXPkW/Y/X4Usa+JlE6XwqrhW3qOyECDTV3Q
         8CMIx8lD3nJCl7w8nfQmcvLDgryFbQ3BneOYx6UrxF0XjQ/2Aetar9aAwyrOX5+kqR
         eljRuEnSF1lT14rO5sML177+keVBgt512lRusFeZUgDCU6k97NRgxDrGE34rTurePO
         lZ8OUTlu+dRgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/9] dmaengine: ioat: depends on !UML
Date:   Mon, 13 Sep 2021 18:35:41 -0400
Message-Id: <20210913223549.436541-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbac7a92a46f0876e588722ebe552ddfe6fd790f ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210809112409.a3a0974874d2.I2ffe3d11ed37f735da2f39884a74c953b258b995@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index b0f798244a89..9a6da9b2dad3 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -238,7 +238,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.30.2

