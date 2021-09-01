Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCBC3FDC73
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344630AbhIAMu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345718AbhIAMsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A9861163;
        Wed,  1 Sep 2021 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500031;
        bh=O9cNfkCI8vw3QsL7QGHGe3UudqJkNC6WFqUr1fVJRI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSIPXBw8+eKz+5AODzfufVnXHfPMXBssmHgNB8trDCYId2kVvDV4zfhh5jdDHLuGt
         23TD7pP8hDaAyRAEu2kWgbLMRcwKvtb1BC7uTADWlAi4kf99Ffd6XblS8lJHBftAp6
         YqFQbA3plAC6baVpHeGA8z4gzzrUA4lc1GlPygaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 077/113] cpufreq: blocklist Qualcomm sm8150 in cpufreq-dt-platdev
Date:   Wed,  1 Sep 2021 14:28:32 +0200
Message-Id: <20210901122304.560892506@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



