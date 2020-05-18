Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FD1D82C4
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbgERR7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731978AbgERR7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9098E207C4;
        Mon, 18 May 2020 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824742;
        bh=HIdU/dYBZXUaeRqyIiknPCJ5RSzo2/DKjXcq7hZa8iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+KW0rvvUAo6AU/i2oIlMpSTpbqC3UBHZWPskPhM56drdiqwOlNl9Xe1FGMJYFLsc
         SOZP9fK2AVW0LMB7Yp+tKr/kcTEBMwEbH1B9Dp8rAzlPsmTEczPq9gbyFuhSXBPIQP
         TFfFekBCjlO3pdI7e1bws9ddbAcfEToamskb8CZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.4 134/147] arm64: dts: meson-g12-common: fix dwc2 clock names
Date:   Mon, 18 May 2020 19:37:37 +0200
Message-Id: <20200518173529.983546972@linuxfoundation.org>
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
@@ -2365,7 +2365,7 @@
 				reg = <0x0 0xff400000 0x0 0x40000>;
 				interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clkc CLKID_USB1_DDR_BRIDGE>;
-				clock-names = "ddr";
+				clock-names = "otg";
 				phys = <&usb2_phy1>;
 				phy-names = "usb2-phy";
 				dr_mode = "peripheral";


