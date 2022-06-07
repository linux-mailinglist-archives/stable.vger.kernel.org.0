Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571A7541BEA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381717AbiFGVzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382935AbiFGVwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2437823F88D;
        Tue,  7 Jun 2022 12:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9DF4B8220B;
        Tue,  7 Jun 2022 19:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD0DC385A2;
        Tue,  7 Jun 2022 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629003;
        bh=Vbdwe/T0f5JOUSiNqbAGHbB+2pd0/m5eObuptyLOk7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqd7VOF89q1/UW/D0rOg3eV35CqrRuByf9vd5Pwl7R89Us+eiX9k7bCw0Nyufcc8z
         BQtX71DGJQHRAYgqiLxZmpL7QYGJSridxSyHAZgf3D56E5+nZ1yQ3vp+dJ77QmkK21
         5lnb4CwOeEvLDjDe7rLPND5+dhePq8ZP3GlGuXeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 533/879] arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399
Date:   Tue,  7 Jun 2022 19:00:51 +0200
Message-Id: <20220607165018.344448695@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 4246d0bab2a8685e3d4aec2cb0ef8c526689ce96 ]

drive-impedance-ohm is introduced for emmc phy instead of pcie phy.

Fixes: fb8b7460c995 ("arm64: dts: rockchip: Define drive-impedance-ohm for RK3399's emmc-phy.")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/1647336426-154797-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 080457a68e3c..88f26d89eea1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1534,6 +1534,7 @@
 			reg = <0xf780 0x24>;
 			clocks = <&sdhci>;
 			clock-names = "emmcclk";
+			drive-impedance-ohm = <50>;
 			#phy-cells = <0>;
 			status = "disabled";
 		};
@@ -1544,7 +1545,6 @@
 			clock-names = "refclk";
 			#phy-cells = <1>;
 			resets = <&cru SRST_PCIEPHY>;
-			drive-impedance-ohm = <50>;
 			reset-names = "phy";
 			status = "disabled";
 		};
-- 
2.35.1



