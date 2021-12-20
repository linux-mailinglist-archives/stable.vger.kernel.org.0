Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D628747ABE3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhLTOjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhLTOjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:39:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A784BC06173E;
        Mon, 20 Dec 2021 06:39:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F907B80EDA;
        Mon, 20 Dec 2021 14:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9776AC36AEF;
        Mon, 20 Dec 2021 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011140;
        bh=s+ZTTrOyBiCGxMYKfKPGATDff3IYZGKAvbx6TGggD14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unztakgb31IzZOHp/Ep8Tg3jAUUgXs7a3v/Pfrsx1JRLwH+M3l6SJBDw9T2EKvlXL
         wxHI4bEvaUKEEs/Z75uzYxi5J0t9h5fQo+r6XfNS8vhiQLngP1dMQcJoHMh25+QVX0
         KSzRTxsbn6urHvQbd5jv5EGL86vV4f261aT1f9Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/45] ARM: socfpga: dts: fix qspi node compatible
Date:   Mon, 20 Dec 2021 15:34:13 +0100
Message-Id: <20211220143022.881305059@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit cb25b11943cbcc5a34531129952870420f8be858 ]

The QSPI flash node needs to have the required "jedec,spi-nor" in the
compatible string.

Fixes: 1df99da8953 ("ARM: dts: socfpga: Enable QSPI in Arria10 devkit")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   | 2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         | 2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       | 2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      | 2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    | 2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       | 2 +-
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts b/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts
index beb2fc6b9eb63..adfdc43ac052f 100644
--- a/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts
+++ b/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts
@@ -23,7 +23,7 @@ &qspi {
 	flash0: n25q00@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00aa";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_arria5_socdk.dts b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
index aac4feea86f38..09ffa79240c84 100644
--- a/arch/arm/boot/dts/socfpga_arria5_socdk.dts
+++ b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
@@ -131,7 +131,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q256a";
+		compatible = "micron,n25q256a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
index 155829f9eba16..907d8aa6d9fc8 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
@@ -136,7 +136,7 @@ &qspi {
 	flash0: n25q00@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;	/* chip select */
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
index a4a555c19d943..fe5fe4559969d 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
@@ -181,7 +181,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts b/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
index 53bf99eef66de..0992cae3e60ef 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
@@ -87,7 +87,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q256a";
+		compatible = "micron,n25q256a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 		m25p,fast-read;
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts b/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
index 8860dd2e242c4..22bfef024913a 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
@@ -128,7 +128,7 @@ &qspi {
         flash0: n25q512a@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q512a";
+		compatible = "micron,n25q512a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts b/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
index 655fe87e272d9..349719a9c1360 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
@@ -249,7 +249,7 @@ &qspi {
 	n25q128@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q128";
+		compatible = "micron,n25q128", "jedec,spi-nor";
 		reg = <0>;		/* chip select */
 		spi-max-frequency = <100000000>;
 		m25p,fast-read;
@@ -266,7 +266,7 @@ n25q128@0 {
 	n25q00@1 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <1>;		/* chip select */
 		spi-max-frequency = <100000000>;
 		m25p,fast-read;
-- 
2.33.0



