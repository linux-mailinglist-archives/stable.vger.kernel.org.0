Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB463C9060
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbhGNTyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241145AbhGNTuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A2A613E9;
        Wed, 14 Jul 2021 19:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292023;
        bh=9r5iEzYEYnXK8OGOE8AOXS1ekpwFNfiCQVYiQKnr2AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqjIbwvSFvsCR9y1mv/mt+MvaSzjJWWnAj5BkzbaTgu2PtC1m7tcF51pMiH/GsdV2
         wCaaUVj3rX0DleWQGkgj8XaZcttM8yCAdgW7sD3cwZJ1C7W/AcSm7LhrX3CULxN8HF
         1GRO3zIi9ShSmZNZ9pOf/yHjs3rOT830UnsG69C7k6A1RP2UKa+MN9Le1d3HI6ZRKE
         HLWYUmd17tfRIttbmaou8WUll6Pdbh2TN3XK8JCZWbQ75u8H+VAojC+riaGUYAmtY/
         L/jz6crlOMPzHU63BrdlQac5BNRwVYR4f2w+YSlotigcbsa7c+SpiA6DOyW1yUD2mj
         bcbJcU5czZiIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/39] arm64: dts: juno: Update SCPI nodes as per the YAML schema
Date:   Wed, 14 Jul 2021 15:46:11 -0400
Message-Id: <20210714194625.55303-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b6f486737589..331862504dc3 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -533,13 +533,13 @@ scpi {
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
@@ -547,7 +547,7 @@ scpi_clk: scpi-clk {
 			};
 		};
 
-		scpi_devpd: scpi-power-domains {
+		scpi_devpd: power-controller {
 			compatible = "arm,scpi-power-domains";
 			num-domains = <2>;
 			#power-domain-cells = <1>;
-- 
2.30.2

