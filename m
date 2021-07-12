Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8012C3C4712
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhGLGbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhGLGaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7264260FE3;
        Mon, 12 Jul 2021 06:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071253;
        bh=hwAMy8mbjWGgM08ZYazmp615z/G3yg/x/W2m9uOTotA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfObuvV7Za/p+2+XA19DgGz/lTST2WoYclzVJe1yn5zeEkgDBaUgzGLQR7UFwwR5g
         oq3vXaHjNzo6abnmKSp2PPRtvh5kOT3N8xX/FjiPCGLAc8cxIBRPmr0VZlVENc9sn+
         PGkDr3PMrhRmELS47eZaYn9owSk4vU6HOYNaEnKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 338/348] arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART
Date:   Mon, 12 Jul 2021 08:12:02 +0200
Message-Id: <20210712060748.960280588@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2cbfdedef39fb5994b8f1e1df068eb8440165975 ]

UART1 (standard variant with DT node name 'uart0') has register space
0x12000-0x12018 and not whole size 0x200. So fix also this in example.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: c737abc193d1 ("arm64: dts: marvell: Fix A37xx UART0 register size")
Link: https://lore.kernel.org/r/20210624224909.6350-6-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 28ad59ee6c34..6cb1278613c5 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -134,7 +134,7 @@
 
 			uart0: serial@12000 {
 				compatible = "marvell,armada-3700-uart";
-				reg = <0x12000 0x200>;
+				reg = <0x12000 0x18>;
 				clocks = <&xtalclk>;
 				interrupts =
 				<GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.30.2



