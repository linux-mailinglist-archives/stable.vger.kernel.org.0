Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F391D841D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgERSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732645AbgERSGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C02C20826;
        Mon, 18 May 2020 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825211;
        bh=1ZYtHKLOGLailgr19+33CoAv8a7qF/mC5bD07GcSEzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtvH42y8Qq4u5l9gzdfFPnZcrk574Z/MmTm2oQuql3MFrs1j0ttth0AYMzGPwtq1F
         Wk7/B7mPRMdU2d1WaKcnmsQv78lkYAAbj3R1pxOX/R0L3IrVBJW20t0LmzIHKlIWXm
         ZbEAH314BW23oLZrFpZ3sQRw3YAqPGe/xCQYOlmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.6 175/194] arm64: dts: meson-g12-common: fix dwc2 clock names
Date:   Mon, 18 May 2020 19:37:45 +0200
Message-Id: <20200518173546.178617308@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit e4f634d812634067b0c661af2e3cecfd629c89b8 upstream.

Use the correct dwc2 clock name.

Fixes: 9baf7d6be730 ("arm64: dts: meson: g12a: Add G12A USB nodes")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20200326160857.11929-3-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2204,7 +2204,7 @@
 				reg = <0x0 0xff400000 0x0 0x40000>;
 				interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clkc CLKID_USB1_DDR_BRIDGE>;
-				clock-names = "ddr";
+				clock-names = "otg";
 				phys = <&usb2_phy1>;
 				phy-names = "usb2-phy";
 				dr_mode = "peripheral";


