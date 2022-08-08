Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD8F58BF8F
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiHHBmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242824AbiHHBlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2582412AFC;
        Sun,  7 Aug 2022 18:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F8D60DF5;
        Mon,  8 Aug 2022 01:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EF2C433D7;
        Mon,  8 Aug 2022 01:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922501;
        bh=H9BOwCrBvhJ2D/pmVP5DNxKN0ES8c7NcKffve4+d2QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN5sXbtP4MT27p4+8cLReANDKKxzZUBzYtDQNLXzoEi3cECWdHdFlSXxseZ4BVPtR
         11RdKqmjy4O/tTa37ERc5yvO4rxet29NId9g+15mov3v/bW9z0JV/FyukYaEjR86Y2
         iAtvBVvf6MLv1NV9MRTbU5ffCd4Xw9P+bfOuWGi5LO1c2/8e/2VbVxxgffwAbAGgh/
         EiO0DzZnKbXCrulK4GLZtZl/R9eju/oejAMqBZBGFmyUhuWXou3V6jaP54RuInY19A
         itb5tvfvDU6jRZgGklMYlJql+bplwfM2IYAjoKVTx+UUh/i0I2JFfbvTHAc1TrT0pS
         zNqcu3RidUZVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 24/53] ARM: dts: imx6ul: fix keypad compatible
Date:   Sun,  7 Aug 2022 21:33:19 -0400
Message-Id: <20220808013350.314757-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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

[ Upstream commit 7d15e0c9a515494af2e3199741cdac7002928a0e ]

According to binding, the compatible shall only contain imx6ul and imx21
compatibles. Fixes the dt_binding_check warning:
keypad@20b8000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-kpp', 'fsl,imx6q-kpp', 'fsl,imx21-kpp'] is too long
Additional items are not allowed ('fsl,imx6q-kpp', 'fsl,imx21-kpp' were
unexpected)
Additional items are not allowed ('fsl,imx21-kpp' was unexpected)
'fsl,imx21-kpp' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 2fcbd9d91521..df8b4ad62418 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -544,7 +544,7 @@ fec2: ethernet@20b4000 {
 			};
 
 			kpp: keypad@20b8000 {
-				compatible = "fsl,imx6ul-kpp", "fsl,imx6q-kpp", "fsl,imx21-kpp";
+				compatible = "fsl,imx6ul-kpp", "fsl,imx21-kpp";
 				reg = <0x020b8000 0x4000>;
 				interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_KPP>;
-- 
2.35.1

