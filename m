Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0E53A650
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353470AbiFANwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353430AbiFANwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:52:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16918720D;
        Wed,  1 Jun 2022 06:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7E7B81ADA;
        Wed,  1 Jun 2022 13:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDF2C385A5;
        Wed,  1 Jun 2022 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091552;
        bh=3MLpakABDrGY096cMYD18wMq5bfDqm03ueov+skRfpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnsiX+FiKIvNHMdRDBsrwhzQVcFFFG69Jex6icK1m29UMvvLSV1m7k0NSLmZRi9e5
         cOUVUNOiUxAO7OISVA7eLTjmmhw0tLSsop+iNmwIrXs7Al1MW08FCrSQdJZxNSviBp
         cx2w82NT7eKEe7YeFFCSqqrc854LhBd0tHGdJHWDpvH4Fs+ypgvtVGpPTRR6w6cyld
         7ruLk3GHphYOEl+iWEEKRFK5qwxn3om8uM9QqbFVvU3JCNIzhRf0munrzdn4YYNDBD
         HZp4CmLd2zTUWFcDgJRYiEkkxcLti2Y/AZnprPuPXKz6v9xb7HPEQn64RQFDGEF9I+
         AxdU9+GzAAivg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 08/49] arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count
Date:   Wed,  1 Jun 2022 09:51:32 -0400
Message-Id: <20220601135214.2002647-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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
index c65618b95ce0..b1e595cb4b90 100644
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

