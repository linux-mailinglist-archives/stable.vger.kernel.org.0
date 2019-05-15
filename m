Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5911F186
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfEOLSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbfEOLSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A45620818;
        Wed, 15 May 2019 11:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919121;
        bh=9is9nqZeD4WUizEnt4ssE7XJ5OiO1YvZpHT12Dv/2nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFu79zzM8O0YiY865RawDF7XQyWnagdvfsa5ETvThP0najnuoxeKDyzgtv/Mt2/wq
         R3iWDu8azPmLN+yFZB1Ndq3sGDPWa7H2xMXjO5t7RktICGJTzLDOmzREPevOwizae2
         Wo2t6SL4wOntb8pNhEN0Hf63k85OW5iNnHOyVASo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 075/115] xtensa: xtfpga.dtsi: fix dtc warnings about SPI
Date:   Wed, 15 May 2019 12:55:55 +0200
Message-Id: <20190515090704.861398517@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f37598be4e3896359e87c824be57ddddc280cc3f ]

Rename SPI controller node in the XTFPGA DTS to spi@...
This fixes the following build warnings:

arch/xtensa/boot/dts/kc705_nommu.dtb: Warning (spi_bus_bridge):
 /soc/spi-master@0d0a0000: node name for SPI buses should be 'spi'
arch/xtensa/boot/dts/kc705_nommu.dtb: Warning (spi_bus_reg):
 Failed prerequisite 'spi_bus_bridge'
arch/xtensa/boot/dts/lx200mx.dtb: Warning (spi_bus_bridge):
 /soc/spi-master@0d0a0000: node name for SPI buses should be 'spi'
arch/xtensa/boot/dts/lx200mx.dtb: Warning (spi_bus_reg):
 Failed prerequisite 'spi_bus_bridge'
arch/xtensa/boot/dts/kc705.dtb: Warning (spi_bus_bridge):
 /soc/spi-master@0d0a0000: node name for SPI buses should be 'spi'
arch/xtensa/boot/dts/kc705.dtb: Warning (spi_bus_reg):
 Failed prerequisite 'spi_bus_bridge'
arch/xtensa/boot/dts/ml605.dtb: Warning (spi_bus_bridge):
 /soc/spi-master@0d0a0000: node name for SPI buses should be 'spi'
arch/xtensa/boot/dts/ml605.dtb: Warning (spi_bus_reg):
 Failed prerequisite 'spi_bus_bridge'
arch/xtensa/boot/dts/lx60.dtb: Warning (spi_bus_bridge):
 /soc/spi-master@0d0a0000: node name for SPI buses should be 'spi'
arch/xtensa/boot/dts/lx60.dtb: Warning (spi_bus_reg):
 Failed prerequisite 'spi_bus_bridge'

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/xtensa/boot/dts/xtfpga.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/boot/dts/xtfpga.dtsi b/arch/xtensa/boot/dts/xtfpga.dtsi
index 1090528825ec6..e46ae07bab059 100644
--- a/arch/xtensa/boot/dts/xtfpga.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga.dtsi
@@ -103,7 +103,7 @@
 			};
 		};
 
-		spi0: spi-master@0d0a0000 {
+		spi0: spi@0d0a0000 {
 			compatible = "cdns,xtfpga-spi";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.20.1



