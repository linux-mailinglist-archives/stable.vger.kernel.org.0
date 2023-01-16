Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6730366C09B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjAPOCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjAPOCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBE122031;
        Mon, 16 Jan 2023 06:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 895EEB80E71;
        Mon, 16 Jan 2023 14:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA33C433EF;
        Mon, 16 Jan 2023 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877731;
        bh=FF7yQesEwXWsTZzOhFUgksVYA0atWx7Jjum6I0bmH1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjvqWBMWc9HLZ2nRymyci8DLWLOt1PC6mpOz7PRZnvkXoXHglpGL7pvkmPDlc2ckm
         mrwSYKbEgJZh8G6VPP9MnS7ooDWkYf4SqngETaUeBT4RAtDmwT023HIyN1bQykNjbe
         v/HOVhAJJ0t6TX6hYEINBasYXMU3l20gJoNiGt4nwHSgdlYiu7dCP9oMUBc4pb4pwo
         Yk1jfWXWArY4jwHBEo7vmcP8uWQFm4oh+jwkqdlQczTdAOqvH3JZO3YRtflZ2g9rK3
         lmvWGx/mQq7mKTZhul/lvkx5ujllFn/pX1mOuYARuxazpx1FAyVRRmPLEC65iiNQf8
         qMB28DIRRPOgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sumit Gupta <sumitg@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/53] cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist
Date:   Mon, 16 Jan 2023 09:01:08 -0500
Message-Id: <20230116140154.114951-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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
index 6ac3800db450..54ae8118d528 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -135,6 +135,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "nvidia,tegra30", },
 	{ .compatible = "nvidia,tegra124", },
 	{ .compatible = "nvidia,tegra210", },
+	{ .compatible = "nvidia,tegra234", },
 
 	{ .compatible = "qcom,apq8096", },
 	{ .compatible = "qcom,msm8996", },
-- 
2.35.1

