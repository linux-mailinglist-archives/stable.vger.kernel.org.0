Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3022593961
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbiHOSf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243453AbiHOSeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:34:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966CB39BBD;
        Mon, 15 Aug 2022 11:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18B86B81062;
        Mon, 15 Aug 2022 18:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65805C433C1;
        Mon, 15 Aug 2022 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587739;
        bh=CMovCprZ5em9db8CogLOUydohomPphAegq0bOUxOIkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytuABXSJ2dSc/85NA/wmh9/ZwvTaiwwCwM9yyovJD/clX+3ysbFq9SK5zx3DF+sWk
         avmlea/T6Z1vJQcvNbUKkxRTlfANP2mjk9nthxo+MFvKHfN+NL5oAEipO9yCe6p5nV
         Sj3ie/g4ABe4IQb9o8q1oTGuvD8DQTRCFhJ8gq4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/779] ARM: dts: qcom: mdm9615: add missing PMIC GPIO reg
Date:   Mon, 15 Aug 2022 19:57:03 +0200
Message-Id: <20220815180344.914794691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit dc590cdc31f636ea15658f1206c3e380a53fb78e ]

'reg' property is required in SSBI children:
  qcom-mdm9615-wp8548-mangoh-green.dtb: gpio@150: 'reg' is a required property

Fixes: 2c5e596524e7 ("ARM: dts: Add MDM9615 dtsi")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220507194913.261121-11-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-mdm9615.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/qcom-mdm9615.dtsi b/arch/arm/boot/dts/qcom-mdm9615.dtsi
index dda2ceec6591..ad9b52d53ef9 100644
--- a/arch/arm/boot/dts/qcom-mdm9615.dtsi
+++ b/arch/arm/boot/dts/qcom-mdm9615.dtsi
@@ -324,6 +324,7 @@ rtc@11d {
 
 				pmicgpio: gpio@150 {
 					compatible = "qcom,pm8018-gpio", "qcom,ssbi-gpio";
+					reg = <0x150>;
 					interrupt-controller;
 					#interrupt-cells = <2>;
 					gpio-controller;
-- 
2.35.1



