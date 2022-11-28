Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373C263AEFD
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiK1Rgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiK1Rgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:36:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D5F15A0C;
        Mon, 28 Nov 2022 09:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F6AEB80E97;
        Mon, 28 Nov 2022 17:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F65AC433D6;
        Mon, 28 Nov 2022 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657005;
        bh=cqayjWhVXOPT0NLMgpKoGr2BJ1Uut2aHwfwUhFuDN3U=;
        h=From:To:Cc:Subject:Date:From;
        b=L5WzaLqs5+qrysgfrmGYN4efhaFAkz4QRAixo7mb+cdFXxCxsqHVKu2k7ryRbow1G
         4Kn5zggQ9BMxdFNKQSbpu+GncwG2lVMI0Dz+XDghkky7VXQ1LTZkGe1O+jIdXkxhng
         wLkYoriLNNEJOWqKeLELxldj30gJ0YsbL3KMDMrl0ycdifs1bKifXCPSvPBR9fiVE5
         FWzR+IO2hyIfLpzFBVP58frTqRbQ9LCnuZxFnNNMj/15UyQIPdsfUH72HgkMFgSf9X
         CmXGpAnds34FyzkrlJ22RbL8cmjJAKZ1lIeCp2Zi8KOQRxY5QakCgz+Z49JpxFVlZj
         pjDH5VyFxumVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Furkan Kardame <f.kardame@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, michael.riesch@wolfvision.net,
        pgwipeout@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 01/39] arm64: dts: rockchip: Fix gmac failure of rgmii-id from rk3566-roc-pc
Date:   Mon, 28 Nov 2022 12:35:41 -0500
Message-Id: <20221128173642.1441232-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

[ Upstream commit adbab347ec8861aa80d850693df3cd005ec65a99 ]

Lan does not work on rgmii-id, most rk356x devices lan
is being switched to rgmii.

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-2-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 57759b66d44d..8db83088ae4e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -130,7 +130,7 @@ &gmac1 {
 	assigned-clocks = <&cru SCLK_GMAC1_RX_TX>, <&cru SCLK_GMAC1_RGMII_SPEED>, <&cru SCLK_GMAC1>;
 	assigned-clock-parents = <&cru SCLK_GMAC1_RGMII_SPEED>, <&cru SCLK_GMAC1>, <&gmac1_clkin>;
 	clock_in_out = "input";
-	phy-mode = "rgmii-id";
+	phy-mode = "rgmii";
 	phy-supply = <&vcc_3v3>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac1m0_miim
-- 
2.35.1

