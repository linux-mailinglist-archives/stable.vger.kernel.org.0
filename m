Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434723F9F3
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgHHXjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgHHXjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:39:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B8B20791;
        Sat,  8 Aug 2020 23:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929961;
        bh=i4zhqUPJ+dMplr2JiLDz7Y+XOtarvFX1bYE2TU8H5W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPt7TBdGnlxCJ+s4LUU12GN7i6pgVcWxyrZYX2Y1+wB2j5LxatNj9eq5rrl9kZJZs
         +UdcqqujiSjXQkNBDH4kxClLD9lV+okWau3XykmJsVs9C2rp7AHNXuoNDGQ5RnM0jl
         77XnyLZgYavjvdeQDnUdXihFQI/vyx3BxuUPlu6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 24/40] ARM: dts: sunxi: bananapi-m2-plus-v1.2: Add regulator supply to all CPU cores
Date:   Sat,  8 Aug 2020 19:38:28 -0400
Message-Id: <20200808233844.3618823-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233844.3618823-1-sashal@kernel.org>
References: <20200808233844.3618823-1-sashal@kernel.org>
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

