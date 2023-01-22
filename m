Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B2676FFC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjAVP1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjAVP1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4932311D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B2C460C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1FFC433D2;
        Sun, 22 Jan 2023 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401233;
        bh=liJ1Wxb657V0Afrt/n0rAILfYVeGxBaUHOMwVET+pfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnV0Y7N8XaswxS0MdVN867GFGV/V29H3u4V486oZiXbNjlqE/BdsokqWJPXbgBnzg
         ekL8noK3dJUI8xcVlcRTUO2JpHmp9stYff9Z+5Z601FsiNk2MtZYJl2A8wiPbdI63x
         moYsO3VNVdk4nIR3gIJTMhcdM9nXOathdLpEwhAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 132/193] ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI
Date:   Sun, 22 Jan 2023 16:04:21 +0100
Message-Id: <20230122150252.369707574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 0154252a3b87f77db1e44516d1ed2e82e2d29c30 upstream.

While changing node names of APQ8084 SDHCI, the ones in IFC6540 board
were not updated leading to disabled and misconfigured SDHCI.

Cc: <stable@vger.kernel.org>
Fixes: 2477d81901a2 ("ARM: dts: qcom: Fix sdhci node names - use 'mmc@'")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221204084614.12193-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |   20 ++++++++++----------
 arch/arm/boot/dts/qcom-apq8084.dtsi        |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
+++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
@@ -19,16 +19,16 @@
 		serial@f995e000 {
 			status = "okay";
 		};
+	};
+};
 
-		sdhci@f9824900 {
-			bus-width = <8>;
-			non-removable;
-			status = "okay";
-		};
+&sdhc_1 {
+	bus-width = <8>;
+	non-removable;
+	status = "okay";
+};
 
-		sdhci@f98a4900 {
-			cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
-			bus-width = <4>;
-		};
-	};
+&sdhc_2 {
+	cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
+	bus-width = <4>;
 };
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -419,7 +419,7 @@
 			status = "disabled";
 		};
 
-		mmc@f9824900 {
+		sdhc_1: mmc@f9824900 {
 			compatible = "qcom,apq8084-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
 			reg-names = "hc", "core";
@@ -432,7 +432,7 @@
 			status = "disabled";
 		};
 
-		mmc@f98a4900 {
+		sdhc_2: mmc@f98a4900 {
 			compatible = "qcom,apq8084-sdhci", "qcom,sdhci-msm-v4";
 			reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
 			reg-names = "hc", "core";


