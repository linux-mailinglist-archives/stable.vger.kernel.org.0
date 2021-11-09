Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB29444B552
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245488AbhKIWUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245356AbhKIWTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C83261251;
        Tue,  9 Nov 2021 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496222;
        bh=ZqJljDphuKdeHOn5RS+GpUkZPitLaXlIykVrdPvKGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQBZ/Nd3bZwrZX7q7/7zhNAgCPJYuFoPB5NitoUd/SX7JCbY7OATiquChxAtBimBj
         HFcat8h4nxFy7NHnix5scOUCVYxcoYQCLaK/PFtak7sMdGDbiTatPTdZjNeAY1d0CU
         5i+efDZJPEAax49KTTZG7JYizZl43jOTh2sCiy0FapwroDvgreC9e0NY91nq76aFjH
         bp6MFFzPZtFq6HyfccBZ/hputfkCo2eQgCAgFe2X9t07bDL1CdZSnw6nsSxEAqlhzA
         AsMpDjGPQT+jOtd9nDskoMCxAWkFHzWC7v0tCFFDcsLGCTG+gJwCI6sfUjaNwkxJGa
         ZIhtivHdJwyCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 06/82] arm64: dts: allwinner: a100: Fix thermal zone node name
Date:   Tue,  9 Nov 2021 17:15:24 -0500
Message-Id: <20211109221641.1233217-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 5c34c4e46e601554bfa370b23c8ae3c3c734e9f7 ]

The thermal zones one the A100 are called $device-thermal-zone.

However, the thermal zone binding explicitly requires that zones are
called *-thermal. Let's fix it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20210901091852.479202-50-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
index cc321c04f1219..f6d7d7f7fdabe 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
@@ -343,19 +343,19 @@
 	};
 
 	thermal-zones {
-		cpu-thermal-zone {
+		cpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 0>;
 		};
 
-		ddr-thermal-zone {
+		ddr-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 2>;
 		};
 
-		gpu-thermal-zone {
+		gpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 1>;
-- 
2.33.0

