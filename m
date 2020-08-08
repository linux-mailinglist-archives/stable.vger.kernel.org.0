Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E2E23FB0F
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgHHXqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgHHXiP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4A3207BB;
        Sat,  8 Aug 2020 23:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929894;
        bh=i4zhqUPJ+dMplr2JiLDz7Y+XOtarvFX1bYE2TU8H5W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrGcMgdB7nOmzxrhnpKPs9OON3vUIklA7HO16FZvgMsMRCHX+8OtYoVRG2NAwlBVn
         4syq+dnkZ9lFG4kbGhiYbEQtJmHElArqzEBU64BeLKViMc9gBgHBabeoJPxULF40+E
         ueR6kHKF3SbX5lMku4W6FkeQ2GAtDvcrepU6CnuM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 35/58] ARM: dts: sunxi: bananapi-m2-plus-v1.2: Add regulator supply to all CPU cores
Date:   Sat,  8 Aug 2020 19:37:01 -0400
Message-Id: <20200808233724.3618168-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 55b271af765b0e03d1ff29502f81644b1a3c87fd ]

The device tree currently only assigns the a supply for the first CPU
core, when in reality the regulator supply is shared by all four cores.
This might cause an issue if the implementation does not realize the
sharing of the supply.

Assign the same regulator supply to the remaining CPU cores to address
this.

Fixes: 6eeb4180d4b9 ("ARM: dts: sunxi: h3-h5: Add Bananapi M2+ v1.2 device trees")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20200717160053.31191-3-wens@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
index 22466afd38a3a..a628b5ee72b65 100644
--- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
+++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus-v1.2.dtsi
@@ -28,3 +28,15 @@ reg_vdd_cpux: vdd-cpux {
 &cpu0 {
 	cpu-supply = <&reg_vdd_cpux>;
 };
+
+&cpu1 {
+	cpu-supply = <&reg_vdd_cpux>;
+};
+
+&cpu2 {
+	cpu-supply = <&reg_vdd_cpux>;
+};
+
+&cpu3 {
+	cpu-supply = <&reg_vdd_cpux>;
+};
-- 
2.25.1

