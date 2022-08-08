Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6AB58C076
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbiHHBwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243504AbiHHBvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C196D10F;
        Sun,  7 Aug 2022 18:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CD9760DF3;
        Mon,  8 Aug 2022 01:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED95C433D6;
        Mon,  8 Aug 2022 01:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922686;
        bh=chmQ/QxK3qmOWMj+owMuXHL1OP1NT36bYWpNDyJ2YCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSak4nV6KNA3GfCCrz7sdE5kqtTB7XNTYbC9wkINofGgcnvPK4XbyZJsUe1zMHUM4
         N2ZnadIpntg8Yk14Mwt5zSvSnkPqGnMfzGWUvEmGkydRoIuCtFrZzD/I8AvkI9tG/l
         Bcz2814QEQbeehQUjOb5DZaXN6THC6fv9n+Ot0aADzEBeNDTi3MuguURl24u00698G
         c6hEdsq0a/DTVjrcghX0zvCP6DWJB4I6R1wN8kCQ/ktEd2tlLt6lTjqCkkjFvsVvhP
         mf8++ChAsLmgbFbFyzityLFe7TKDtZz1psLYlvoMY+0rfVNYA58gYm9efiL5zZShII
         G1DGST0ucS1jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 15/29] ARM: dts: imx6ul: fix qspi node compatible
Date:   Sun,  7 Aug 2022 21:37:25 -0400
Message-Id: <20220808013741.316026-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
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

[ Upstream commit 0c6cf86e1ab433b2d421880fdd9c6e954f404948 ]

imx6ul is not compatible to imx6sx, both have different erratas.
Fixes the dt_binding_check warning:
spi@21e0000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-qspi', 'fsl,imx6sx-qspi'] is too long
Additional items are not allowed ('fsl,imx6sx-qspi' was unexpected)
'fsl,imx6ul-qspi' is not one of ['fsl,ls1043a-qspi']
'fsl,imx6ul-qspi' is not one of ['fsl,imx8mq-qspi']
'fsl,ls1021a-qspi' was expected
'fsl,imx7d-qspi' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 51de36b4125a..c40684ad11b8 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -1025,7 +1025,7 @@ pxp: pxp@21cc000 {
 			qspi: spi@21e0000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
-				compatible = "fsl,imx6ul-qspi", "fsl,imx6sx-qspi";
+				compatible = "fsl,imx6ul-qspi";
 				reg = <0x021e0000 0x4000>, <0x60000000 0x10000000>;
 				reg-names = "QuadSPI", "QuadSPI-memory";
 				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.35.1

