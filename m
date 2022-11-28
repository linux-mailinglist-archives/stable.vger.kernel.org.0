Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA16463AF0A
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiK1Rhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiK1Rhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E70725D1;
        Mon, 28 Nov 2022 09:37:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 434D2B80E9B;
        Mon, 28 Nov 2022 17:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77C0C433B5;
        Mon, 28 Nov 2022 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657062;
        bh=i7d6n0QxI+WG3NAXPA/pOSGsRwxWik9K/vnEXTeXuQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bk0v+1wVVCI37SQM5c9YiA7qz/uWDxPYpTS0TiKaoXynwH64Y4gtsDMx+u8YsH7mi
         vh59Wnjh5CwFazVY5dh5cNMzsJvBCEsJ+lSXLlmfckZ/RJlBjnB9z6hsheI+d+hcaJ
         TT9XDi4przbTx6ACLrI1Z5nkDV034cbTrynrjbN9GfqUPTBNk18ZatZabs+K7L0EAc
         UySrFJS/sQRcSoxqIgvVBx3BHLiYmXzyOJ753kedI6GgJ4haeO9LaVpeg6h4ZRcUB2
         PgF5w+o2MUAI83lBWnhKeq+5VzZQ92OBOytJp4+e/fCT0sONASJlsOcvhQnRBn0C4T
         5B6Lsic9ibEzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        niklas.soderlund+renesas@ragnatech.se, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 05/39] arm64: dts: rockchip: fix node name for hym8563 rtc
Date:   Mon, 28 Nov 2022 12:35:45 -0500
Message-Id: <20221128173642.1441232-5-sashal@kernel.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 67a9aeef44e42b1ac2becf5e61eae0880f48d9db ]

Fix the node name for hym8563 in all arm64 rockchip devicetrees.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20221024165549.74574-2-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts | 2 +-
 arch/arm64/boot/dts/rockchip/rk3368-r88.dts            | 2 +-
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts    | 2 +-
 arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts b/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
index 7f5bba0c6001..0e88e9592c1c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
@@ -208,7 +208,7 @@ vdd_cpu: syr827@40 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3368-r88.dts b/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
index 38d757c00548..e147d6f8b43e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
@@ -192,7 +192,7 @@ vdd_cpu: syr827@40 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
index 5a2661ae0131..18b5050c6cd3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
@@ -98,7 +98,7 @@ &fusb0 {
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		interrupt-parent = <&gpio0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
index 935b8c68a71d..6c168566321b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
@@ -297,7 +297,7 @@ &i2c2 {
 	clock-frequency = <400000>;
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-- 
2.35.1

