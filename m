Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AAE59DC73
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354004AbiHWKYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354482AbiHWKVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E06DF6F;
        Tue, 23 Aug 2022 02:02:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E0AB81C54;
        Tue, 23 Aug 2022 09:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E51C433D6;
        Tue, 23 Aug 2022 09:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245370;
        bh=pRaXC91DvIHgqE68Sjaz/8NETFxUC89d4VwXxGdM7S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQhvfLIJQXbjLq2/G4eW5JRLtU4soKZPlyPiHnuzhUw5Y19wCxcOjBhu4Ylua9Jbs
         g4LP4BgPaGt64o47c1mhE5o/lCxgjlAdoE2q8/8emabtSIQ7NxOr0gSMDYMubOKJ2W
         8iTItS1Vy0pLQ1Z/5F0RwRRo3dXsgt8J9CxgjU5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/287] ARM: dts: ast2500-evb: fix board compatible
Date:   Tue, 23 Aug 2022 10:23:46 +0200
Message-Id: <20220823080102.163745102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

[ Upstream commit 30b276fca5c0644f3cb17bceb1bd6a626c670184 ]

The AST2500 EVB board should have dedicated compatible.

Fixes: 02440622656d ("arm/dst: Add Aspeed ast2500 device tree")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220529104928.79636-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-ast2500-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-ast2500-evb.dts b/arch/arm/boot/dts/aspeed-ast2500-evb.dts
index 2375449c02d0..10626452878a 100644
--- a/arch/arm/boot/dts/aspeed-ast2500-evb.dts
+++ b/arch/arm/boot/dts/aspeed-ast2500-evb.dts
@@ -5,7 +5,7 @@
 
 / {
 	model = "AST2500 EVB";
-	compatible = "aspeed,ast2500";
+	compatible = "aspeed,ast2500-evb", "aspeed,ast2500";
 
 	aliases {
 		serial4 = &uart5;
-- 
2.35.1



