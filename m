Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC0A53A73B
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353923AbiFAN7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354033AbiFAN6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:58:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF0880F5;
        Wed,  1 Jun 2022 06:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 432C4615F3;
        Wed,  1 Jun 2022 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CF2C3411E;
        Wed,  1 Jun 2022 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091718;
        bh=+7YLbsPjf0ff3HxBonzNas5xwXxkNQMQ7rDT4NH7mHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlTavO1YRo+vtZlQJrf2h+5sU8IPwYJLVRZOVEMz1gVv4wiUOyRY1ROnzEswQRrgY
         G0YwF0F3BuBeDE1QdyEvkbP9ExZ6Uhl5dvWwDfvpHQZljtCdDCtd3nW/4b74s5eR4T
         BXhNbqEXDZVA+0sdh9taJe2o1Izj+/qcqO05mbOkie7+AxVFfPnuUW6M7CTrMVtRun
         rIRFUkR5dDBKEnbj2lt2krFcYiOcrhCdrdutPhcFbdhfAgJA+7NsP3OQJdQ2m6dC9C
         w58RSbW0d9c3dZmCgGBWFw4oArZuYnDn5qGiiVotGCl6uES95JTi9KBHJq1KdnxXzF
         WFyekSd3gMxiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 25/48] arm64: dts: qcom: sc7280-idp: Configure CTS pin to bias-bus-hold for bluetooth
Date:   Wed,  1 Jun 2022 09:53:58 -0400
Message-Id: <20220601135421.2003328-25-sashal@kernel.org>
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

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit 497b272759986af1aa5a25b5e903d082c67bd8f6 ]

WLAN rail was leaking power during RBSC/sleep even after turning BT off.
Change active and sleep pinctrl configurations to handle same.

Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1650556567-4995-2-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index d623d71d8bd4..dd6dac0e1784 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -462,10 +462,13 @@ &qup_uart5_rx {
 
 &qup_uart7_cts {
 	/*
-	 * Configure a pull-down on CTS to match the pull of
-	 * the Bluetooth module.
+	 * Configure a bias-bus-hold on CTS to lower power
+	 * usage when Bluetooth is turned off. Bus hold will
+	 * maintain a low power state regardless of whether
+	 * the Bluetooth module drives the pin in either
+	 * direction or leaves the pin fully unpowered.
 	 */
-	bias-pull-down;
+	bias-bus-hold;
 };
 
 &qup_uart7_rts {
@@ -516,10 +519,13 @@ qup_uart7_sleep_cts: qup-uart7-sleep-cts {
 		pins = "gpio28";
 		function = "gpio";
 		/*
-		 * Configure a pull-down on CTS to match the pull of
-		 * the Bluetooth module.
+		 * Configure a bias-bus-hold on CTS to lower power
+		 * usage when Bluetooth is turned off. Bus hold will
+		 * maintain a low power state regardless of whether
+		 * the Bluetooth module drives the pin in either
+		 * direction or leaves the pin fully unpowered.
 		 */
-		bias-pull-down;
+		bias-bus-hold;
 	};
 
 	qup_uart7_sleep_rts: qup-uart7-sleep-rts {
-- 
2.35.1

