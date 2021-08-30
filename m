Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439273FB4EF
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhH3MAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236612AbhH3MAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E83D961152;
        Mon, 30 Aug 2021 11:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324789;
        bh=oFtGd9wBKas3imSbUBcVzBp33A85ze2Juxm8A9r2lhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIH5FOxM/WkgMuIe++n+u7MKz4o90V7fmh6OkL5dXf/mxGw2zxmALgcTNKPhqyc2d
         TczUVXn+UXam6TijPzkjk+8EXDW9CjNJ/FTpRUgHyYpwdtewoJ0dTnCSQRnlHSHecP
         QPu/s17c+MehMbt1/v05acETSsSAcyJW6w4D8JkEkVDXg55mSPJEYZrtPrxNWGHqAF
         56OgEDOp55J/k1m8pkUAoL6GdRKFuUOTyr1SzNtfmxCFqoEyd/4Kjv9IaKYWXpANLR
         /NMAR7Xm4Jn8/Eu2H8qbZMzIqAZaq/JdWrxC07pzOcUCSU/fS9LORWrZng2IMLnnXJ
         X34lG1UY+J4Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bin Meng <bin.meng@windriver.com>,
        conor dooley <conor.dooley@microchip.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 05/14] riscv: dts: microchip: Use 'local-mac-address' for emac1
Date:   Mon, 30 Aug 2021 07:59:33 -0400
Message-Id: <20210830115942.1017300-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

[ Upstream commit 719588dee26bac0d5979c122bc530c43dc5d07c7 ]

Per the DT spec, 'local-mac-address' is used to specify MAC address
that was assigned to the network device, while 'mac-address' is used
to specify the MAC address that was last used by the boot program,
and shall be used only if the value differs from 'local-mac-address'
property value.

Signed-off-by: Bin Meng <bin.meng@windriver.com>
Reviewed-by: conor dooley <conor.dooley@microchip.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index b9819570a7d1..9d2fbbc1f777 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -317,7 +317,7 @@ emac1: ethernet@20112000 {
 			reg = <0x0 0x20112000 0x0 0x2000>;
 			interrupt-parent = <&plic>;
 			interrupts = <70 71 72 73>;
-			mac-address = [00 00 00 00 00 00];
+			local-mac-address = [00 00 00 00 00 00];
 			clocks = <&clkcfg 5>, <&clkcfg 2>;
 			status = "disabled";
 			clock-names = "pclk", "hclk";
-- 
2.30.2

