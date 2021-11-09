Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFCD44B75C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344974AbhKIWeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344399AbhKIWcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A4561A82;
        Tue,  9 Nov 2021 22:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496474;
        bh=ZqJljDphuKdeHOn5RS+GpUkZPitLaXlIykVrdPvKGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhB7qDzhgNC+veAOPmIdKaM9XChP0cCuXc2rb0oM8wwzV+GRMu3ODlAXYa95tki92
         11yr/IR6eD7CUbmSR18KOMesOqnTUkhm9367cRp+RKu62AA6Ot42UVXr9Gi+ZYoAjc
         OS+R0+37D8UZdtBAoyHeEJKEH852Yn77hsOeq8Tpsm3XHlilFdqV5otr324jv3fNE4
         a4mI6AepWPtG2HKP6XaGaTocA7FrGQek6UVhDy7gZU1bc2d4qkkEcFkOvGoQwzTa8O
         0TY5pTeB5l9bY8hN4M0s11rTjd+SLBQ+2QE3pQLIdBTnFS2MOt21jhbJpoMpRY3bGX
         PNI/iNRFnncVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 05/50] arm64: dts: allwinner: a100: Fix thermal zone node name
Date:   Tue,  9 Nov 2021 17:20:18 -0500
Message-Id: <20211109222103.1234885-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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

