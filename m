Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE715FB58B
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJKOzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiJKOyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098489C2C5;
        Tue, 11 Oct 2022 07:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48904B8160D;
        Tue, 11 Oct 2022 14:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B81C433D7;
        Tue, 11 Oct 2022 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499899;
        bh=PaC8jEflw0FOLaGuYNpIga/kLtJ4AMUin+oxJxX25Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj5aYtko6xKq35+uzYl3bFNTiDUFp9S7kDEO9YnpcpaHYzacUg/JCoHyD0WahmASx
         zBidJKD3i9W7f/0M7uv21Z1EvUFhY1wQL/QwBPyl4B0GZtTTRRhr5Hieccu8f8dRf1
         uEX9dEuMU1OlLBJmL99O5iw+ohUxUPi4BqbEWwx5xFbwKMw7rWHcefSGkAx60yrtrE
         t9d/73ZPIr9EZ+jfKbhvRnpaOzP5TWZlswoRh5suCmjWQYo3QxB+XGhAzpyeRwkzKp
         IS0KlP5sQXfc70SdLYJEjreglCtVABwyCeOIZgPKNT048y0GWuUBxacf9OcJ8s3jGg
         aybQpYJxGjYdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 05/40] arm64: dts: qcom: sc7280-idp: correct ADC channel node name and unit address
Date:   Tue, 11 Oct 2022 10:50:54 -0400
Message-Id: <20221011145129.1623487-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5589ffb2da2a66988ab3a68334dad3e68b42e3a9 ]

Correct SPMI PMIC VADC channel node name:
1. Use hyphens instead of underscores,
2. Add missing unit address.

This fixes `make dtbs_check` warnings like:

  qcom/sc7280-idp.dtb: pmic@0: adc@3100: 'pmk8350_die_temp', 'pmr735a_die_temp' do not match any of the regexes: '^.*@[0-9a-f]+$', 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220828084341.112146-12-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dts  | 2 +-
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dts b/arch/arm64/boot/dts/qcom/sc7280-idp.dts
index 6d3ff80582ae..e2e37a0292ad 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dts
@@ -78,7 +78,7 @@ &nvme_3v3_regulator {
 };
 
 &pmk8350_vadc {
-	pmr735a_die_temp {
+	pmr735a-die-temp@403 {
 		reg = <PMR735A_ADC7_DIE_TEMP>;
 		label = "pmr735a_die_temp";
 		qcom,pre-scaling = <1 1>;
diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index 5eb668991e24..893d3031cfd5 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -264,7 +264,7 @@ &pcie1_phy {
 };
 
 &pmk8350_vadc {
-	pmk8350_die_temp {
+	pmk8350-die-temp@3 {
 		reg = <PMK8350_ADC7_DIE_TEMP>;
 		label = "pmk8350_die_temp";
 		qcom,pre-scaling = <1 1>;
-- 
2.35.1

