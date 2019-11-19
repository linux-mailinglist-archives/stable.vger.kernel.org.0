Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78C21016CD
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbfKSFyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732150AbfKSFya (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6173221783;
        Tue, 19 Nov 2019 05:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142869;
        bh=kiO9wqUjASzmMINbaT3sESNlTQfAAWLNzXtu9pP1MHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZO5rlO3U+JA4BbkkdmxBN12OreBpAITLcQRoqWXxwLX4amlFMMX8JBT1Kpuz8FAa
         2p4jzdC+XcSBJL4Z2pKTdHM7AI6vZS9lr5ozGZ22/U/4A5xwgrwdFwFjnNb130H5Yc
         hu39RJGxUYQb21Na7lx2nSIgn/v7mcloRIY6rB5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijeshkumar.singh@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 229/239] arm64: dts: amd: Fix SPI bus warnings
Date:   Tue, 19 Nov 2019 06:20:29 +0100
Message-Id: <20191119051341.035728139@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit e9f0878c4b2004ac19581274c1ae4c61ae3ca70e ]

dtc has new checks for SPI buses. Fix the warnings in node names.

arch/arm64/boot/dts/amd/amd-overdrive.dtb: Warning (spi_bus_bridge): /smb/ssp@e1030000: node name for SPI buses should be 'spi'
arch/arm64/boot/dts/amd/amd-overdrive-rev-b0.dtb: Warning (spi_bus_bridge): /smb/ssp@e1030000: node name for SPI buses should be 'spi'
arch/arm64/boot/dts/amd/amd-overdrive-rev-b1.dtb: Warning (spi_bus_bridge): /smb/ssp@e1030000: node name for SPI buses should be 'spi'

Cc: Brijesh Singh <brijeshkumar.singh@amd.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
index 125f4deb52fe9..b664e7af74eb3 100644
--- a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
+++ b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
@@ -107,7 +107,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		spi0: ssp@e1020000 {
+		spi0: spi@e1020000 {
 			status = "disabled";
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0 0xe1020000 0 0x1000>;
@@ -117,7 +117,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		spi1: ssp@e1030000 {
+		spi1: spi@e1030000 {
 			status = "disabled";
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0 0xe1030000 0 0x1000>;
-- 
2.20.1



