Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAF5F2610
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJBWtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJBWtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625F62608;
        Sun,  2 Oct 2022 15:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7FA2B8058E;
        Sun,  2 Oct 2022 22:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1DCC433C1;
        Sun,  2 Oct 2022 22:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664750976;
        bh=4JCiA5c4NdAx7YY0hwes4pyrpsIJwxT/BMs6N3Jek1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpzQS0M7IC6XvE8v1RIX5gtDwmlqoHoWdmadoE3B92Qz8kPpC7V+UCoVSSr7qkRje
         rTVPeis17fEEvoTXvKvGg+AIOxihkgjZC9qMY206Y1AyMg1Phi0BSBEFHSkKwQOD3C
         DOC5UYPFAaNS/ZG9SWOTU7VRyWiY8+01ZKr0wNlQ6n2dBw1Ocimo44jV0JJDqbb4i0
         ITeGBQ29iNPJlku+yXuagqzkf64XmzQKG924BDXbeOAltzE41rNnkHgTP98eMiirvn
         SM/9q8E0WU8Om+hF670pns+nf0ttL83h9OWZu80cEX9rPhNw1aPFmMcE3nhbh5OCTD
         FOzX1n6oHKfLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael.riesch@wolfvision.net,
        f.fainelli@gmail.com, kuba@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 05/29] arm64: dts: rockchip: fix upper usb port on BPI-R2-Pro
Date:   Sun,  2 Oct 2022 18:48:58 -0400
Message-Id: <20221002224922.238837-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 388f9f0a7ff84b7890a24499a3a1fea0cad21373 ]

- extcon is no more needed in 5.19 - so drop it
  commit 51a9b2c03dd3 ("phy: rockchip-inno-usb2: Handle ID IRQ")
- dr_mode was changed from host to otg in rk356x.dtsi
  commit bc405bb3eeee ("arm64: dts: rockchip: enable otg/drd
    operation of usb_host0_xhci in rk356x")
  change it back on board level as id-pin on r2pro is not connected

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20220821121929.244112-1-linux@fw-web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 40cf2236c0b6..ca48d9a54939 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -558,7 +558,7 @@ &usb_host0_ohci {
 };
 
 &usb_host0_xhci {
-	extcon = <&usb2phy0>;
+	dr_mode = "host";
 	status = "okay";
 };
 
-- 
2.35.1

