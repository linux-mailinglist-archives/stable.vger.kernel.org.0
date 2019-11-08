Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023FFF4862
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbfKHLpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391125AbfKHLpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C7D222C2;
        Fri,  8 Nov 2019 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213531;
        bh=ZeDtjHcS4F7h4sPEOoNT2gxFQHsLvg4xtMYXjgeG0y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZKCfnES2s4CYPqII3Fizsg27YmflcYy1KaTDpCOxFyNDGpNbIBqa6gTBNvbl1hnj
         ugxGzKECGot2KyC1iX0ORGrfEA1i8CrqZNaPWfuPqCavHocLyiS8sVJpTTKBhpZhz1
         GSGeN/+D36kdCvTGGTGY54ty55T/q8hAyu+dYo58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        linux-amlogic@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 094/103] arm64: dts: meson: Fix erroneous SPI bus warnings
Date:   Fri,  8 Nov 2019 06:42:59 -0500
Message-Id: <20191108114310.14363-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 68ecb5c1920c5b98b1e717fd2349fba2ee5d4031 ]

dtc has new checks for SPI buses. The meson dts files have a node named
spi' which causes false positive warnings. As the node is a pinctrl child
node, change the node name to be 'spi-pins' to fix the warnings.

arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb: Warning (spi_bus_bridge): /soc/periphs@c8834000/pinctrl@4b0/spi: incorrect #address-cells for SPI bus

Cc: Carlo Caione <carlo@caione.org>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: linux-amlogic@lists.infradead.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index af834cdbba791..250b5c11c0e25 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -413,7 +413,7 @@
 			};
 		};
 
-		spi_pins: spi {
+		spi_pins: spi-pins {
 			mux {
 				groups = "spi_miso",
 					"spi_mosi",
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index fb8d76a17bc5d..3c30579449608 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -310,7 +310,7 @@
 			};
 		};
 
-		spi_pins: spi {
+		spi_pins: spi-pins {
 			mux {
 				groups = "spi_miso",
 					"spi_mosi",
-- 
2.20.1

