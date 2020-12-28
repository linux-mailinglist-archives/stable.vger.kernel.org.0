Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A102E4215
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437316AbgL1OEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437302AbgL1OEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8266207BC;
        Mon, 28 Dec 2020 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164220;
        bh=+nKGy0AjWjO4m/KormxSgCb+6U5YuNRuT+lzoMlTsNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3tRqkTUf1RUqECU/PVlQcQB9ynohcR2VW/p8XQuQA1jAileVZV3HwNW/nors1xlo
         XaH7GCMKjddd0IbB4WvDsT41l8sdsW1QueV/L9RTHCtDEz6eVJHK06udNXYpe0VPw6
         4Rj5c9aKBYF30zzFzR3hB2Vc8uEiNR7IfPiiOHX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/717] arm64: dts: ti: k3-am65*/j721e*: Fix unit address format error for dss node
Date:   Mon, 28 Dec 2020 13:41:41 +0100
Message-Id: <20201228125025.895857912@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

[ Upstream commit cfbf17e69ae82f647c287366b7573e532fc281ee ]

Fix the node address to follow the device tree convention.

This fixes the dtc warning:
<stdout>: Warning (simple_bus_reg): /bus@100000/dss@04a00000: simple-bus
unit address format error, expected "4a00000"

Fixes: 76921f15acc0 ("arm64: dts: ti: k3-j721e-main: Add DSS node")
Fixes: fc539b90eda2 ("arm64: dts: ti: am654: Add DSS node")
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Jyri Sarha <jsarha@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jyri Sarha <jsarha@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://lore.kernel.org/r/20201104222519.12308-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi  | 2 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 533525229a8db..27f6fd9eaa0ab 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -834,7 +834,7 @@
 		};
 	};
 
-	dss: dss@04a00000 {
+	dss: dss@4a00000 {
 		compatible = "ti,am65x-dss";
 		reg =	<0x0 0x04a00000 0x0 0x1000>, /* common */
 			<0x0 0x04a02000 0x0 0x1000>, /* vidl1 */
diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index e2a96b2c423c4..c66ded9079be4 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -1278,7 +1278,7 @@
 		};
 	};
 
-	dss: dss@04a00000 {
+	dss: dss@4a00000 {
 		compatible = "ti,j721e-dss";
 		reg =
 			<0x00 0x04a00000 0x00 0x10000>, /* common_m */
-- 
2.27.0



