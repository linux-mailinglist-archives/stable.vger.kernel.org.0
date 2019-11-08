Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D79FF47C1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbfKHLwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403834AbfKHLrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4649621D82;
        Fri,  8 Nov 2019 11:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213626;
        bh=DpxXol/N+y1B3DaIv9bxMgSgTTtMjnNY+SmzKS17Jhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+Qt4sb9YAe/2l6y2O8MEK6O6+i2AHOdoYXfs9loEBZIxRHYqosFoJZy0I1ABlLU0
         tOVEjQ684fty7Ud208+/4h/49AfMJ9lChdqYekQPKfCyBiYvypP7TwsZAC64a1lIzc
         AJuY9G6iScdG/g78NH7P4Z73vZoXB4U/GoGEFD8M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 54/64] ARM: dts: socfpga: Fix I2C bus unit-address error
Date:   Fri,  8 Nov 2019 06:45:35 -0500
Message-Id: <20191108114545.15351-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit cbbc488ed85061a765cf370c3e41f383c1e0add6 ]

dtc has new checks for I2C buses. Fix the warnings in unit-addresses.

arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dtb: Warning (i2c_bus_reg): /soc/i2c@ffc04000/adxl345@0: I2C bus unit address format error, expected "53"

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts
index afea3645ada43..89d55894d9162 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts
@@ -88,7 +88,7 @@
 	status = "okay";
 	speed-mode = <0>;
 
-	adxl345: adxl345@0 {
+	adxl345: adxl345@53 {
 		compatible = "adi,adxl345";
 		reg = <0x53>;
 
-- 
2.20.1

