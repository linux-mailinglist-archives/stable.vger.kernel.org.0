Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044603C90C8
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhGNT4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239515AbhGNTvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA90061428;
        Wed, 14 Jul 2021 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292104;
        bh=cL8ZXwvokfC8Q3dUiML878u+/5z5rUIfgVO1Ci/jmJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g15EOy9HYVgqyBqeJaOJFfW1D59C7iW7o281lclenuFvhYx5bmDwJ/+uZGfsFkmx2
         PMCmjrayz4sGr6t8S22Lsi9C/0iRF8MetOqqKW1RgT4tXJtMaQ2BxuftIDB6lbaxhG
         pEKzxmPEJE+sNc7RpimKPq0bDmWUlkxZssU9T/HrGIwi3nd61tl93s6t+2fzRlELyD
         9ADjEefQ+k6bw99VS3KyjMPvqVctdXsqOg9sV+hiOVUOyuuUyHf8FersYRJXmT0to2
         8yEKRrDRRlurMLgS3XjpyqzyGmYvAoypRCpdMh1n8rSqQl42BsRzr30RNSbwVcM3v9
         L2koSqYre8ZKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/18] arm64: dts: juno: Update SCPI nodes as per the YAML schema
Date:   Wed, 14 Jul 2021 15:48:00 -0400
Message-Id: <20210714194806.55962-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194806.55962-1-sashal@kernel.org>
References: <20210714194806.55962-1-sashal@kernel.org>
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
index 7d3a2acc6a55..2aa01eaa0cd1 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -414,13 +414,13 @@ scpi {
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
@@ -428,7 +428,7 @@ scpi_clk: scpi-clk {
 			};
 		};
 
-		scpi_devpd: scpi-power-domains {
+		scpi_devpd: power-controller {
 			compatible = "arm,scpi-power-domains";
 			num-domains = <2>;
 			#power-domain-cells = <1>;
-- 
2.30.2

