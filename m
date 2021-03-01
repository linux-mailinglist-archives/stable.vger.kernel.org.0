Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9B32899E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhCASAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235829AbhCARyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:54:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA8A6526E;
        Mon,  1 Mar 2021 17:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619797;
        bh=IYvwauLhh6MJU5Pj26oRPbgJM2dGDpsGWnlPDeTXntU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQGe1D6qvgzzDN1LrO7+9SLJ0vYT+4gXO/cM7OmwjtAeJAzfn2Hlzd6TX5pp5ND2N
         559aWFkav2N8SK1vJv3usbCH5NKhb6Vc9GgyJ1mif79R78BfWk1vnOhhH+ofs0Fn3b
         iew+7pymP7foiEL/QLRcQSFaO4FAVtOlSY2nVygo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 557/663] arm64: dts: agilex: fix phy interface bit shift for gmac1 and gmac2
Date:   Mon,  1 Mar 2021 17:13:25 +0100
Message-Id: <20210301161209.434719630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


