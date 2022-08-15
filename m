Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF159451A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiHOWmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350638AbiHOWkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8352C615B;
        Mon, 15 Aug 2022 12:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB0DB80EA9;
        Mon, 15 Aug 2022 19:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87433C433D6;
        Mon, 15 Aug 2022 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593107;
        bh=qNz4JfMI0v2VeODct3syTPUB6qm3V56pmE/a8K3WT8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mt3OsnHIvU5MpDpFEZM4S4r4m3Ps8oqNE7NQ7lhk7m6pvaaPjgpHKpJqXA+XMyinF
         5lECNQVkWothCrPf4BXyDWZYIpJZKBVMvndeCF/zpNxoMWWcHbDRocxTBchhposJ/f
         0TM0WZ+YE4ZOAhxaiGqJamEe6wLjooyTFX1sqzzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0215/1157] ARM: dts: ast2600-evb: fix board compatible
Date:   Mon, 15 Aug 2022 19:52:51 +0200
Message-Id: <20220815180448.212888892@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit aa5e06208500a0db41473caebdee5a2e81d5a277 ]

The AST2600 EVB board should have dedicated compatible.

Fixes: 2ca5646b5c2f ("ARM: dts: aspeed: Add AST2600 and EVB")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220529104928.79636-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-ast2600-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-ast2600-evb.dts b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
index 5a6063bd4508..c698e6538269 100644
--- a/arch/arm/boot/dts/aspeed-ast2600-evb.dts
+++ b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
@@ -8,7 +8,7 @@
 
 / {
 	model = "AST2600 EVB";
-	compatible = "aspeed,ast2600";
+	compatible = "aspeed,ast2600-evb-a1", "aspeed,ast2600";
 
 	aliases {
 		serial4 = &uart5;
-- 
2.35.1



