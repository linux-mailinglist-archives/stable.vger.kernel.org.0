Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4743F54F9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhHXA6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhHXAzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F03614C8;
        Tue, 24 Aug 2021 00:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766477;
        bh=whuOrwFWr6xhsVwj+mqzCEP9GGY5hWMbZmnfjaxvcZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnlXhQCG2wx0gAjHCw9Lrp1BZg050IjFiY6QoEsEax5HLUozsKJN8ExAQgWvSES62
         EKXHDXjkpkbUROIUwm+TzVK6MC/fUCqe6zbopafC7xaoJpP+c/FvhcO+bKhoAR4TCj
         VXXqGdFh/UAnHu/QHdSi/9jIE7gWN2+PBmzXhG8/cMZr0OdK3zyw0UVqSBbwa3l81p
         ptQKwwBZSL2SS9yWblmLmpGYRBHMgpeY2aeKH7IB/z6bPiQ0/HajCUlkmb8oUxWh82
         3yWtBwQKfrmXrGcsC7eCuU6vJusb4uwLvL+pSFt8Kq7r2LUSeI9Jqj30T7jB7Y0r7o
         tzwrk4EEnyQ7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/18] cpufreq: blocklist Qualcomm sm8150 in cpufreq-dt-platdev
Date:   Mon, 23 Aug 2021 20:54:17 -0400
Message-Id: <20210824005432.631154-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
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
index 1c192a42f11e..a3734014db47 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -136,6 +136,7 @@ static const struct of_device_id blacklist[] __initconst = {
 	{ .compatible = "qcom,qcs404", },
 	{ .compatible = "qcom,sc7180", },
 	{ .compatible = "qcom,sdm845", },
+	{ .compatible = "qcom,sm8150", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
-- 
2.30.2

