Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8B68103A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbjA3OBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbjA3OBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2913B66E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C829B81154
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14D3C433EF;
        Mon, 30 Jan 2023 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087254;
        bh=HXrhd37rkLoma/ArAtFccRMEdMq7Mw1mNmj4y/DffBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xKUSzIlQhnpIdLCOCk8cedwIi22eZ5r/fL9yKRiLsY9bNeQHGXHfA0FHeHmRIrSME
         3S7EjUdwwAAXrJBROmchkIq82Ac9bph6tJpjcqO6Q6OSH/X6O/WnK7zNRM2dW94izb
         +k7dNPHOSfUeZgVhh4W1igekGvMOcWEoBEn6khks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sumit Gupta <sumitg@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/313] cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist
Date:   Mon, 30 Jan 2023 14:49:43 +0100
Message-Id: <20230130134343.555116705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.39.0



