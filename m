Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191023C8E12
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhGNTqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235114AbhGNTpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81F94613EB;
        Wed, 14 Jul 2021 19:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291733;
        bh=OlsKuSpdklUjpvAA6bTSRDA+ID/On4uE3M0rjUuFnNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfmkqyvEf2osQkiQ3czRD7HFNl4kcQwvlUUVfcQIdaytGAkMaEByrAAp71COHSj0l
         AG5k+oy00S2DKjR93Op6zOC0ZY83fWKF9+UKzGf9LZVxMunKW3YK+PffHtRp8gmTDs
         R/KPqtVNQ2uJC8K8OU0hsH9jCewRJAUZ6/txUzH6Dc1TPHVlsDnvWCFZXHVGJryLLf
         ydm8QrbYvl5xWDopu7Wt9FHhLyAx/kEZQoSJwYAvkSi2CmIv8gQ3nuYc9xA+9NuwvQ
         U8/m+A0VorROdGwVZIcy2bwEP2PpavfNfYnymZvJsKwfe5USTeC2vMMxb5sTIyjNLo
         dHaMr/BPBHBEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 068/102] ARM: dts: rockchip: fix supply properties in io-domains nodes
Date:   Wed, 14 Jul 2021 15:40:01 -0400
Message-Id: <20210714194036.53141-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 44bb5e6f83b1..76363b8afcb9 100644
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
index aa50f8ed4ca0..b156a83eb7d7 100644
--- a/arch/arm/boot/dts/rk3288-vyasa.dts
+++ b/arch/arm/boot/dts/rk3288-vyasa.dts
@@ -379,10 +379,10 @@ &io_domains {
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

