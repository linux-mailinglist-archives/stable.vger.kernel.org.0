Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4187469862C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjBOUsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjBOUrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C3343925;
        Wed, 15 Feb 2023 12:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DAF9B823B9;
        Wed, 15 Feb 2023 20:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57CC4339E;
        Wed, 15 Feb 2023 20:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494014;
        bh=wJjitCtu67QPs/ERyzS9chbzU+MB0cUw34vx3jCuz6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBhss09FtMApvRK77WPLaMEwDcwOt9M1DejrtlyhirOqinJgIEj3ldjwj9T55kV+z
         FLr4f5Idl56PimfPNg+lgdQ+j0B2I4SqH91k7HfrMSe9qVPceGEH9xwbF9lUEKIz3k
         KleSj6JFLPIhAxYjP1+K2MUd2N5HcSNk/Ik3y+PHavnOmEwPKXfPZorB08Jv1Bc3YR
         5RM4a5eoN9r7appEweRdJKVjYRICnnOe9jE0Qi8F30lajop57bOgE8U//cO2KjFjS2
         HBBJ4s2ps4mhUeQWYHC3iLl8974lGDyql13rgq3mdFFvkBrq5YNCKAU2LJl7nPdcfg
         s6Iei2H800KPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/8] ARM: dts: rockchip: add power-domains property to dp node on rk3288
Date:   Wed, 15 Feb 2023 15:46:44 -0500
Message-Id: <20230215204649.2761225-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204649.2761225-1-sashal@kernel.org>
References: <20230215204649.2761225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 80422339a75088322b4d3884bd12fa0fe5d11050 ]

The clocks in the Rockchip rk3288 DisplayPort node are
included in the power-domain@RK3288_PD_VIO logic, but the
power-domains property in the dp node is missing, so fix it.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/dab85bfb-9f55-86a1-5cd5-7388c43e0ec5@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 9051fb4a267d4..aab28161b9ae9 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1203,6 +1203,7 @@ edp: dp@ff970000 {
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
-- 
2.39.0

