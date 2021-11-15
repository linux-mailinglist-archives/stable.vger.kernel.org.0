Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EC445145C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348187AbhKOUEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344252AbhKOTYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C544263657;
        Mon, 15 Nov 2021 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002479;
        bh=DQ0i8PqimY1w6+qIllmuwTvk9wuit1mUHuouyYfBbyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEWZcp3aK9Rp7/Y8Zs2TnNeBaQulufzAc6BmUDmaZMkP37LpSDRct7QQy0hXTFp8q
         ekQcGR34j65E+4bDNunBGpgh0VhCiRx7huIWNH8jxl3lzT+k7AsJzdZ+C2sJTKOPVd
         Mnl0bwG/jHLvmTkJ2X4mOCWZqCleJSRdqdnyJVJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 582/917] arm64: dts: ti: j7200-main: Fix "vendor-id"/"device-id" properties of pcie node
Date:   Mon, 15 Nov 2021 18:01:17 +0100
Message-Id: <20211115165448.506664336@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 0d553792726a61ced760422e74ea67552ac69cdb ]

commit 3276d9f53cf6 ("arm64: dts: ti: k3-j7200-main: Add PCIe device
tree node") incorrectly added "vendor-id" and "device-id" as 16-bit
properties though both of them are 32-bit properties. Fix it here.

Fixes: 3276d9f53cf6 ("arm64: dts: ti: k3-j7200-main: Add PCIe device tree node")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210915055358.19997-4-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index e8a41d09b45f2..521a56316fa5c 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -608,8 +608,8 @@
 		#size-cells = <2>;
 		bus-range = <0x0 0xf>;
 		cdns,no-bar-match-nbits = <64>;
-		vendor-id = /bits/ 16 <0x104c>;
-		device-id = /bits/ 16 <0xb00f>;
+		vendor-id = <0x104c>;
+		device-id = <0xb00f>;
 		msi-map = <0x0 &gic_its 0x0 0x10000>;
 		dma-coherent;
 		ranges = <0x01000000 0x0 0x18001000  0x00 0x18001000  0x0 0x0010000>,
-- 
2.33.0



