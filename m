Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED76593E7A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344887AbiHOUnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347181AbiHOUmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:42:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C990B2494;
        Mon, 15 Aug 2022 12:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AED4C61281;
        Mon, 15 Aug 2022 19:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EAAC433D6;
        Mon, 15 Aug 2022 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590466;
        bh=nopleTF8fMQXk8bNd5NGN8KmEIJTFbLHWc4+tjhqO4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6goLsMqFcY3YuMThpPIa2VHiIThBO3O/LqPhybCa+vPbyElQvZa4QktNq3CMtHDw
         e2JWFdI8xAF9dWYP6oU04vqzdTorAyU2IfZQX6zmrz/3QHTN7xJHMmmo/R9NRXtzwr
         i3yzmoW75hXTsU00ml04S9YBxiNYrLE5VHcnV/Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0228/1095] ARM: dts: qcom-msm8974*: Fix I2C labels
Date:   Mon, 15 Aug 2022 19:53:47 +0200
Message-Id: <20220815180439.156592149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit bb167546d06847a8729c973fe5165a231fd5c39d ]

Fix up the label names and add missing ones.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220415115633.575010-5-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 689ddaabf463..6e99903bb5f9 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -959,7 +959,7 @@ msmgpio: pinctrl@fd510000 {
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
-		i2c@f9923000 {
+		blsp1_i2c1: i2c@f9923000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9923000 0x1000>;
@@ -970,7 +970,7 @@ i2c@f9923000 {
 			#size-cells = <0>;
 		};
 
-		i2c@f9924000 {
+		blsp1_i2c2: i2c@f9924000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9924000 0x1000>;
@@ -981,7 +981,7 @@ i2c@f9924000 {
 			#size-cells = <0>;
 		};
 
-		blsp_i2c3: i2c@f9925000 {
+		blsp1_i2c3: i2c@f9925000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9925000 0x1000>;
@@ -992,7 +992,7 @@ blsp_i2c3: i2c@f9925000 {
 			#size-cells = <0>;
 		};
 
-		blsp_i2c6: i2c@f9928000 {
+		blsp1_i2c6: i2c@f9928000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9928000 0x1000>;
@@ -1003,7 +1003,7 @@ blsp_i2c6: i2c@f9928000 {
 			#size-cells = <0>;
 		};
 
-		blsp_i2c8: i2c@f9964000 {
+		blsp2_i2c2: i2c@f9964000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9964000 0x1000>;
@@ -1014,7 +1014,7 @@ blsp_i2c8: i2c@f9964000 {
 			#size-cells = <0>;
 		};
 
-		blsp_i2c11: i2c@f9967000 {
+		blsp2_i2c5: i2c@f9967000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9967000 0x1000>;
@@ -1027,7 +1027,7 @@ blsp_i2c11: i2c@f9967000 {
 			dma-names = "tx", "rx";
 		};
 
-		blsp_i2c12: i2c@f9968000 {
+		blsp2_i2c6: i2c@f9968000 {
 			status = "disabled";
 			compatible = "qcom,i2c-qup-v2.1.1";
 			reg = <0xf9968000 0x1000>;
-- 
2.35.1



