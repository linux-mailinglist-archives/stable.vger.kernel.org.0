Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC4311B070
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbfLKPWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732630AbfLKPWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64EA2073D;
        Wed, 11 Dec 2019 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077768;
        bh=sBp0YHgt70jpnj3jI0N7+0m0ZK2YV5St8lYmC2G7qZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaL1puFx465wH96rLpkoFRK1HxTOKafX4J9KaqNRB2Tb5C/nm1j8R0O3sJpLGnFmp
         bb6wCJJehNLq4wTWfpbAs4HeIHA+iOnFz+OaB0bRJvF1dh3l7FVB/Sn7gb5LQESLnn
         A3nWsAFLTMTO79DoZIZ4oUAtEiJzYVMGrW6WNXNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/243] clk: qcom: Fix MSM8998 resets
Date:   Wed, 11 Dec 2019 16:05:26 +0100
Message-Id: <20191211150350.236425961@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

[ Upstream commit 4f89f7b59a6ea17e81cff212c18a0b580ff5ff27 ]

The offsets for the defined BCR reset registers does not match the hardware
documentation.  Update the values to match the hardware documentation.

Fixes: b5f5f525c547 (clk: qcom: Add MSM8998 Global Clock Control (GCC) driver)
Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8998.c | 38 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8998.c b/drivers/clk/qcom/gcc-msm8998.c
index cd937ce6aaaf6..5fd6662a1beac 100644
--- a/drivers/clk/qcom/gcc-msm8998.c
+++ b/drivers/clk/qcom/gcc-msm8998.c
@@ -2743,25 +2743,25 @@ static struct gdsc *gcc_msm8998_gdscs[] = {
 };
 
 static const struct qcom_reset_map gcc_msm8998_resets[] = {
-	[GCC_BLSP1_QUP1_BCR] = { 0x102400 },
-	[GCC_BLSP1_QUP2_BCR] = { 0x110592 },
-	[GCC_BLSP1_QUP3_BCR] = { 0x118784 },
-	[GCC_BLSP1_QUP4_BCR] = { 0x126976 },
-	[GCC_BLSP1_QUP5_BCR] = { 0x135168 },
-	[GCC_BLSP1_QUP6_BCR] = { 0x143360 },
-	[GCC_BLSP2_QUP1_BCR] = { 0x155648 },
-	[GCC_BLSP2_QUP2_BCR] = { 0x163840 },
-	[GCC_BLSP2_QUP3_BCR] = { 0x172032 },
-	[GCC_BLSP2_QUP4_BCR] = { 0x180224 },
-	[GCC_BLSP2_QUP5_BCR] = { 0x188416 },
-	[GCC_BLSP2_QUP6_BCR] = { 0x196608 },
-	[GCC_PCIE_0_BCR] = { 0x438272 },
-	[GCC_PDM_BCR] = { 0x208896 },
-	[GCC_SDCC2_BCR] = { 0x81920 },
-	[GCC_SDCC4_BCR] = { 0x90112 },
-	[GCC_TSIF_BCR] = { 0x221184 },
-	[GCC_UFS_BCR] = { 0x479232 },
-	[GCC_USB_30_BCR] = { 0x61440 },
+	[GCC_BLSP1_QUP1_BCR] = { 0x19000 },
+	[GCC_BLSP1_QUP2_BCR] = { 0x1b000 },
+	[GCC_BLSP1_QUP3_BCR] = { 0x1d000 },
+	[GCC_BLSP1_QUP4_BCR] = { 0x1f000 },
+	[GCC_BLSP1_QUP5_BCR] = { 0x21000 },
+	[GCC_BLSP1_QUP6_BCR] = { 0x23000 },
+	[GCC_BLSP2_QUP1_BCR] = { 0x26000 },
+	[GCC_BLSP2_QUP2_BCR] = { 0x28000 },
+	[GCC_BLSP2_QUP3_BCR] = { 0x2a000 },
+	[GCC_BLSP2_QUP4_BCR] = { 0x2c000 },
+	[GCC_BLSP2_QUP5_BCR] = { 0x2e000 },
+	[GCC_BLSP2_QUP6_BCR] = { 0x30000 },
+	[GCC_PCIE_0_BCR] = { 0x6b000 },
+	[GCC_PDM_BCR] = { 0x33000 },
+	[GCC_SDCC2_BCR] = { 0x14000 },
+	[GCC_SDCC4_BCR] = { 0x16000 },
+	[GCC_TSIF_BCR] = { 0x36000 },
+	[GCC_UFS_BCR] = { 0x75000 },
+	[GCC_USB_30_BCR] = { 0xf000 },
 };
 
 static const struct regmap_config gcc_msm8998_regmap_config = {
-- 
2.20.1



