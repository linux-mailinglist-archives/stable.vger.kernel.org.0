Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B50C6AE838
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjCGROO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCGRNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3044B87D8B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7144B819A8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D7EC433EF;
        Tue,  7 Mar 2023 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208904;
        bh=qR/JG7Zm/ogv5m47gGP7S+ubFN2hDpcH+T7U9ZfXzL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsD3NkUuUXpssiDhwM1yfAFkp0yTRI3hIh0oDsu5K2vLp85hlcjdpgwDDWyySs2sn
         z+nYqdXI43ffX+dDAjv8LsnmAdkJNgjqnlmKYAaz29FPhzRvuiG0RO/LX9Es8XFC/O
         ziH1ZyQQblImaRp/VGmgMYKiQzJXrCJ7L3ZHcUo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0047/1001] arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
Date:   Tue,  7 Mar 2023 17:46:59 +0100
Message-Id: <20230307170024.151414650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e7303651bbc76c848007f1cfac1fbeaa65f600d1 ]

Documentation/devicetree/bindings/net/ethernet-phy.yaml defines that the
node name for Ethernet PHYs should match the following pattern:
  ^ethernet-phy(@[a-f0-9]+)?$

Replace the underscore with a hyphen to adhere to this binding.

Fixes: 280c17df8fbf ("arm64: dts: meson: g12a: add mdio multiplexer")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-6-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 7f55d97f6c283..c063a144e0e7b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1694,7 +1694,7 @@ int_mdio: mdio@1 {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					internal_ephy: ethernet_phy@8 {
+					internal_ephy: ethernet-phy@8 {
 						compatible = "ethernet-phy-id0180.3301",
 							     "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.39.2



