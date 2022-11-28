Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6979A63B025
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiK1Rs3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiK1RrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4822E6A7;
        Mon, 28 Nov 2022 09:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0DC7B80E9F;
        Mon, 28 Nov 2022 17:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDD8C43470;
        Mon, 28 Nov 2022 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657328;
        bh=6j9auAtquAvmbmECLoOInfULo4v98BgNtruY34jf5go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBcU7XVSec7PV7YtE8LAPBy7kaXt0u0BNJ589yqwJLCfua6BZnTDeBBZXoEtn+dJs
         pqXen76t+0qMsuDMrngdeMGuHOgKnu0jjhS/6ZmH05r1I0k45+E+kfTrXTlHcmQWRt
         qMWm2UlDRFNog5wM8jqPs0UXvukM5QHiwnZOoq580SckJ/7GZHZTEaPI0wUGrq8JbZ
         vtTPxNlXOkZ+BvDbN3SgctbQ0WeqZTYQjFK5lVHwBlMyg9t/w754Hny1vTj0ew+QbT
         bFrmBFfCSY5/i9ut98jAWyIhIT5StobKxLY23typef13oz4mThC5u/O/gU6M5AKwxR
         15lD4ztNGfP6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/16] ARM: dts: rockchip: rk3188: fix lcdc1-rgb24 node name
Date:   Mon, 28 Nov 2022 12:41:47 -0500
Message-Id: <20221128174201.1442499-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174201.1442499-1-sashal@kernel.org>
References: <20221128174201.1442499-1-sashal@kernel.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 11871e20bcb23c00966e785a124fb72bc8340af4 ]

The lcdc1-rgb24 node name is out of line with the rest
of the rk3188 lcdc1 node, so fix it.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/7b9c0a6f-626b-07e8-ae74-7e0f08b8d241@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index ee8a24a0e3cb..95d558dc163c 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -404,7 +404,7 @@ lcdc1_vsync: lcdc1-vsync {
 				rockchip,pins = <2 RK_PD3 1 &pcfg_pull_none>;
 			};
 
-			lcdc1_rgb24: ldcd1-rgb24 {
+			lcdc1_rgb24: lcdc1-rgb24 {
 				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
 						<2 RK_PA1 1 &pcfg_pull_none>,
 						<2 RK_PA2 1 &pcfg_pull_none>,
-- 
2.35.1

