Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74110184E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfKSFdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbfKSFdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B856721783;
        Tue, 19 Nov 2019 05:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141595;
        bh=nrwlX0+o3IBQvyjj/20EPhRXPTRgqzdCYKUR/stkalw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUm9uAb/c2QTxgvn7rZCbfCM+kdstkCV15GA5g2P17le9g6OJKn9YoicoecDSCueu
         EB8MJWDyhZppfZN1Ss1CojGN5qV7Ckj0vTGD1OcFmqTaX9/ySITYmp39lpYeSQV/jk
         WsXuCRJs4wWRbtMV3I65RZL63I6FatZKcsEpn01E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/422] ARM: dts: socfpga: Fix I2C bus unit-address error
Date:   Tue, 19 Nov 2019 06:16:50 +0100
Message-Id: <20191119051412.397749832@linuxfoundation.org>
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
index b280e64941938..31b01a998b2ed 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts
+++ b/arch/arm/boot/dts/socfpga_cyclone5_de0_sockit.dts
@@ -88,7 +88,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 
-	adxl345: adxl345@0 {
+	adxl345: adxl345@53 {
 		compatible = "adi,adxl345";
 		reg = <0x53>;
 
-- 
2.20.1



