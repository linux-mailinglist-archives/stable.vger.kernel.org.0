Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B4B59D8DA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351163AbiHWJeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351068AbiHWJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:34:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C050E83BC7;
        Tue, 23 Aug 2022 01:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1547A61544;
        Tue, 23 Aug 2022 08:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17294C433C1;
        Tue, 23 Aug 2022 08:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243893;
        bh=UNiwTXmjdQ6KGQtbGIn0zAj/bX+4Qo6BgYbbX6UQpYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkTm9lt1Bp0bjjJAQXEI56mlMBZf1PwtC0ZudCSxomLeiFg7BaX52vG3DHw69k0lr
         GRgJ6BdMqLSf5KHmcaw58/CYXHdJTVyo6Mf+460usX6xqdsajz55yY359O2EQSlfS8
         u0d+/PbrQLQjgd9619nTIk+7o/PNKdVOEi5lXZC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/229] ARM: dts: ast2500-evb: fix board compatible
Date:   Tue, 23 Aug 2022 10:23:33 +0200
Message-Id: <20220823080055.562379798@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index c971cc93f42d..b7ee74a1fd94 100644
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



