Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8763D2867
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhGVP5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhGVP4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F22D6135A;
        Thu, 22 Jul 2021 16:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971848;
        bh=MvI+frgT/AbbiXzrZnbC3G9PjgHKmRPiSezCUpyFtq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPbDiZbjjw5dhyZXBTppY8+TGLH9Gg3H70tRr10k1RHp3BAOTmbSO5dRBm3hkPWY6
         erW82bLEBmCcyViGMOu+ovl5Xx2IyKz74WKts7sElMIDBbF3c0Q1uTmeevtAzcfACQ
         ISi6Oz+tCTUypjg7rLR4wdCUtrL2AW5QgPODuGp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/125] arm64: dts: juno: Update SCPI nodes as per the YAML schema
Date:   Thu, 22 Jul 2021 18:30:42 +0200
Message-Id: <20210722155626.409601518@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 70010556b158a0fefe43415fb0c58347dcce7da0 ]

The SCPI YAML schema expects standard node names for clocks and
power domain controllers. Fix those as per the schema for Juno
platforms.

Link: https://lore.kernel.org/r/20210608145133.2088631-1-sudeep.holla@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index f6c55877fbd9..2c0161125ece 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -564,13 +564,13 @@
 		clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi-dvfs {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>, <1>, <2>;
 				clock-output-names = "atlclk", "aplclk","gpuclk";
 			};
-			scpi_clk: scpi-clk {
+			scpi_clk: clocks-1 {
 				compatible = "arm,scpi-variable-clocks";
 				#clock-cells = <1>;
 				clock-indices = <3>;
@@ -578,7 +578,7 @@
 			};
 		};
 
-		scpi_devpd: scpi-power-domains {
+		scpi_devpd: power-controller {
 			compatible = "arm,scpi-power-domains";
 			num-domains = <2>;
 			#power-domain-cells = <1>;
-- 
2.30.2



