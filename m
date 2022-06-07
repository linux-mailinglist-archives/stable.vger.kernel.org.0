Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E61B5414BF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358769AbiFGUVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359819AbiFGUVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215811D30E3;
        Tue,  7 Jun 2022 11:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527B4B822C0;
        Tue,  7 Jun 2022 18:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C075DC385A2;
        Tue,  7 Jun 2022 18:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626641;
        bh=Vbdwe/T0f5JOUSiNqbAGHbB+2pd0/m5eObuptyLOk7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUTHpMME7mvmEFH8vXgr8OztNTma7n+nesEPS3UQm3NtD4uVjbxhAYg1Jc2TyIlof
         I5HE111+nriFCaa0R91MkHttpHf2/YS8IEIJoOjG9U4F5wxWQwgSicrdgQrgbtVQc7
         D1L3jjqq0Ox0/NHd1lxNqrzoIIKhKVIdGE0emoVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 451/772] arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399
Date:   Tue,  7 Jun 2022 19:00:43 +0200
Message-Id: <20220607165002.291945466@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



