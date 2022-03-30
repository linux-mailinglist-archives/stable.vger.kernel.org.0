Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E1F4EC215
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345142AbiC3L6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345933AbiC3LzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33D02CE04;
        Wed, 30 Mar 2022 04:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3786137A;
        Wed, 30 Mar 2022 11:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9871EC36AE2;
        Wed, 30 Mar 2022 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641172;
        bh=tZLkmdGLd3BRCcgyFFRiPY+tkNgl+dRTZ9QJcTbaIMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt54OQVpfNCE0dSn2EvQECYsre+Oo7zYo9IcklSc9vOJDE8pVXR/xxO50/vutdtiU
         c4Y8Uo69f/+e+Dn3RKyTbsS9dVFro1Gl7IFidJ21oXAHqwMaegYed4p5hZpdoMpbsl
         Ktv6qG1LpKpXTLJDDs9NFQKliiGTvmlBM1Mwr8dno5qJjgWD7Su3K3+tr4Xuv4OaiV
         sfBwABf2LjpjehUNVGs0Uhm0Ur6sDl8x2/IWmNXiJDj3FPOHjkTVQms6EXyFa/VgsP
         NZohrIH9Dh5ApFJ+FRfrl5DiB+GlHypPIyjAKy/zIvl/9v/p6ckyOC+6nhDodx3Xeh
         mkaWCF+kP0IKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Leitner <richard.leitner@skidata.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/25] ARM: tegra: tamonten: Fix I2C3 pad setting
Date:   Wed, 30 Mar 2022 07:52:17 -0400
Message-Id: <20220330115225.1672278-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115225.1672278-1-sashal@kernel.org>
References: <20220330115225.1672278-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Leitner <richard.leitner@skidata.com>

[ Upstream commit 0092c25b541a5422d7e71892a13c55ee91abc34b ]

This patch fixes the tristate configuration for i2c3 function assigned
to the dtf pins on the Tamonten Tegra20 SoM.

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 394a6b4dc69d..69cb65d86c46 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -183,8 +183,8 @@
 			};
 			conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
-					"cdev1", "cdev2", "dap1", "dtb", "gma",
-					"gmb", "gmc", "gmd", "gme", "gpu7",
+					"cdev1", "cdev2", "dap1", "dtb", "dtf",
+					"gma", "gmb", "gmc", "gmd", "gme", "gpu7",
 					"gpv", "i2cp", "irrx", "irtx", "pta",
 					"rm", "slxa", "slxk", "spia", "spib",
 					"uac";
@@ -203,7 +203,7 @@
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap2", "dap3", "dap4",
-					"dtc", "dte", "dtf", "gpu", "sdio1",
+					"dtc", "dte", "gpu", "sdio1",
 					"slxc", "slxd", "spdi", "spdo", "spig",
 					"uda";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-- 
2.34.1

