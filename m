Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF3E66C148
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjAPOJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjAPOI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:08:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6051527985;
        Mon, 16 Jan 2023 06:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D852560FC9;
        Mon, 16 Jan 2023 14:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C124C43392;
        Mon, 16 Jan 2023 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877846;
        bh=fWZvhx0pxcN20Fs5uX9/JKigE7iPIqBs/SYQ29qU88A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkcsNKMc/FQB4LmYMw7T1YqCYGfrM8Upe856sCPIBW9hicKNKrEAIey6d0xZFoddn
         7kxoIKzz33X57WA6tQTbMw5/HEI1qzYWBRm0dmorKCdLPI0MPma63lZpivn3Y3l6cS
         KB0McrjRNUFyJGepCVwAPLltwMyDhrzJLHuSt+mpWtUymBgA/iyKrmXuT9ttMH2e1w
         WyxJcRRY2eiWz/Gm429arWM9y5n2oCAmXpuMZUt0k2CGrsQh1MZ1OGUUDIIRaFL9UY
         FTDKQ+LAXLHWnc/e33zHnXow8KhhwSB98oNKrsBkmlERJ7wX39HCZV2KYAxoIKwj0x
         LyhFrh5hyFOEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/24] cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist
Date:   Mon, 16 Jan 2023 09:03:39 -0500
Message-Id: <20230116140359.115716-4-sashal@kernel.org>
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
index 27a3b8800a35..e1b5975c7daa 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -144,6 +144,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sc8180x", },
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sm6350", },
+	{ .compatible = "qcom,sm6375", },
 	{ .compatible = "qcom,sm8150", },
 	{ .compatible = "qcom,sm8250", },
 	{ .compatible = "qcom,sm8350", },
-- 
2.35.1

