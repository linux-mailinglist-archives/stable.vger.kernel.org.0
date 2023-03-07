Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252066AE82F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjCGRN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjCGRNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB563B3CF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D782B819B0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0624C4339B;
        Tue,  7 Mar 2023 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208885;
        bh=+Yqv7zdzOo25K4EXrlQ3WYwGbGkG44uZ+7q9KhEbn1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ85WhBrdrVvNsj4xJxdEJjSyFGjH8MhgDP62C++8lShhdwe/Sn/TwockgrP9BGt+
         l0gyxsvs94PtP3Twwj09/0dU/vvlslpFCf35lWCMq03az2nucT2WjT4aa9oyJkVJ0U
         oZAOGA/pM/oRHodOJQSB6XJKB5Bzg8GJRotqpN0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0024/1001] arm64: dts: qcom: sm6125-seine: Clean up gpio-keys (volume down)
Date:   Tue,  7 Mar 2023 17:46:36 +0100
Message-Id: <20230307170023.210464664@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 0de6c5b7f742e..09cff5d1d0ae8 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dts
@@ -41,17 +41,18 @@ extcon_usb: extcon-usb {
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
 
@@ -270,6 +271,14 @@ &sdhc_1 {
 
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



