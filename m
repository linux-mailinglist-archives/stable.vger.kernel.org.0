Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13808599F65
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351000AbiHSQCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351388AbiHSQB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A785D106F8F;
        Fri, 19 Aug 2022 08:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 170E9B827F8;
        Fri, 19 Aug 2022 15:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B85C433D6;
        Fri, 19 Aug 2022 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924373;
        bh=qTUnxXCeskSydcOIGMtRvDbpv9gcuxN2Iov6IBxRw6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAy+WTn78BXs1hcgo0hSAER/mVrMZ9M/oDDt5bsd6ZoGelqjnuX09Al8oxLxtcN3m
         d7uUOssOppblyFkjJVsHzht4WSobPpJtx57DFSm5fpqYJHtG372R6pJqmZcocb8b5l
         UskBW74nCZOsPLUiK89l2rT4qlcNfD/bxf75XZZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/545] ARM: dts: ast2500-evb: fix board compatible
Date:   Fri, 19 Aug 2022 17:38:09 +0200
Message-Id: <20220819153834.610747027@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 8bec21ed0de5..7a874debb7d5 100644
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



