Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD483B78
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfHFVf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbfHFVf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF334217D9;
        Tue,  6 Aug 2019 21:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127327;
        bh=UVR1MM2J6+mBwZheoLhNZ7HSuyNGAMLGPPOSF7Qx3lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzUSdqd/RElKBzOYAOGME867P67wQ531XbUiaCjRCTuqGVMaQMy66wIKLLNsF4eGs
         UsFxNPY9LlDaZkpu7tgeUCEzhrEOMozlYzzvSVEEKhcn/drWizJ7yJSpjadoSDTVtS
         la5kGnD9ycYHT+U4QIHX4AW29cGUIQEfFy4QZUN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/32] clk: sprd: Select REGMAP_MMIO to avoid compile errors
Date:   Tue,  6 Aug 2019 17:34:50 -0400
Message-Id: <20190806213522.19859-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213522.19859-1-sashal@kernel.org>
References: <20190806213522.19859-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunyan Zhang <chunyan.zhang@unisoc.com>

[ Upstream commit c9a67cbb5189e966c70451562b2ca4c3876ab546 ]

Make REGMAP_MMIO selected to avoid undefined reference to regmap symbols.

Fixes: d41f59fd92f2 ("clk: sprd: Add common infrastructure")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/sprd/Kconfig b/drivers/clk/sprd/Kconfig
index 87892471eb96c..bad8099832d48 100644
--- a/drivers/clk/sprd/Kconfig
+++ b/drivers/clk/sprd/Kconfig
@@ -2,6 +2,7 @@ config SPRD_COMMON_CLK
 	tristate "Clock support for Spreadtrum SoCs"
 	depends on ARCH_SPRD || COMPILE_TEST
 	default ARCH_SPRD
+	select REGMAP_MMIO
 
 if SPRD_COMMON_CLK
 
-- 
2.20.1

