Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB092E65AF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389894AbgL1N2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389832AbgL1N2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAE7020728;
        Mon, 28 Dec 2020 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162064;
        bh=XqN+R25YosZQ5FWbb5570T593/SZUdje/I/dKAs/bqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5DnKE+PJcvrNhB+/xhzCucb4dWPC7S7hriSVGzoV1HNV5PSqnWw7+y45N+lhQbJa
         mkP9xpIc7u4zJ/tneX50GtFdt0hcL/pBr2Za5agyeEkAyOxGNToWSvdbdqu28uJR79
         znKjFO9QVfH8B5zebs+SRrgB2hiF1QfTiWXJ6fWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/346] ARM: dts: Remove non-existent i2c1 from 98dx3236
Date:   Mon, 28 Dec 2020 13:48:14 +0100
Message-Id: <20201228124928.245123394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 7f24479ead579459106bb55c2320a000135731f9 ]

The switches with integrated CPUs have only got a single i2c controller.
They incorrectly gained one when they were split from the Armada-XP.

Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
index 3e7d093d7a9a2..966d9a6c40fca 100644
--- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
+++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
@@ -266,11 +266,6 @@
 	reg = <0x11000 0x100>;
 };
 
-&i2c1 {
-	compatible = "marvell,mv78230-i2c", "marvell,mv64xxx-i2c";
-	reg = <0x11100 0x100>;
-};
-
 &mpic {
 	reg = <0x20a00 0x2d0>, <0x21070 0x58>;
 };
-- 
2.27.0



