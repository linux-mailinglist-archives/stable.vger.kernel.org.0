Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27B153A771
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354065AbiFAOBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354613AbiFAOAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E7A1838A;
        Wed,  1 Jun 2022 06:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87576615D3;
        Wed,  1 Jun 2022 13:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E457EC36AEA;
        Wed,  1 Jun 2022 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091793;
        bh=5qyxIHSJtGOnmf8C0NxsexbhzBIOvakF7hmosyKhzC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzjOhqYjXS8KoycTyNKZpL28xwOA0LZ6Sje5a8gzXZyDB0T9RJxREr5HoFhu+pNxL
         pc+tuO2eCiZDBtauWoqiB319I/AaM1wt5ZrdOeziyEKROODtjGzjfwQreWQqoG1pom
         CguSn/GhsiIXMmnfkoqZYJgeyO0abiSi3AVSYvT4I776++eWCuL674GksNOM63Yow9
         DxTMqKDCV7Hh7oiYsRD/QYlKobQ50BJXJ5uHBpWUxdr6fVtiDNuSnYrDvHrvOzWwiU
         qDzvC7RxfHT10LRu1C1mpLrm912Q9mLz4cRYy3SLOw68pu/DAUAczAdK+RnXJGYXlG
         s35RA8ELUDdog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/37] arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count
Date:   Wed,  1 Jun 2022 09:55:51 -0400
Message-Id: <20220601135622.2003939-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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

[ Upstream commit 1ae438d26b620979ed004d559c304d31c42173ae ]

MSM8994 actually features 24 DMA channels for each BLSP,
fix it!

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220319174645.340379-14-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 1165269f059e..3c27671c8b5c 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -498,7 +498,7 @@ blsp1_dma: dma-controller@f9904000 {
 			#dma-cells = <1>;
 			qcom,ee = <0>;
 			qcom,controlled-remotely;
-			num-channels = <18>;
+			num-channels = <24>;
 			qcom,num-ees = <4>;
 		};
 
@@ -634,7 +634,7 @@ blsp2_dma: dma-controller@f9944000 {
 			#dma-cells = <1>;
 			qcom,ee = <0>;
 			qcom,controlled-remotely;
-			num-channels = <18>;
+			num-channels = <24>;
 			qcom,num-ees = <4>;
 		};
 
-- 
2.35.1

