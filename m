Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70E13E0A4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAPQor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbgAPQoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:44:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B39207FF;
        Thu, 16 Jan 2020 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193085;
        bh=ATnt4RrCVTVumt37ZTlIcy17h2FQk88wKOYRK100tSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zZvcMy5IPWowg1RgBrPUpCQX42tDMydz8YW/AJdR0tlWj5yYXn6u4oqDyG9/NVrIi
         9ilRMYjKG1QKc1lzwOq7Rl9MBoW6xzXG4F72YoNqQ/BehUTo4gkc7Lg8Us1fTHgQiy
         /kMIfC6lFBq3re7HpwNr9egTh+s1+HNN+4oz2Fb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 021/205] arm64: dts: meson: g12: fix audio fifo reg size
Date:   Thu, 16 Jan 2020 11:39:56 -0500
Message-Id: <20200116164300.6705-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 22c4b148a0a1085e57a470e6f7dc515cf08f5a5c ]

The register region size initially is too small to access all
the fifo registers.

Fixes: c59b7fe5aafd ("arm64: dts: meson: g12a: add audio fifos")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 3f39e020f74e..0ee8a369c547 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1509,7 +1509,7 @@
 				toddr_a: audio-controller@100 {
 					compatible = "amlogic,g12a-toddr",
 						     "amlogic,axg-toddr";
-					reg = <0x0 0x100 0x0 0x1c>;
+					reg = <0x0 0x100 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "TODDR_A";
 					interrupts = <GIC_SPI 148 IRQ_TYPE_EDGE_RISING>;
@@ -1521,7 +1521,7 @@
 				toddr_b: audio-controller@140 {
 					compatible = "amlogic,g12a-toddr",
 						     "amlogic,axg-toddr";
-					reg = <0x0 0x140 0x0 0x1c>;
+					reg = <0x0 0x140 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "TODDR_B";
 					interrupts = <GIC_SPI 149 IRQ_TYPE_EDGE_RISING>;
@@ -1533,7 +1533,7 @@
 				toddr_c: audio-controller@180 {
 					compatible = "amlogic,g12a-toddr",
 						     "amlogic,axg-toddr";
-					reg = <0x0 0x180 0x0 0x1c>;
+					reg = <0x0 0x180 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "TODDR_C";
 					interrupts = <GIC_SPI 150 IRQ_TYPE_EDGE_RISING>;
@@ -1545,7 +1545,7 @@
 				frddr_a: audio-controller@1c0 {
 					compatible = "amlogic,g12a-frddr",
 						     "amlogic,axg-frddr";
-					reg = <0x0 0x1c0 0x0 0x1c>;
+					reg = <0x0 0x1c0 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "FRDDR_A";
 					interrupts = <GIC_SPI 152 IRQ_TYPE_EDGE_RISING>;
@@ -1557,7 +1557,7 @@
 				frddr_b: audio-controller@200 {
 					compatible = "amlogic,g12a-frddr",
 						     "amlogic,axg-frddr";
-					reg = <0x0 0x200 0x0 0x1c>;
+					reg = <0x0 0x200 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "FRDDR_B";
 					interrupts = <GIC_SPI 153 IRQ_TYPE_EDGE_RISING>;
@@ -1569,7 +1569,7 @@
 				frddr_c: audio-controller@240 {
 					compatible = "amlogic,g12a-frddr",
 						     "amlogic,axg-frddr";
-					reg = <0x0 0x240 0x0 0x1c>;
+					reg = <0x0 0x240 0x0 0x2c>;
 					#sound-dai-cells = <0>;
 					sound-name-prefix = "FRDDR_C";
 					interrupts = <GIC_SPI 154 IRQ_TYPE_EDGE_RISING>;
-- 
2.20.1

