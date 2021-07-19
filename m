Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBB3CE61B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349909AbhGSQCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 12:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349852AbhGSPuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B991961928;
        Mon, 19 Jul 2021 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712145;
        bh=QSDZwT5tOoiPb3hg0927O+8i50/wvrSYMD823NmvtVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G55moY9rLMGbU60HnBEpmZqjKrmiIF7si9XckeDTCnz4W4JX6tBCzSEAPt+mYzqW/
         eFFJe9e59FjwdQvD7OrfhniQJg6H25NiEDSNlcSC2P1B38h5/U02WYKeMnwhwN31Kk
         DlR0MR4hFXcdW5NOQe8oKgzvmDXmDbctDdxGBC3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 260/292] arm64: dts: ti: k3-j721e-common-proc-board: Re-name "link" name as "phy"
Date:   Mon, 19 Jul 2021 16:55:22 +0200
Message-Id: <20210719144951.477326331@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 02b4d9186121d842a53e347f53a86ec7f2c6b0c7 ]

Commit 66db854b1f62d ("arm64: dts: ti: k3-j721e-common-proc-board:
Configure the PCIe instances") and
commit 02c35dca2b488 ("arm64: dts: ti: k3-j721e: Enable Super-Speed
support for USB0") added PHY DT nodes with node name as "link"
However nodes with #phy-cells should be named 'phy' as discussed in [1].
Re-name subnodes of serdes in J721E to 'phy'.

[1] -> http://lore.kernel.org/r/20200909203631.GA3026331@bogus

Fixes: 66db854b1f62d ("arm64: dts: ti: k3-j721e-common-proc-board: Configure the PCIe instances")
Fixes: 02c35dca2b488 ("arm64: dts: ti: k3-j721e: Enable Super-Speed support for USB0")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210603143427.28735-5-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 1b25a5ae9635..ffccbc53f1e7 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -359,7 +359,7 @@
 };
 
 &serdes3 {
-	serdes3_usb_link: link@0 {
+	serdes3_usb_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
@@ -674,7 +674,7 @@
 	assigned-clocks = <&serdes0 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz0_pll1_refclk>;
 
-	serdes0_pcie_link: link@0 {
+	serdes0_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <1>;
 		#phy-cells = <0>;
@@ -687,7 +687,7 @@
 	assigned-clocks = <&serdes1 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz1_pll1_refclk>;
 
-	serdes1_pcie_link: link@0 {
+	serdes1_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
@@ -700,7 +700,7 @@
 	assigned-clocks = <&serdes2 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz2_pll1_refclk>;
 
-	serdes2_pcie_link: link@0 {
+	serdes2_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
-- 
2.30.2



