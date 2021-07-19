Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A73CE419
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbhGSPmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349063AbhGSPfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0041F61353;
        Mon, 19 Jul 2021 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711367;
        bh=L49YH/ITUHIihx2GAELq0fq+6p+DSNTdvfuJGq4SGL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XtWOKPxn78IauUenktzvvQgRA6SdDA+QHFIfZtpWrstIW+IW3ofDszpUBlVnX6Lc
         f8CQfrcPdi6pUx32WPx3OyRPczlDUiWRwKkncflp6iB6uJibeP9VfiMMgmEzfioLWX
         pv6v98R2BaR/SSDAoHGkN2apPWlYp7Q/uMCZnYd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 328/351] arm64: dts: ti: k3-am642-evm: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:54:34 +0200
Message-Id: <20210719144955.914080024@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit d3f1b155c04d949c843e6028034766aba1e0f8bf ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: 4fb6c04683aa ("arm64: dts: ti: k3-am642-evm: Add support for SPI EEPROM")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210608051414.14873-3-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am642-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am642-evm.dts b/arch/arm64/boot/dts/ti/k3-am642-evm.dts
index dad0efa961ed..2fd0de905e61 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am642-evm.dts
@@ -334,7 +334,7 @@
 &main_spi0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_spi0_pins_default>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 	eeprom@0 {
 		compatible = "microchip,93lc46b";
 		reg = <0>;
-- 
2.30.2



