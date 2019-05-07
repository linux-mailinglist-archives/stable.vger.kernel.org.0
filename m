Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB715ACB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfEGFsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfEGFkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A59B42087F;
        Tue,  7 May 2019 05:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207640;
        bh=V0Bzwzhga6ZuygMd0DR5+U69a8sqREB1MyEM7/MSUCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lsp3QM6did6cVGul66y5brNO6EBs/yJo22HtIyYnWnxZKI+jyZ0Bh2VYhTuzc7vgg
         dZiKyi+B26bWQJcdttURXUYU3WOJLAi/2F+OgbIt0vSepQnvwMyH8qOsoV3IcyY68b
         GyxO+pTflkHv15AhK0B+40brjddTxMgjel+eHnxk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        devicetree@vger.kernel.org, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.14 73/95] xtensa: xtfpga.dtsi: fix dtc warnings about SPI
Date:   Tue,  7 May 2019 01:38:02 -0400
Message-Id: <20190507053826.31622-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

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
index 1090528825ec..e46ae07bab05 100644
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

