Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A65353A69B
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353645AbiFANyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353686AbiFANyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD518A33C;
        Wed,  1 Jun 2022 06:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBAFC61598;
        Wed,  1 Jun 2022 13:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0CBC3411E;
        Wed,  1 Jun 2022 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091594;
        bh=fvK3Uqo0VtKOO2Rbz2ONUakdG9jzowb8mmBKZpMms/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hL31ZP5RqCUrB6zMwYE8KaCzyAm02HZGhOvcz+Khj/xjtAYvYvNAHeXt4vQNIYrBm
         h5jjHLR5Cgd1mFQCqIehF56keK5aYl3EJIITdtcuRJyNmBfzg8gSsZGWfeArtNRRnS
         wlo3th4KnE6LXjT5UO+I6hqY77g54bW2fKRmzMMszadnOGVtrfsPx+7yYaFqNIOg0P
         bstmETf67LRuFr3oW4RhSMOXCEmeipa+h76T2VHFMGbKcnc8OWR7yQ1JQBobWLnm6P
         P6cxdK+rU1c1uA3HOgOhgqlNbf39zJTwaL65aWEItu6o2ljp2dlJTM0mrqdp2+1X68
         YA0o2jmdYW3ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 25/49] arm64: dts: qcom: sc7280-idp: Configure CTS pin to bias-bus-hold for bluetooth
Date:   Wed,  1 Jun 2022 09:51:49 -0400
Message-Id: <20220601135214.2002647-25-sashal@kernel.org>
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
index ecbf2b89d896..5ab3696af354 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -400,10 +400,13 @@ &qup_uart5_rx {
 
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
@@ -495,10 +498,13 @@ qup_uart7_sleep_cts: qup-uart7-sleep-cts {
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

