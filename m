Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3998A3CDE0F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbhGSPBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344045AbhGSO72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0C061370;
        Mon, 19 Jul 2021 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709103;
        bh=UOP27A4JLxIDp8jJiTk1cTNwlqd0gxcc5e01WKIxkSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzL299UzwX9R1c1KJ9Pbft79BIhyBngj7hXUiAT3gepcZ/Nr592wL9pjff5e7yP4p
         cPiQiIGCfs5TN96/bpVmIPRoiNUKAdMhkaN8ctmi+BPuH7jx++I/x7afgyFJcOjgeN
         y567mdl+W8/sbR6HeG/iwG/erHMtOSWeQ4Pw0e2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 220/421] arm64: dts: marvell: armada-37xx: Fix reg for standard variant of UART
Date:   Mon, 19 Jul 2021 16:50:31 +0200
Message-Id: <20210719144953.967221694@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index 3a611250f598..1844fb8605f0 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -121,7 +121,7 @@
 
 			uart0: serial@12000 {
 				compatible = "marvell,armada-3700-uart";
-				reg = <0x12000 0x200>;
+				reg = <0x12000 0x18>;
 				clocks = <&xtalclk>;
 				interrupts =
 				<GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.30.2



