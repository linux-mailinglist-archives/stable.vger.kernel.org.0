Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9186101852
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfKSFdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbfKSFdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D6C21783;
        Tue, 19 Nov 2019 05:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141583;
        bh=ZcfI9Io9gL+K+leh9xNl/+x3gDLhi0YCH+sL9MOr5HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+G1FccHWR3FPiUx+Oyxyyov+8wsfzSMsvQPy4wXM+rTSy3aTnaxAVxAlRLuD5sn2
         Ul7Vu5NsPvzp8zqM+aNrU0bf7qXhDrMgfWdDi+EqzkRo2vqY9R3yH6OmYY7b2uwyoq
         Gmse9rHsjgOjWOIqhEpXApCd8JsMHaxkbRNjJrmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 210/422] ARM: dts: bcm: Fix SPI bus warnings
Date:   Tue, 19 Nov 2019 06:16:47 +0100
Message-Id: <20191119051412.201481107@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit ab0b47d2eff413d60b0a1fc0c1f87f87f0d7f375 ]

dtc has new checks for SPI buses. Fix the warnings in node names.

arch/arm/boot/dts/bcm53340-ubnt-unifi-switch8.dtb: Warning (spi_bus_bridge): /axi@18000000/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958525er.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958525xmc.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958622hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958625hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm988312hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'

Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Jon Mason <jonmason@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-hr2.dtsi | 2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-hr2.dtsi b/arch/arm/boot/dts/bcm-hr2.dtsi
index 3084a7c957339..e4d49731287f6 100644
--- a/arch/arm/boot/dts/bcm-hr2.dtsi
+++ b/arch/arm/boot/dts/bcm-hr2.dtsi
@@ -216,7 +216,7 @@
 			reg = <0x33000 0x14>;
 		};
 
-		qspi: qspi@27200 {
+		qspi: spi@27200 {
 			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 09ba850463228..2b219addeb449 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -273,7 +273,7 @@
 			brcm,nand-has-wp;
 		};
 
-		qspi: qspi@27200 {
+		qspi: spi@27200 {
 			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
-- 
2.20.1



