Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09D715F24D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgBNPyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731464AbgBNPyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069632465D;
        Fri, 14 Feb 2020 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695656;
        bh=EcjME5a/kKnsZfGwBPvbPAcvIOwyEdwgkxBUW8N6TEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3BXpMX6+Zzj8Ul7Ln4/5xMkQQ6UmayCTBuZBGrVqkIskLdziBkhQ1TzkwH3EwMu5
         VcI1VGVrqMGFQTVP7Tkf8XEuCar/ah5cq83C6xwcxrfRa4ZnRH3oPHNE24IzQxAIU4
         Au/gDq1koGxsC8YNmV+PrXhQrLNP2qkSsK3f2qmQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 248/542] remoteproc: q6v5-mss: Remove mem clk from the active pool
Date:   Fri, 14 Feb 2020 10:44:00 -0500
Message-Id: <20200214154854.6746-248-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 6ba519aa13758dd55248f3a6f939536656df2661 ]

Currently the mem clk is voted upon from both the active and proxy pool on
MSM8998 SoCs where only a proxy vote should suffice. Fix this by removing
mem clk from the active pool.

Fixes: 1665cbd5731fa ("remoteproc: qcom_q6v5_mss: Add support for MSM8998")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20191218132217.28141-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 471128a2e7239..164fc2a53ef11 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1594,7 +1594,6 @@ static const struct rproc_hexagon_res msm8998_mss = {
 	.active_clk_names = (char*[]){
 			"iface",
 			"bus",
-			"mem",
 			"gpll0_mss",
 			"mnoc_axi",
 			"snoc_axi",
-- 
2.20.1

