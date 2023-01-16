Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C64866C0B3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjAPODz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjAPODB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55837227B7;
        Mon, 16 Jan 2023 06:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D8460FB3;
        Mon, 16 Jan 2023 14:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2CBC433EF;
        Mon, 16 Jan 2023 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877760;
        bh=sl9OamyODPksOi5FFlBPdm4/+SDNkk0qieohtpEiSx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDntf9xtgV1He3pu+dLsKYsvV9yxbk7LxP0nXUIwI54xroAcacf0JSbG1naj4qUJO
         8Hwb71OkMiZ6W6kOhq2AAZF6KdTf7FSxTIlwvlWzQZskUeViqws9Jjf5NVIVPYqmU8
         lz70Kh3s08AHev1R9FqtPhiV94wgsBP8GiWjlAH8fzRrueS0LHnfRF7DgJzm4ccUTy
         euc9E1y6J4Z/fgyC3G7NMNp+RHfWF1C0lJMSoBdF0yhBTXZuGcz/UkzCbiBIDKgFPm
         FuiQ26FWyU1+oem88ns6svlD9RtMtOGDiEsCYZl05FcbiR253blBIE43beszCMNphs
         ZWfaIn/5gvURg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 14/53] cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist
Date:   Mon, 16 Jan 2023 09:01:14 -0500
Message-Id: <20230116140154.114951-14-sashal@kernel.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit faf28e240dd118d9521c68aeb9388b9b8f02d9d0 ]

The Qualcomm SM6375 platform uses the qcom-cpufreq-hw driver, so add
it to the cpufreq-dt-platdev driver's blocklist.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 54ae8118d528..69a8742c0a7a 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -149,6 +149,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sm6115", },
 	{ .compatible = "qcom,sm6350", },
+	{ .compatible = "qcom,sm6375", },
 	{ .compatible = "qcom,sm8150", },
 	{ .compatible = "qcom,sm8250", },
 	{ .compatible = "qcom,sm8350", },
-- 
2.35.1

