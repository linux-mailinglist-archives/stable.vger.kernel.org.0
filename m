Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43ECF58BEFE
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbiHHBeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242082AbiHHBdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB7DB85F;
        Sun,  7 Aug 2022 18:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA9860DDB;
        Mon,  8 Aug 2022 01:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7F1C433D7;
        Mon,  8 Aug 2022 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922367;
        bh=HopU/MPTRkH9+3zqqnsjOGCkMfvViXYpGAFABHbxMj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xp3oTZVHr+ABASjcPymU7C8zkv3wpRrvNauRCL32c15bghSxB2/ONV1wTZXHntqFh
         2bzRJVs0jAEad+IpRNeTGqlZezUwZ/NicbfdVYZYxPjROAr+VnYkRmLFnzjBslU5hG
         m005oOLhrqOSgZXx2LEJH7KnXua2kJv3ldUiRcFTq4tDkyj+0y8+hfpf6x3T/rSqv2
         f5K1kexfqY7Vtx+hB80ixrVC9SrpaCOfTTzcb0caYQkgmKxbEe0KaB3mtBpHvor5ry
         bW7QdUXt2eOZxnnpowyu7TRwpaNFA4V6vbbLYkM4RIrlvrKXw/5Jqbmp/7FDW8e/IY
         wKcrvQejLcOhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 28/58] ARM: dts: imx6ul: fix qspi node compatible
Date:   Sun,  7 Aug 2022 21:30:46 -0400
Message-Id: <20220808013118.313965-28-sashal@kernel.org>
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
index bc6548058d8c..eca8bf89ab88 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -1029,7 +1029,7 @@ pxp: pxp@21cc000 {
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

