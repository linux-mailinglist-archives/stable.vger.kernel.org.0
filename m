Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929846AE847
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjCGROq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCGRO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46E88DCE1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF1AB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C2CC433D2;
        Tue,  7 Mar 2023 17:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208951;
        bh=ce5JmmYaCoMghz6MBMrjjAiI1Yrg6eqnGO7c5KDynWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EIC6WMTrKH3LhBm6U/n26ww6B4xtGP7JGhu0cb/b6FkVVXmNjGmUnuofHgZS/2GR
         HRZaBlzugndVBPL3PIelrVofo8w9gGA5sgwL5BZ/YlPXVPQBP0TR+xEIh2ICZvgEsJ
         Ow9NbvtnJPW1HvjUhpw1vgfC3SUVObwsRSn4tLN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0022/1001] arm64: dts: qcom: sm6350-lena: Flatten gpio-keys pinctrl state
Date:   Tue,  7 Mar 2023 17:46:34 +0100
Message-Id: <20230307170023.122952101@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit a40f5ae1ea64ab9e981faf47c31817dc4d7923e4 ]

Pinctrl states typically collate multiple related pins.  In the case of
gpio-keys there's no hardware-defined relation at all except all pins
representing a key; and especially on Sony's lena board there's only one
pin regardless. Flatten it similar to other boards [1].

As a drive-by fix, clean up the label string.

[1]: https://lore.kernel.org/linux-arm-msm/11174eb6-0a9d-7df1-6f06-da4010f76453@linaro.org/

Fixes: 2b8bbe985659 ("arm64: dts: qcom: sm6350-lena: Include pm6350 and configure buttons")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221222215906.324092-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/sm6350-sony-xperia-lena-pdx213.dts    | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dts b/arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dts
index 94f77d376662e..4916d0db5b47f 100644
--- a/arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dts
+++ b/arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dts
@@ -35,10 +35,10 @@ framebuffer: framebuffer@a0000000 {
 	gpio-keys {
 		compatible = "gpio-keys";
 		pinctrl-names = "default";
-		pinctrl-0 = <&gpio_keys_state>;
+		pinctrl-0 = <&vol_down_n>;
 
 		key-volume-down {
-			label = "volume_down";
+			label = "Volume Down";
 			linux,code = <KEY_VOLUMEDOWN>;
 			gpios = <&pm6350_gpios 2 GPIO_ACTIVE_LOW>;
 		};
@@ -305,14 +305,12 @@ touchscreen@48 {
 };
 
 &pm6350_gpios {
-	gpio_keys_state: gpio-keys-state {
-		key-volume-down-pins {
-			pins = "gpio2";
-			function = PMIC_GPIO_FUNC_NORMAL;
-			power-source = <0>;
-			bias-disable;
-			input-enable;
-		};
+	vol_down_n: vol-down-n-state {
+		pins = "gpio2";
+		function = PMIC_GPIO_FUNC_NORMAL;
+		power-source = <0>;
+		bias-disable;
+		input-enable;
 	};
 };
 
-- 
2.39.2



