Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1244953A710
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354042AbiFAN6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353915AbiFAN52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:57:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD71C326F4;
        Wed,  1 Jun 2022 06:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D363BCE1C22;
        Wed,  1 Jun 2022 13:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554A7C36AE2;
        Wed,  1 Jun 2022 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091676;
        bh=Zr7YC4rgbso/fpVcgH8HKP6qnO/dpBaDX89+uXZI+Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu7rP2OhIdt0E8C1A3plR74qgX+LfiSdC5DQciPQmODJNnFihb+JKb2dubjxWG2Ax
         gEHuWPDv/BnY0O7dbdTHbEq1ogRTQQG6DKuNCHEyIe050MQVF7hjwH6FDX9qb6cDlX
         ybmtOmDzGNmtXJOO29Gw+OAILavItjgZ+yXxUPQKcQTgioqS19Sb9/TR05d0a8bI9P
         7oLJLyLaxP1HnRgxFuyAhacI9IyRtWAqmUadvUyIRkn9scaM1JCVI+hzZuEyuD9re4
         C5MaIEQCZVY21WfLqHa7GAuxDUkdynUU3NvPepxoZ0YvnZffUuXGgNz3rlmoHcmoab
         8nsAv1KEQckdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 07/48] arm64: dts: qcom: msm8994: Fix the cont_splash_mem address
Date:   Wed,  1 Jun 2022 09:53:40 -0400
Message-Id: <20220601135421.2003328-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 049c46f31a726bf8d202ff1681661513447fac84 ]

The default memory map places cont_splash_mem at 3401000, which was
overlooked.. Fix it!

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220319174645.340379-9-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 215f56daa26c..480bc686e8e8 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -183,8 +183,8 @@ dfps_data_mem: dfps_data_mem@3400000 {
 			no-map;
 		};
 
-		cont_splash_mem: memory@3800000 {
-			reg = <0 0x03800000 0 0x2400000>;
+		cont_splash_mem: memory@3401000 {
+			reg = <0 0x03401000 0 0x2200000>;
 			no-map;
 		};
 
-- 
2.35.1

