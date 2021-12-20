Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ACB47ACB9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhLTOqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbhLTOno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:43:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E54E611A1;
        Mon, 20 Dec 2021 14:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04360C36AEA;
        Mon, 20 Dec 2021 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011423;
        bh=MUH4uSvx6x5CiYVFKVkIJr1gc22kiF4irDGPplKLsBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/jBkYLO7H5li2E7myU/O6IiUcMa4PI+I4xahV8LGVHZJsisWAUNFd9gmYNqWMtXU
         yBxsXk3MqoFIRWuM+G8I4WXVUJtUf4dQKxMMlTtJAUv6PpOicIwDh8mJIFUxHPjmNQ
         eS5fP7r3PE8izZmDeaKYoyTKTux7yshzDZjwiy/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/71] ARM: socfpga: dts: fix qspi node compatible
Date:   Mon, 20 Dec 2021 15:34:05 +0100
Message-Id: <20211220143026.231646956@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index b4c0a76a4d1af..4c2fcfcc7baed 100644
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



