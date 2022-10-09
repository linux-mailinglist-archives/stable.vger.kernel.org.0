Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97FD5F9608
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiJJA0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiJJAXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC453DBE5;
        Sun,  9 Oct 2022 16:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E6160CBB;
        Sun,  9 Oct 2022 23:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63C5C43142;
        Sun,  9 Oct 2022 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359860;
        bh=lMngYpEaHn+GSZ8B6h5KSHU2ZLlH+zvHYVzQIpHhrHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2Qv/c1zHT+Ng42InjKOilpqk2/+Ty47quvqY4ZdRDiQU1mQ4a/r4tABNGrRQYOdo
         D3oIN7eFHSZpf6lccCPQBOjC24YgiBAiOhAUgneaZcjqRDJpDim6Zmcb274Wq97dql
         2vxxKaGeM2vnSMDd8TQfju8ypXVB1gMs+zytEQKD3veF69v5cARyfFcHnJylXsQFu2
         dKAYyVlwwzZGtcnRuKxWhqvQ+O5J7qxjRCLlw+dO6pXr0domAHRzUK7aXBxb6+MU7L
         FkGH8ccUlPHFaAWrX6ehoOJoNxbdlmxz+Bs95LqF1S0VqyG2MU2g/gd4sI7skijAue
         9QfYZCr0LRa2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Acayan <mailingradian@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        andersson@kernel.org, adrian.hunter@intel.com,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/14] mmc: sdhci-msm: add compatible string check for sdm670
Date:   Sun,  9 Oct 2022 19:57:09 -0400
Message-Id: <20221009235710.1231937-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235710.1231937-1-sashal@kernel.org>
References: <20221009235710.1231937-1-sashal@kernel.org>
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

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 4de95950d970c71a9e82a24573bb7a44fd95baa1 ]

The Snapdragon 670 has the same quirk as Snapdragon 845 (needing to
restore the dll config). Add a compatible string check to detect the need
for this.

Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220923014322.33620-3-mailingradian@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 8ab963055238..5e6f6c951fd4 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1755,6 +1755,7 @@ static const struct sdhci_msm_variant_info sdm845_sdhci_var = {
 static const struct of_device_id sdhci_msm_dt_match[] = {
 	{.compatible = "qcom,sdhci-msm-v4", .data = &sdhci_msm_mci_var},
 	{.compatible = "qcom,sdhci-msm-v5", .data = &sdhci_msm_v5_var},
+	{.compatible = "qcom,sdm670-sdhci", .data = &sdm845_sdhci_var},
 	{.compatible = "qcom,sdm845-sdhci", .data = &sdm845_sdhci_var},
 	{},
 };
-- 
2.35.1

