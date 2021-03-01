Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013D532918E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243313AbhCAU1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242958AbhCAUVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F438653F6;
        Mon,  1 Mar 2021 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621879;
        bh=IYvwauLhh6MJU5Pj26oRPbgJM2dGDpsGWnlPDeTXntU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMfpDTxVXAIsQWDXNPtwX7FQrAg5j3UgZ50AGo0UxvZ4VspQoRJ/qFaSR9OFriPez
         3WrdEDunBU/OqYg2wN4O1/8N15RPV9pAha1rJ6s5Rise+M3bPshhJ46EDx5Gs7WhfA
         63K9l+1/PjFkVlmPSTcT6j9g4Gv3QmxWGOG7SNzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.11 660/775] arm64: dts: agilex: fix phy interface bit shift for gmac1 and gmac2
Date:   Mon,  1 Mar 2021 17:13:48 +0100
Message-Id: <20210301161233.996424922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit b7ff3a447d100c999d9848353ef8a4046831d893 upstream.

The shift for the phy_intf_sel bit in the system manager for gmac1 and
gmac2 should be 0.

Fixes: 2f804ba7aa9ee ("arm64: dts: agilex: Add SysMgr to Ethernet nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -166,7 +166,7 @@
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
 			iommus = <&smmu 2>;
-			altr,sysmgr-syscon = <&sysmgr 0x48 8>;
+			altr,sysmgr-syscon = <&sysmgr 0x48 0>;
 			clocks = <&clkmgr AGILEX_EMAC1_CLK>, <&clkmgr AGILEX_EMAC_PTP_CLK>;
 			clock-names = "stmmaceth", "ptp_ref";
 			status = "disabled";
@@ -184,7 +184,7 @@
 			rx-fifo-depth = <16384>;
 			snps,multicast-filter-bins = <256>;
 			iommus = <&smmu 3>;
-			altr,sysmgr-syscon = <&sysmgr 0x4c 16>;
+			altr,sysmgr-syscon = <&sysmgr 0x4c 0>;
 			clocks = <&clkmgr AGILEX_EMAC2_CLK>, <&clkmgr AGILEX_EMAC_PTP_CLK>;
 			clock-names = "stmmaceth", "ptp_ref";
 			status = "disabled";


