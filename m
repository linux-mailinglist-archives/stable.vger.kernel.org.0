Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731523CE262
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348292AbhGSPaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348061AbhGSPYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DF5613F1;
        Mon, 19 Jul 2021 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710456;
        bh=Yxsl8x1opyX50THCsARORkBr5Q0cix0VZwo5yzMphxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1oVTHXwwvrmgdxs0WUxOydhgQXrk1kbC5rThRykU+lbEE9IF993DkHjbYyvNSguf
         vfheGbi4Ky/AoQptUSb9ibk5UgQreHv7sxFoAaw1vRrw9lGjoH8XX96R5fdMpY9Fuh
         xBPYegskhhljogGuez/ZyVFX7mZOGgod9Yhtnj5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/243] arm64: dts: ti: k3-j721e-common-proc-board: Re-name "link" name as "phy"
Date:   Mon, 19 Jul 2021 16:54:06 +0200
Message-Id: <20210719144947.930849236@linuxfoundation.org>
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
index 56a92f59c3a1..964e70ddf8e6 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -326,7 +326,7 @@
 };
 
 &serdes3 {
-	serdes3_usb_link: link@0 {
+	serdes3_usb_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
@@ -599,7 +599,7 @@
 	assigned-clocks = <&serdes0 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz0_pll1_refclk>;
 
-	serdes0_pcie_link: link@0 {
+	serdes0_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <1>;
 		#phy-cells = <0>;
@@ -612,7 +612,7 @@
 	assigned-clocks = <&serdes1 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz1_pll1_refclk>;
 
-	serdes1_pcie_link: link@0 {
+	serdes1_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
@@ -625,7 +625,7 @@
 	assigned-clocks = <&serdes2 CDNS_SIERRA_PLL_CMNLC>;
 	assigned-clock-parents = <&wiz2_pll1_refclk>;
 
-	serdes2_pcie_link: link@0 {
+	serdes2_pcie_link: phy@0 {
 		reg = <0>;
 		cdns,num-lanes = <2>;
 		#phy-cells = <0>;
-- 
2.30.2



