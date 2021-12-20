Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9772047ADCB
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbhLTOzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbhLTOxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C28C08E858;
        Mon, 20 Dec 2021 06:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03AEB61185;
        Mon, 20 Dec 2021 14:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D809BC36AE7;
        Mon, 20 Dec 2021 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011655;
        bh=cDtb2os7ZmuG46scrk1iATKDGHuB2kAeJqmEYSXt7N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvDDyWH5YduGDl0knzfz2uBdQN9CsWxOKLm2IoafSylMnHCEWfClmEOFc2pu6AGYH
         6Yl2glLTQ8/mzGgmnYmyWPFFbzW3REdLvf/wwmPt+SMhx9Em5H7ENGhyY5UVZg95F9
         Wh30y2fPZhDJ28qz2MfK7X1oNc5gvZ42RQg4lwg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/99] ARM: socfpga: dts: fix qspi node compatible
Date:   Mon, 20 Dec 2021 15:34:00 +0100
Message-Id: <20211220143030.261613850@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index 2b645642b9352..2a745522404d6 100644
--- a/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts
+++ b/arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts
@@ -12,7 +12,7 @@ &qspi {
 	flash0: n25q00@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00aa";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_arria5_socdk.dts b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
index 90e676e7019f2..1b02d46496a85 100644
--- a/arch/arm/boot/dts/socfpga_arria5_socdk.dts
+++ b/arch/arm/boot/dts/socfpga_arria5_socdk.dts
@@ -119,7 +119,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q256a";
+		compatible = "micron,n25q256a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
index 6f138b2b26163..51bb436784e24 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_socdk.dts
@@ -124,7 +124,7 @@ &qspi {
 	flash0: n25q00@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;	/* chip select */
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
index c155ff02eb6e0..cae9ddd5ed38b 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
@@ -169,7 +169,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts b/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
index 8d5d3996f6f27..ca18b959e6559 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_socrates.dts
@@ -80,7 +80,7 @@ &qspi {
 	flash: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q256a";
+		compatible = "micron,n25q256a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 		m25p,fast-read;
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts b/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
index 99a71757cdf46..3f7aa7bf0863a 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_sodia.dts
@@ -116,7 +116,7 @@ &qspi {
 	flash0: n25q512a@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q512a";
+		compatible = "micron,n25q512a", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts b/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
index a060718758b67..25874e1b9c829 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts
@@ -224,7 +224,7 @@ &qspi {
 	n25q128@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q128";
+		compatible = "micron,n25q128", "jedec,spi-nor";
 		reg = <0>;		/* chip select */
 		spi-max-frequency = <100000000>;
 		m25p,fast-read;
@@ -241,7 +241,7 @@ n25q128@0 {
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



