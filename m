Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8287C6AEDCC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjCGSHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjCGSHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038621B2EE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15D4B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D80AC433D2;
        Tue,  7 Mar 2023 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212020;
        bh=xkcFN12T+VKdASzvMi9lXksazh6vkyk4ifLmLUeldd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpBSosjpbPaGTcPPlMnDwGgADaLE4TQ3W5q2DnjFA8g7xH06vI2FQHv5weTzq9A/q
         jU7mbi69Ef+n4qX3vtAsQzo+4GtFCXJhB4gfEji9uHg+0u0V8c9X/8Hjiu3NRaOiVC
         p5ObrHvA/0J6BxC3pG448DC8j3Y+/G8JYE1RA+tU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/885] arm64: dts: qcom: sm6125-seine: Clean up gpio-keys (volume down)
Date:   Tue,  7 Mar 2023 17:49:05 +0100
Message-Id: <20230307170002.135074083@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit a9f6a13da473bb6c7406d2784d9e3792f6763cba ]

- Remove autorepeat (leave key repetition to userspace);
- Remove unneeded status = "okay" (this is the default);
- Remove unneeded linux,input-type <EV_KEY> (this is the default for
  gpio-keys);
- Allow the interrupt line for this button to be disabled;
- Use a full, descriptive node name;
- Set proper bias on the GPIO via pinctrl;
- Sort properties;
- Replace deprecated gpio-key,wakeup property with wakeup-source.

Fixes: 82e1783890b7 ("arm64: dts: qcom: sm6125: Add support for Sony Xperia 10II")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221222192443.119103-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm6125-sony-xperia-seine-pdx201.dts  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
index 6a8b88cc43853..e1ab5b5189949 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
@@ -40,17 +40,18 @@ extcon_usb: extcon-usb {
 	};
 
 	gpio-keys {
-		status = "okay";
 		compatible = "gpio-keys";
-		autorepeat;
 
-		key-vol-dn {
+		pinctrl-0 = <&vol_down_n>;
+		pinctrl-names = "default";
+
+		key-volume-down {
 			label = "Volume Down";
 			gpios = <&tlmm 47 GPIO_ACTIVE_LOW>;
-			linux,input-type = <1>;
 			linux,code = <KEY_VOLUMEDOWN>;
-			gpio-key,wakeup;
 			debounce-interval = <15>;
+			linux,can-disable;
+			wakeup-source;
 		};
 	};
 
@@ -108,6 +109,14 @@ &sdhc_1 {
 
 &tlmm {
 	gpio-reserved-ranges = <22 2>, <28 6>;
+
+	vol_down_n: vol-down-n-state {
+		pins = "gpio47";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+		input-enable;
+	};
 };
 
 &usb3 {
-- 
2.39.2



