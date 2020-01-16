Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06D713E2AA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbgAPQ5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbgAPQ53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0C620730;
        Thu, 16 Jan 2020 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193849;
        bh=jcUO4aiGzaGJ0ae33gdIpJzoUiIP1myn1aets66c0us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3t1t2Cyo5PvWh41o1h8u/hb61U54iYEFY0WQW1gK2WEz8bpJShDbO+/T7hVHgiiS
         AcKku1iQyWyFQL6yOxyed2SAkCpaRUsMKPtRHtAVzuJrdedIGWk1PMVMXr9LJWrUEC
         HDaYRmLSbb9fb4Dk4MMTe5RJUvgcqgnYCLHxlZ2E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 101/671] remoteproc: qcom: q6v5-mss: Add missing regulator for MSM8996
Date:   Thu, 16 Jan 2020 11:45:32 -0500
Message-Id: <20200116165502.8838-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 47b874748d500020026ee43b386b5598e20f3a68 ]

Add proxy vote for pll supply on MSM8996 SoC.

Fixes: 9f058fa2efb1 ("remoteproc: qcom: Add support for mss remoteproc on msm8996")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pil.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pil.c b/drivers/remoteproc/qcom_q6v5_pil.c
index 073747ba8000..cc475dcbf27f 100644
--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -1268,6 +1268,13 @@ static const struct rproc_hexagon_res sdm845_mss = {
 
 static const struct rproc_hexagon_res msm8996_mss = {
 	.hexagon_mba_image = "mba.mbn",
+	.proxy_supply = (struct qcom_mss_reg_res[]) {
+		{
+			.supply = "pll",
+			.uA = 100000,
+		},
+		{}
+	},
 	.proxy_clk_names = (char*[]){
 			"xo",
 			"pnoc",
-- 
2.20.1

