Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5740C1D84CE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbgERR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731999AbgERR7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C69207D3;
        Mon, 18 May 2020 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824747;
        bh=YSPe1livLa9ajmbYeUYS17498NRPX2FUCt/YUQrxklU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRs8gL0luwJ+25rqlne7E9dlVYqdU3lpQguca0gh7E2Ct2XDgxd8+QZjzG6xbPF/f
         V9mcJFXXoRuoWPgKyra1hmm6RCfhqeqC/a4SmtXOR3/Jz683CWdLugas2vcIjmMKtk
         IfLCNIWE4ZeyMwtsXMWY4qX0SAA30cle+Qz7HowQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.4 136/147] arm64: dts: rockchip: Rename dwc3 device nodes on rk3399 to make dtc happy
Date:   Mon, 18 May 2020 19:37:39 +0200
Message-Id: <20200518173530.153616983@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit 190c7f6fd43a776d4a6da1dac44408104649e9b7 upstream.

The device tree compiler complains that the dwc3 nodes have regs
properties but no matching unit addresses.

Add the unit addresses to the device node name. While at it, also rename
the nodes from "dwc3" to "usb", as guidelines require device nodes have
generic names.

Fixes: 7144224f2c2b ("arm64: dts: rockchip: support dwc3 USB for rk3399")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20200327030414.5903-7-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -410,7 +410,7 @@
 		reset-names = "usb3-otg";
 		status = "disabled";
 
-		usbdrd_dwc3_0: dwc3 {
+		usbdrd_dwc3_0: usb@fe800000 {
 			compatible = "snps,dwc3";
 			reg = <0x0 0xfe800000 0x0 0x100000>;
 			interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH 0>;
@@ -446,7 +446,7 @@
 		reset-names = "usb3-otg";
 		status = "disabled";
 
-		usbdrd_dwc3_1: dwc3 {
+		usbdrd_dwc3_1: usb@fe900000 {
 			compatible = "snps,dwc3";
 			reg = <0x0 0xfe900000 0x0 0x100000>;
 			interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH 0>;


