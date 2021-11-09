Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22A544B65E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343767AbhKIW0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343703AbhKIWZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2F6461A3D;
        Tue,  9 Nov 2021 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496361;
        bh=ZqJljDphuKdeHOn5RS+GpUkZPitLaXlIykVrdPvKGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWLVi/Qbh4eturrQWuLOg6rDpoQcvsMvMOQ0NKwlWoNbR/CgTW5g4pSBetfSypV/r
         kvu46S9gSewgxzvSYic1UV3ZviUMQcxNqkAxvQ1+649futW0Bhki6s4nBabOdm5UMh
         jBF6hOpOUuWv4lIL69l6bOTx31ErM0JipKlMViyhhdbLtt9WfEP7S17TBH2KcIw7UF
         U5iHMVRjVYiefpkvhzNYCGK04zMGM3/ZXafpIVczF643b7rcqa56LH6aAeIEeWoIWe
         WMvpQQ6nTjZudk/N1+xnu0FHmCPvJPms5ZCwB0KgSCBcFb1n8GfW5AXcWsEsrQJ5oG
         KaD2+JI31XbsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 06/75] arm64: dts: allwinner: a100: Fix thermal zone node name
Date:   Tue,  9 Nov 2021 17:17:56 -0500
Message-Id: <20211109221905.1234094-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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

