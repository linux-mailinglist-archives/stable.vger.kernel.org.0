Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFA3C8F73
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhGNTwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239853AbhGNTt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E73613DB;
        Wed, 14 Jul 2021 19:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291871;
        bh=UlPQTFrovZmMmtC75o7ux5KIL2EJw+XTxxB/ugWFKjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSXNT34vJjv2nWnjcrG/moYRaQoAvrqbyTYgotBjG0WMJcy+EYZ0DtIb023kjMAi/
         2P5UW64ijL6fAG/pevKZb5PgV7rEgN/CrdGQKXx+HX0qRDvltMw6wYSQfvNQ7WXO5J
         lRuxrlxCdlwoxC7VHkbbOZJE9w9Zb7F0OxWUC8phBQT080boNn6Mr56Y+S72KczoGk
         wl/ZU6FnresWVkXQMkO0/BVL9uB3I0HCfhRJwA+hEr9Nh1z+NBIegcLzmzJr1gWEs8
         sFG2XXMsavAOg4H9nv5E6En99nXc9aWXVDg+6sQeDaMwml+rECqYf5g3CA5JVrCagg
         k5bcsvMvVaFYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 58/88] arm64: dts: juno: Update SCPI nodes as per the YAML schema
Date:   Wed, 14 Jul 2021 15:42:33 -0400
Message-Id: <20210714194303.54028-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index f6c55877fbd9..2c0161125ece 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -564,13 +564,13 @@ scpi {
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
@@ -578,7 +578,7 @@ scpi_clk: scpi-clk {
 			};
 		};
 
-		scpi_devpd: scpi-power-domains {
+		scpi_devpd: power-controller {
 			compatible = "arm,scpi-power-domains";
 			num-domains = <2>;
 			#power-domain-cells = <1>;
-- 
2.30.2

