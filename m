Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0020B3CE41A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343493AbhGSPmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349048AbhGSPfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5D96135D;
        Mon, 19 Jul 2021 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711364;
        bh=NgBHwizkBPfl20KQ5b3snh/MP1md7Enr6VTHtVuhnY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGSey5KWWh50x19s44unRQQTJfgaEoEr1hC6IeYJEUmsGKAOHVka2eHHzhblw5dZ+
         IkUszB4aTwevwcmDsLk+apqIWKV6IK15i+k4vtxf0mMIFN7DvE7Q9ManPUgN5zIP6h
         z+2m/uBQevA2E443J98CMGl2UrOzXvB93GvBeIdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 327/351] arm64: dts: ti: am65: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:54:33 +0200
Message-Id: <20210719144955.875099808@linuxfoundation.org>
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

[ Upstream commit 4f76ea7b4da1cce9a9bda1fa678ef8036584c66b ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: e180f76d0641 ("arm64: dts: ti: Add support for Siemens IOT2050 boards")
Fixes: 5da94b50475a ("arm64: dts: ti: k3-am654: Enable main domain McSPI0")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210608051414.14873-2-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi | 2 +-
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
index de763ca9251c..d9a7e2689b93 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
@@ -575,7 +575,7 @@
 
 	#address-cells = <1>;
 	#size-cells= <0>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 };
 
 &tscadc0 {
diff --git a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
index eddb2ffb93ca..1b947e2c2e74 100644
--- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
@@ -299,7 +299,7 @@
 	pinctrl-0 = <&main_spi0_pins_default>;
 	#address-cells = <1>;
 	#size-cells= <0>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 
 	flash@0{
 		compatible = "jedec,spi-nor";
-- 
2.30.2



