Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7B2C0889
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgKWMwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387801AbgKWMwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:52:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24A5F20857;
        Mon, 23 Nov 2020 12:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135929;
        bh=c1aqd6n1NXAZ5I3mZnyBrCdg8g00K+y+ueGFAOjfL8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfZnUojvQMDWxlAEJbHHNgaFAQBh4e4MhEoSdC9xSeShaaC/BO4uUAytFYkFftsZM
         Rx43lux8sFTBUY/1GSV/cwIIfDG1TslXEch5fghUGPj2zTz1Mzpt4oBGKv6y8FUN4Z
         wskrKjLe3me+m5ZrpxU6NJMRIkTrgmC8nniuOSiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.9 217/252] arm64: dts: agilex/stratix10: Fix qspi node compatible
Date:   Mon, 23 Nov 2020 13:22:47 +0100
Message-Id: <20201123121846.046516851@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit f126b6702e7354d6247a36f20b9172457af5c15a upstream.

The QSPI flash node needs to have the required "jedec,spi-nor"
in the compatible string.

Fixes: 0cb140d07fc7 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: stable@vger.kernel.org
Suggested-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts      |    2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts |    2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -159,7 +159,7 @@
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00a";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -192,7 +192,7 @@
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00a";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
--- a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
@@ -110,7 +110,7 @@
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mt25qu02g";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 


