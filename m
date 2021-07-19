Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D443CE28E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbhGSPaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348000AbhGSPYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6765B61248;
        Mon, 19 Jul 2021 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710429;
        bh=nBuEjXP7MDnryNt1YS+NImG5NqXM1GptOt3LZMjOBnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+kYVdhwB644aD8s3KhW2y6eXbsxTaR05iwvcYgO+PKSiNLCX/UAhsAwW1YaxPVcK
         M00/CyG/qVe1ehtx6jrcFKQWFic73UzDFp3PVHWAKOauz1J5vMHXIdXS7s+Npg7G+W
         4kEqMCPr+ZDIXT5KSu197GLzj45PpG5vO8DNkeDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/243] dt-bindings: i2c: at91: fix example for scl-gpios
Date:   Mon, 19 Jul 2021 16:54:00 +0200
Message-Id: <20210719144947.740521263@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 92e669017ff1616ba7d8ba3c65f5193bc2a7acbe ]

The SCL gpio pin used by I2C bus for recovery needs to be configured as
open drain, so fix the binding example accordingly.
In relation with fix c5a283802573 ("ARM: dts: at91: Configure I2C SCL
gpio as open drain").

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Fixes: 19e5cef058a0 ("dt-bindings: i2c: at91: document optional bus recovery properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/i2c/i2c-at91.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-at91.txt b/Documentation/devicetree/bindings/i2c/i2c-at91.txt
index 96c914e048f5..2015f50aed0f 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-at91.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-at91.txt
@@ -73,7 +73,7 @@ i2c0: i2c@f8034600 {
 	pinctrl-0 = <&pinctrl_i2c0>;
 	pinctrl-1 = <&pinctrl_i2c0_gpio>;
 	sda-gpios = <&pioA 30 GPIO_ACTIVE_HIGH>;
-	scl-gpios = <&pioA 31 GPIO_ACTIVE_HIGH>;
+	scl-gpios = <&pioA 31 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 
 	wm8731: wm8731@1a {
 		compatible = "wm8731";
-- 
2.30.2



