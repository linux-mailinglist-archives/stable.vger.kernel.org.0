Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F44358BF02
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbiHHBew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242178AbiHHBdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27639AE60;
        Sun,  7 Aug 2022 18:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C41C8B80E0A;
        Mon,  8 Aug 2022 01:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D1CC4347C;
        Mon,  8 Aug 2022 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922366;
        bh=kOSR+0U1mUJKjfVnIM3iHP1kjHk8W/lX2Xo52qIYRy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrUamjtnECl6kSJKcTdw3DdpiI7MNh+0mv93nJajBhxcRdBVWpCfvYlQlck87sFtc
         QPsRNhD+0oFJ4XvwI8pLNbV3YIrU1+M2uMl1QFKu9i9qchj1tI6JpYQ9L0p2GRk6Pm
         GVCF71e3HFxjSFyzw+B2ybANFy9R8KRzpXeT1IbcHms6+1EMZUOkIXA428h8pRsTWU
         nenLfuWGvCppjVbxm+tnUfz30xlaTjjjEuimgPBa5AKQLDVWcySCdjLD7FdhIxIo9v
         3929kFxln31EDelP93rL8n6NtmcRIbIfziY/WmjciwuEuqL46aAeGEB4NCBlyzeEJG
         LgUsE8vSSARUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 27/58] ARM: dts: imx6ul: fix lcdif node compatible
Date:   Sun,  7 Aug 2022 21:30:45 -0400
Message-Id: <20220808013118.313965-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
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
index 367657a9a99f..bc6548058d8c 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -1008,7 +1008,7 @@ csi: csi@21c4000 {
 			};
 
 			lcdif: lcdif@21c8000 {
-				compatible = "fsl,imx6ul-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx6ul-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x021c8000 0x4000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_LCDIF_PIX>,
-- 
2.35.1

