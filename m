Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2B6A72D6
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCASKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjCASJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6E238EAE
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2976861386
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA0C433EF;
        Wed,  1 Mar 2023 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694180;
        bh=dR48OY8aVGo34Mg7QbsDYaBAEmhILHfoEhTOHDO8UNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3ie+YW5dDjTv9Osxp8R+b/7PmVWvLrsp11clZPgTU40E6VKcrPVakG+hXSIJM7dA
         GALVL575MHYPxCaYYxSmRaC1EwO3CbXqegyF9/eyKSDys8jj8zb+QFUxPHayDPZhLq
         VV+Stc+ACmUbSYiRslDdYinvgW1TJts8VJEeB4qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 02/19] arm64: dts: rockchip: drop unused LED mode property from rk3328-roc-cc
Date:   Wed,  1 Mar 2023 19:08:31 +0100
Message-Id: <20230301180652.424688783@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1692bffec674551163a7a4be32f59fdde04ecd27 ]

GPIO LEDs do not have a 'mode' property:

  rockchip/rk3328-roc-pc.dtb: leds: led-0: Unevaluated properties are not allowed ('mode' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221125144135.477144-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index daa9a0c601a9f..22ab5e1d7319d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -91,7 +91,6 @@ power_led: led-0 {
 			linux,default-trigger = "heartbeat";
 			gpios = <&rk805 1 GPIO_ACTIVE_LOW>;
 			default-state = "on";
-			mode = <0x23>;
 		};
 
 		user_led: led-1 {
@@ -99,7 +98,6 @@ user_led: led-1 {
 			linux,default-trigger = "mmc1";
 			gpios = <&rk805 0 GPIO_ACTIVE_LOW>;
 			default-state = "off";
-			mode = <0x05>;
 		};
 	};
 };
-- 
2.39.0



