Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054231EAB3A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgFASP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgFASPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6AC82073B;
        Mon,  1 Jun 2020 18:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035323;
        bh=SqG4whJ1VEAEkNByq572cqCP5htHqrxHUkMAtyTWFuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ik69irgXtgwVWR89oDnRi2sBTKPY7POU/+qPmGQHKx+TDPkhaaX7Z6LQUcoNKSvJr
         bbR0HgpFj2xxnBpohlDf/qx1UOsUIS+vw6WwRNFMrnt/LtK6weq7hNhCu3WvOGomd6
         KEE8pEDINq3f7HDL7CbRgOTi18qZji6k1RiHDSK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 108/177] ARM: dts: mmp3: Drop usb-nop-xceiv from HSIC phy
Date:   Mon,  1 Jun 2020 19:54:06 +0200
Message-Id: <20200601174057.607240412@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 24cf6eef79a7e85cfd2ef9dea52f769c9192fc6e ]

"usb-nop-xceiv" is good enough if we don't lose the configuration done
by the firmware, but we'd really prefer a real driver.

Unfortunately, the PHY core is odd in that when the node is compatible
with "usb-nop-xceiv", it ignores the other compatible strings. Let's
just remove it.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mmp3.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/mmp3.dtsi b/arch/arm/boot/dts/mmp3.dtsi
index 3e28f0dc9df4..1e25bf998ab5 100644
--- a/arch/arm/boot/dts/mmp3.dtsi
+++ b/arch/arm/boot/dts/mmp3.dtsi
@@ -202,8 +202,7 @@
 			};
 
 			hsic_phy0: hsic-phy@f0001800 {
-				compatible = "marvell,mmp3-hsic-phy",
-					     "usb-nop-xceiv";
+				compatible = "marvell,mmp3-hsic-phy";
 				reg = <0xf0001800 0x40>;
 				#phy-cells = <0>;
 				status = "disabled";
@@ -224,8 +223,7 @@
 			};
 
 			hsic_phy1: hsic-phy@f0002800 {
-				compatible = "marvell,mmp3-hsic-phy",
-					     "usb-nop-xceiv";
+				compatible = "marvell,mmp3-hsic-phy";
 				reg = <0xf0002800 0x40>;
 				#phy-cells = <0>;
 				status = "disabled";
-- 
2.25.1



