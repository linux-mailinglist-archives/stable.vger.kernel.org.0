Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0455D45C2D1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348761AbhKXNcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348658AbhKXNap (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E74E061BC2;
        Wed, 24 Nov 2021 12:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758341;
        bh=ZqJljDphuKdeHOn5RS+GpUkZPitLaXlIykVrdPvKGsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAR2AS8rT1CX+Hdm7nwujWFuK55IclYxYcFmxcUMw8FFgpk/NopFfvKruP+Oxmtm5
         TUhHjWg6hcBbiMul13WoB6Pj27cK9Gp3Ql2ir28bQYgBTVg8XPrp9oLlW0C+BLe1Nt
         dfKREAdGnha8AUoxdKDQhcOxD/4D7ncGthRK9QVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/154] arm64: dts: allwinner: a100: Fix thermal zone node name
Date:   Wed, 24 Nov 2021 12:56:41 +0100
Message-Id: <20211124115702.539550607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



