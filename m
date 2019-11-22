Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE19107038
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKVKpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729070AbfKVKpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B242071C;
        Fri, 22 Nov 2019 10:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419521;
        bh=qFMPdXUEH6vwVV5eu/FaLP6bhy2xtehholYH6iinTzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rxa4exafLJ8MJ5A8ZOT4VbYJIMbn+4C8OX8Cj7NWXiJNiegvjjFBLsIODYIywg6pr
         Btjl1WMPPVjRp3i5qWOdl7+hl4JjFCg+WGVUHxDHDDQ85ZlAUNtWu/Gw2Y5jVVJTbP
         tRmvmyV9RtlFOaMRB2X/uuDpKGrfrKbS+hMYPjWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijeshkumar.singh@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 140/222] arm64: dts: amd: Fix SPI bus warnings
Date:   Fri, 22 Nov 2019 11:28:00 +0100
Message-Id: <20191122100912.955623871@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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
index bd3adeac374f4..2973a14523eaf 100644
--- a/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
+++ b/arch/arm64/boot/dts/amd/amd-seattle-soc.dtsi
@@ -106,7 +106,7 @@
 			clock-names = "uartclk", "apb_pclk";
 		};
 
-		spi0: ssp@e1020000 {
+		spi0: spi@e1020000 {
 			status = "disabled";
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0 0xe1020000 0 0x1000>;
@@ -116,7 +116,7 @@
 			clock-names = "apb_pclk";
 		};
 
-		spi1: ssp@e1030000 {
+		spi1: spi@e1030000 {
 			status = "disabled";
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0 0xe1030000 0 0x1000>;
-- 
2.20.1



