Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E783C8FFB
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhGNTxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240759AbhGNTuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E04661454;
        Wed, 14 Jul 2021 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291962;
        bh=1vO8FQ1Z/MvUtJmcWVdMlwt5H3V4dDjG3iIhLP798ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbRWpPVVcRevO4psyQwDrr1jEQVxgLVxTXUjeT7S9w5rYRERjokzHtDrv9gU6jhTM
         273t9yzdtbIOwNA2q/7gzBhg6S9XGZCBaTIrbNUZzSRuxpXGfuavq+gs01esQ5J/Mc
         bELS/q8EzIzELVhepeGLAXxCez6T3R7OjeKsQdzWvvJhFS60fnAWlaY1MSiUZ4qPxQ
         io8JFQVfspMy+WeQL4+q8Kvg1zp5fHCqAaqsmtnnT+SPjiV73uK2NC3CDui3eSPwtz
         3KudAW8FsndV4uB42s5Iy/6BYx39tkAf50NAYN7kTKw8bHhr4bm6kg3bkeFsAX6rbU
         z75luzo0cI0Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/51] ARM: dts: rockchip: fix supply properties in io-domains nodes
Date:   Wed, 14 Jul 2021 15:44:56 -0400
Message-Id: <20210714194513.54827-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit f07edc41220b14ce057a4e6d7161b30688ddb8a2 ]

A test with rockchip-io-domain.yaml gives notifications
for supply properties in io-domains nodes.
Fix them all into ".*-supply$" format.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210606181632.13371-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288-rock2-som.dtsi | 2 +-
 arch/arm/boot/dts/rk3288-vyasa.dts      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-rock2-som.dtsi b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
index 9f9e2bfd1295..7b79a21f9bbb 100644
--- a/arch/arm/boot/dts/rk3288-rock2-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-rock2-som.dtsi
@@ -218,7 +218,7 @@ &io_domains {
 	flash0-supply = <&vcc_flash>;
 	flash1-supply = <&vccio_pmu>;
 	gpio30-supply = <&vccio_pmu>;
-	gpio1830 = <&vcc_io>;
+	gpio1830-supply = <&vcc_io>;
 	lcdc-supply = <&vcc_io>;
 	sdcard-supply = <&vccio_sd>;
 	wifi-supply = <&vcc_18>;
diff --git a/arch/arm/boot/dts/rk3288-vyasa.dts b/arch/arm/boot/dts/rk3288-vyasa.dts
index ba06e9f97ddc..acfb7dc2df56 100644
--- a/arch/arm/boot/dts/rk3288-vyasa.dts
+++ b/arch/arm/boot/dts/rk3288-vyasa.dts
@@ -357,10 +357,10 @@ &io_domains {
 	audio-supply = <&vcc_18>;
 	bb-supply = <&vcc_io>;
 	dvp-supply = <&vcc_io>;
-	flash0-suuply = <&vcc_18>;
+	flash0-supply = <&vcc_18>;
 	flash1-supply = <&vcc_lan>;
 	gpio30-supply = <&vcc_io>;
-	gpio1830 = <&vcc_io>;
+	gpio1830-supply = <&vcc_io>;
 	lcdc-supply = <&vcc_io>;
 	sdcard-supply = <&vccio_sd>;
 	wifi-supply = <&vcc_18>;
-- 
2.30.2

