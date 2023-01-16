Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1671D66C14A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjAPOJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjAPOIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:08:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046FB22DCD;
        Mon, 16 Jan 2023 06:04:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E6860FB3;
        Mon, 16 Jan 2023 14:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C74C433F1;
        Mon, 16 Jan 2023 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877844;
        bh=c7ofwDpNN0ZiMcU9e9VKHAj/4S8vZ9dH5yrrjLsc894=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWCKWcc6BdmzSb7lcwWn6ZhbsK3flA9VDswWLwGn1XjHjTQVnkP4kuD3n25afih8M
         mzqzlrdf/jOG5QmPUHCRn82u/R2lwZkTfUqvQgJkEcYazXr/chf83gJX4NymmD7nG5
         /ftUBmzEUYojl88I+8byy4ClCG0ucXlforyW/IvHAHMo6QCdEZKBrnsBmoU7mNrfmf
         XmAUvokBhFoq7BdxitxRdzMyxJvbcQYWw9SoZ0hkDyoC6s9m1o9tJTT8PAV6g+o79G
         bc9phzoCKDLHQtysjWhdzlX3DSBsmApk77fim7MsmO14jGjqFPVP4262aWdL1Gyr50
         e7E09A9FoUrYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sumit Gupta <sumitg@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/24] cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist
Date:   Mon, 16 Jan 2023 09:03:37 -0500
Message-Id: <20230116140359.115716-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 01c5bb0cc2a39fbc56ff9a5ef28b79447f0c2351 ]

Tegra234 platform uses the tegra194-cpufreq driver, so add it
to the blocklist in cpufreq-dt-platdev driver to avoid the cpufreq
driver registration from there.

Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index ca1d103ec449..27a3b8800a35 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -133,6 +133,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "nvidia,tegra30", },
 	{ .compatible = "nvidia,tegra124", },
 	{ .compatible = "nvidia,tegra210", },
+	{ .compatible = "nvidia,tegra234", },
 
 	{ .compatible = "qcom,apq8096", },
 	{ .compatible = "qcom,msm8996", },
-- 
2.35.1

