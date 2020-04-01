Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1537119B328
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbgDAQoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388617AbgDAQoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CB22063A;
        Wed,  1 Apr 2020 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759476;
        bh=tlBCLzB8KqqSYZkd4B/QOZWltHSyIudbX/rrs3U1giY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDwfyZOCaOVOVlNDPcQqk0D9JY4c8Nd1LcMcJiCEQ0qesunrySGBxdC3M0zp1g9+8
         vIdENOBqZh7CHepejOqOHLo9c9DnOHqrP0SRESwpoDHTY+Ea29FdLBvHfGRFL1tuM2
         xyY22BDSNUYhL8d+Chvl28joqzewUGhWlW9kR0Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.14 092/148] ARM: dts: omap5: Add bus_dma_limit for L3 bus
Date:   Wed,  1 Apr 2020 18:18:04 +0200
Message-Id: <20200401161601.814782206@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit dfa7ea303f56a3a8b1ed3b91ef35af2da67ca4ee upstream.

The L3 interconnect's memory map is from 0x0 to
0xffffffff. Out of this, System memory (SDRAM) can be
accessed from 0x80000000 to 0xffffffff (2GB)

OMAP5 does support 4GB of SDRAM but upper 2GB can only be
accessed by the MPU subsystem.

Add the dma-ranges property to reflect the physical address limit
of the L3 bus.

Cc: stable@kernel.org
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap5.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -131,6 +131,7 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xc0000000>;
+		dma-ranges = <0x80000000 0x0 0x80000000 0x80000000>;
 		ti,hwmods = "l3_main_1", "l3_main_2", "l3_main_3";
 		reg = <0 0x44000000 0 0x2000>,
 		      <0 0x44800000 0 0x3000>,


