Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1453A821
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352236AbiFAOGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354731AbiFAOFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042B1AE247;
        Wed,  1 Jun 2022 06:59:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D96936149F;
        Wed,  1 Jun 2022 13:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418B9C3411F;
        Wed,  1 Jun 2022 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091946;
        bh=meEEYYb4Q/Zwm6saccKdiTfafAQE+aqAUob7xdy2nqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFHLD0e734PKcb/cr4JL6e3f4W/+KUzMD+GZTpdSbMdXfNiVeWJuCPgP2msfI7zLr
         oc0xTyRfxDCkS7hdCyHhWKlJJ+Q0tk/FHN0WjKN4vVoB7kbG6HN0aVvXnF4k/ZlCeM
         qfIxwAJazHaoEylARAmdZLRTKOFeU3tm1jVZx28ny3t+TKj9J3ILetO74wbwgGVzjc
         SMNvDW0G9S8STGObunWaHv5pMf3n6poDlUlbaS8cQ7SkZdl/+TS89DexjWutDi5+3N
         h/cUZc4oBUPztOn2sEdYVJk8xGo8EpEFo7fWPybG4gbGp4HBwDZnerUC2iGTctiltU
         az/sbaCA4h6Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/20] ARM: dts: ox820: align interrupt controller node name with dtschema
Date:   Wed,  1 Jun 2022 09:58:44 -0400
Message-Id: <20220601135902.2004823-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit fbcd5ad7a419ad40644a0bb8b4152bc660172d8a ]

Fixes dtbs_check warnings like:

  gic@1000: $nodename:0: 'gic@1000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220317115705.450427-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ox820.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ox820.dtsi b/arch/arm/boot/dts/ox820.dtsi
index 90846a7655b4..dde4364892bf 100644
--- a/arch/arm/boot/dts/ox820.dtsi
+++ b/arch/arm/boot/dts/ox820.dtsi
@@ -287,7 +287,7 @@ local-timer@600 {
 				clocks = <&armclk>;
 			};
 
-			gic: gic@1000 {
+			gic: interrupt-controller@1000 {
 				compatible = "arm,arm11mp-gic";
 				interrupt-controller;
 				#interrupt-cells = <3>;
-- 
2.35.1

