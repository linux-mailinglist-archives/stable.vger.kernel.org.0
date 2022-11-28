Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B537863AF00
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiK1RhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiK1RhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113EC15A25;
        Mon, 28 Nov 2022 09:37:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A17D2612C9;
        Mon, 28 Nov 2022 17:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98C9C433D6;
        Mon, 28 Nov 2022 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657028;
        bh=1cfBiJBr1IdGD5OunncKfYQQqGTw/trPDyLSOJe0zVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4X75BSf6k+Xvfm62Hrzdw9hOo6CimDOZZVEAWCm4qpX89KJG6yLcYEcczs8N2uow
         ZrmP4wgNc1YQofyCuhg/ZwMeac3e7wY+ma5BdBf3nT9AgNzxltbxTRS8l04ZU/mObR
         JgCDHlYdhj/ukbCIZX0fny71bddNqYhBVawJIzzgYRSwi0csrA3O0tO8p2VKpxpL83
         UdJ3QHxUQ5ZOSupqYULuoXsVn9exgILTdh0LuDnePM2J09q8LoWyk1yctZ8TQ/Te//
         PDRngW81PkD8djnuIH4FtM8xw9JiQQd8CdZIfKBFAZV0g+fL2h26I/aW4c38n9djEm
         0mgSz6JCJgefw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Furkan Kardame <f.kardame@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael.riesch@wolfvision.net,
        pgwipeout@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 02/39] arm64: dts: rockchip: Fix i2c3 pinctrl on rk3566-roc-pc
Date:   Mon, 28 Nov 2022 12:35:42 -0500
Message-Id: <20221128173642.1441232-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Furkan Kardame <f.kardame@manjaro.org>

[ Upstream commit 2440ad0d851e404adcd1b9ad758f28bd59365bae ]

As per device schematic i2c3 pinctrl is connected to m0 instead of m1

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-3-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 8db83088ae4e..b8ed215ab8fb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -397,7 +397,7 @@ &i2c2 {
 
 &i2c3 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&i2c3m1_xfer>;
+	pinctrl-0 = <&i2c3m0_xfer>;
 	status = "okay";
 };
 
-- 
2.35.1

