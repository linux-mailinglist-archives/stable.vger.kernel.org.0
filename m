Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE843F5441
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhHXAyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhHXAyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20646613D3;
        Tue, 24 Aug 2021 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766443;
        bh=O9cNfkCI8vw3QsL7QGHGe3UudqJkNC6WFqUr1fVJRI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxHI1A0Y+cyYxcvZ96Gmrmb32aj8cHwqzAKUuMq8eGFNFH0hsbYZjq1L03aBWix9Z
         ovwlKZdGGPXpuVF0ktwbxE1GVfnFxkmmW+xT/vLLrL/ScaPvxD1+W+eGvqJaZmiITc
         2hpTNMnx1vju2Siuux5P5JtSP7V4nORvQYWxq771Mbg3XvGRFCmeWFQjDeycPNEdf/
         zchZiDV30G89UaxBMeD/knY3+EvkyMhOGUbYmqOZhFugcNndsyguGsdFuVIoAaD2cg
         qlqg0F4qGhILC0Hd21pejUmB49DAlOBxQMYUKFTU2xLCYR02bu5iOCpMOgp87lPkSO
         dZaoV/EvhY8kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 05/26] cpufreq: blocklist Qualcomm sm8150 in cpufreq-dt-platdev
Date:   Mon, 23 Aug 2021 20:53:35 -0400
Message-Id: <20210824005356.630888-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

[ Upstream commit 5d79e5ce5489b489cbc4c327305be9dfca0fc9ce ]

The Qualcomm sm8150 platform uses the qcom-cpufreq-hw driver, so
add it to the cpufreq-dt-platdev driver's blocklist.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 5e07065ec22f..1f8dc1164ba2 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -138,6 +138,7 @@ static const struct of_device_id blacklist[] __initconst = {
 	{ .compatible = "qcom,qcs404", },
 	{ .compatible = "qcom,sc7180", },
 	{ .compatible = "qcom,sdm845", },
+	{ .compatible = "qcom,sm8150", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
-- 
2.30.2

