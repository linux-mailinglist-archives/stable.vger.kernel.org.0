Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AEF1D871E
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgERSaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbgERRlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196D920657;
        Mon, 18 May 2020 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823672;
        bh=RfkX7dMrDN71LREFdUGr1HWXv6KFGxNUxXuzOej2pdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syjtT1JeLuhp0njdGEFQ6IZGYVbOdRswrxKiDCOBvw47bAUqmy+qYdz0AgR9Wb1cj
         yyxHZjzXFAYOEEJ4kqbDkehjPgy7c2bM227jrl5nHGjrCQnTchuf7SoDeoLb9FieIq
         yXXHLOtRwFO1D99/DWoJfJD5DTgqXbttIH2WkX7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.4 76/86] ARM: dts: imx27-phytec-phycard-s-rdk: Fix the I2C1 pinctrl entries
Date:   Mon, 18 May 2020 19:36:47 +0200
Message-Id: <20200518173505.951987286@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 0caf34350a25907515d929a9c77b9b206aac6d1e upstream.

The I2C2 pins are already used and the following errors are seen:

imx27-pinctrl 10015000.iomuxc: pin MX27_PAD_I2C2_SDA already requested by 10012000.i2c; cannot claim for 1001d000.i2c
imx27-pinctrl 10015000.iomuxc: pin-69 (1001d000.i2c) status -22
imx27-pinctrl 10015000.iomuxc: could not request pin 69 (MX27_PAD_I2C2_SDA) from group i2c2grp  on device 10015000.iomuxc
imx-i2c 1001d000.i2c: Error applying setting, reverse things back
imx-i2c: probe of 1001d000.i2c failed with error -22

Fix it by adding the correct I2C1 IOMUX entries for the pinctrl_i2c1 group.

Cc: <stable@vger.kernel.org>
Fixes: 61664d0b432a ("ARM: dts: imx27 phyCARD-S pinctrl")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Stefan Riedmueller <s.riedmueller@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
@@ -81,8 +81,8 @@
 	imx27-phycard-s-rdk {
 		pinctrl_i2c1: i2c1grp {
 			fsl,pins = <
-				MX27_PAD_I2C2_SDA__I2C2_SDA 0x0
-				MX27_PAD_I2C2_SCL__I2C2_SCL 0x0
+				MX27_PAD_I2C_DATA__I2C_DATA 0x0
+				MX27_PAD_I2C_CLK__I2C_CLK 0x0
 			>;
 		};
 


