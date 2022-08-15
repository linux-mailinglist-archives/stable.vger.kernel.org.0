Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AB5593E02
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345965AbiHOUe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348372AbiHOUcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F524D818;
        Mon, 15 Aug 2022 12:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DACA4612A0;
        Mon, 15 Aug 2022 19:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A3EC433C1;
        Mon, 15 Aug 2022 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590341;
        bh=mBoLFm9NwPRE3ZpSE3rj81+UytlL97KQIUPsRFMbypc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV7JXeAgWe/hp2yKjTpGFYzOdCWfO8C4/sRc/jxEg8epZIZAwesotgEQW/lneyqY8
         siFV1KsAXeR/Jhbb1nuMbcGELN/G63cnSooCdQmX9YbL3KERazEfSQNtfpCzv5I1Mx
         SKg5EUCgv05+NRPK2mq71cLXbwT0LgJQpY0H/eJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0199/1095] ARM: dts: ast2500-evb: fix board compatible
Date:   Mon, 15 Aug 2022 19:53:18 +0200
Message-Id: <20220815180437.868059004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 1d24b394ea4c..a497dd135491 100644
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



