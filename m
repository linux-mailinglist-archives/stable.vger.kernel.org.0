Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842C158C0D4
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243588AbiHHBzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243428AbiHHBxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:53:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F190C1ADAD;
        Sun,  7 Aug 2022 18:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DEC7B80E15;
        Mon,  8 Aug 2022 01:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099FBC433C1;
        Mon,  8 Aug 2022 01:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922734;
        bh=WcmIH+a533U14dlH39GJ7KubRDRkt0POYB71uaAxXzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMphOm63u5k8E9xf5V3LM/VFXPts7XCAfEaIlgWZk8Aa7FNLZV+/eMNFAd/HCcgYN
         GBaAYRCtl339aHo9+Xk+3Pto+EgEyr8CHbmZBoE2o3Yy2hE8YccRUG/CLieKKCs0h+
         8FiTXbgUCMJo1sgzZSlyFGton0iQQqPAfiBWlCzBRK458V4QiNCT3O6qU+3myuB7Gm
         GOoXBudrZ/r2ig5gFCl5hNvKRRy3ocagr+m4kn2ieo2fops+7lQQoE3BFqfMh+M1JH
         WeUUeBzcDjLFrbKaAlwy1QpmbrLt1+MPLENAcfEIRsR0k4QEVpHDyMG3NztqwVc3Z7
         vwECy3VD6zG5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 11/23] ARM: dts: imx6ul: fix lcdif node compatible
Date:   Sun,  7 Aug 2022 21:38:18 -0400
Message-Id: <20220808013832.316381-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 1a884d17ca324531634cce82e9f64c0302bdf7de ]

In yaml binding "fsl,imx6ul-lcdif" is listed as compatible to imx6sx-lcdif,
but not imx28-lcdif. Change the list accordingly. Fixes the
dt_binding_check warning:
lcdif@21c8000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-lcdif', 'fsl,imx28-lcdif'] is too long
Additional items are not allowed ('fsl,imx28-lcdif' was unexpected)
'fsl,imx6ul-lcdif' is not one of ['fsl,imx23-lcdif', 'fsl,imx28-lcdif',
'fsl,imx6sx-lcdif']
'fsl,imx6sx-lcdif' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 3fd02e10170a..58671c6e9f31 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -976,7 +976,7 @@ csi: csi@21c4000 {
 			};
 
 			lcdif: lcdif@21c8000 {
-				compatible = "fsl,imx6ul-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx6ul-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x021c8000 0x4000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_LCDIF_PIX>,
-- 
2.35.1

