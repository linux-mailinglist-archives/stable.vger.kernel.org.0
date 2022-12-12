Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33C064A145
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiLLNhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiLLNhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583AC13F1F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA8AB80D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED079C433F1;
        Mon, 12 Dec 2022 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852210;
        bh=TGHKlg9cl+zLIX/Xqqo2KxgkK5aAAi1hORmCdKk39bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RisYgRNxFdLqEQ/xrCMsKM55wxjJ2qcdE1iqc8lp9GrCkc5uHSJK2NhzQUo2iXErz
         i0plzxH/MX/aENZ31pSyGf9+qyiD86o5kJXF8PzaXLqk8jUgYcBocQi3Bxqj+V2iAh
         wbPHUSHf5NNLNF9qiPVidZNZ9gIAZR4xt5NbnkIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 008/157] arm: dts: rockchip: fix node name for hym8563 rtc
Date:   Mon, 12 Dec 2022 14:15:56 +0100
Message-Id: <20221212130934.747610686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 17b57beafccb4569accbfc8c11390744cf59c021 ]

Fix the node name for hym8563 in all arm rockchip devicetrees.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20221024165549.74574-4-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036-evb.dts          | 2 +-
 arch/arm/boot/dts/rk3288-evb-act8846.dts  | 2 +-
 arch/arm/boot/dts/rk3288-firefly.dtsi     | 2 +-
 arch/arm/boot/dts/rk3288-miqi.dts         | 2 +-
 arch/arm/boot/dts/rk3288-rock2-square.dts | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624efb9..ea23ba98625e 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -31,7 +31,7 @@
 &i2c1 {
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index be695b8c1f67..8a635c243127 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -54,7 +54,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563@51 {
+	rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index 052afe5543e2..9267857beccb 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -233,7 +233,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index 713f55e143c6..e3d5644f2915 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -162,7 +162,7 @@
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index 80e0f07c8e87..07a3a52753d2 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -165,7 +165,7 @@
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-- 
2.35.1



