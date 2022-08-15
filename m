Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9061593E06
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243263AbiHOUeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348399AbiHOUci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847AAA99F8;
        Mon, 15 Aug 2022 12:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3884F61281;
        Mon, 15 Aug 2022 19:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162FFC433C1;
        Mon, 15 Aug 2022 19:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590347;
        bh=jztBd4sZFkZnnNSyY7Gg8qvaMjbW9hiYtsi5arzlBw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGGQ/w91uGC79X4Sa3TbrlnSolI+J+w6YoqefIvod/3sQwHleERA8GOhkYLYx4wJl
         g2w2DSVdSz2hkjy0nsHGkV2Fh3IdvpTTXHbktZ6h4aMsDel0JFfx7GsOJo9evWBA9e
         FFsP6SYJjg2U46wFadwDgWqjYiOHVDtMHTITuLG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0201/1095] ARM: dts: ast2600-evb-a1: fix board compatible
Date:   Mon, 15 Aug 2022 19:53:20 +0200
Message-Id: <20220815180437.953414089@linuxfoundation.org>
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

[ Upstream commit 33c39140cc298e0d4e36083cb9a665a837773a60 ]

The AST2600 EVB A1 board should have dedicated compatible.

Fixes: a72955180372 ("ARM: dts: aspeed: ast2600evb: Add dts file for A1 and A0")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220529104928.79636-6-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts b/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
index dd7148060c4a..d0a5c2ff0fec 100644
--- a/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
+++ b/arch/arm/boot/dts/aspeed-ast2600-evb-a1.dts
@@ -5,6 +5,7 @@
 
 / {
 	model = "AST2600 A1 EVB";
+	compatible = "aspeed,ast2600-evb-a1", "aspeed,ast2600";
 
 	/delete-node/regulator-vcc-sdhci0;
 	/delete-node/regulator-vcc-sdhci1;
-- 
2.35.1



