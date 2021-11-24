Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7551E45D0D1
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352502AbhKXXIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352510AbhKXXIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD8C6108B;
        Wed, 24 Nov 2021 23:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795138;
        bh=cwJ0W3fAvNoxQ7n1692FMeJJdYI5pNIPnkQ6X29b1vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JapzfnWUHpXdv9bn9x+p1FcWFc9LF/rMTyC/8VPyzHuaFjIRumNfEY/OwHykxRTW0
         vALILd5IPxxrolgIu9xcsxj+sF9ZAAhysITOUlhzwNjt+6qyDWkZljdAg8p182Mjts
         aljbFB7kaaTSfAcU3SOyuJQGZBYkktnrZgGFqHLsLMuNlWf8H0//8nJrftnpzkxTp/
         5hPkiQhR0wgvfhZvCUMh3WHxgkhJgSyLlKWac07RB8DICvLf0ndER08iMtcsTON/PJ
         tZ+h1lmLw1vKq8CGYp7uI0Y7agDv4m8XMAwPslaC0h8D9S1FdgUyLqQB4Vhbfw3zxW
         sqSKb5y2yxUnA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 19/20] arm64: dts: marvell: armada-37xx: declare PCIe reset pin
Date:   Thu, 25 Nov 2021 00:04:59 +0100
Message-Id: <20211124230500.27109-20-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a5470af981a0cc14a650af8da5186668971a4fc8 upstream.

One pin can be muxed as PCIe endpoint card reset.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index fca78eb334b1..5299a16459f2 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -254,6 +254,15 @@
 					function = "mii";
 				};
 
+				pcie_reset_pins: pcie-reset-pins {
+					groups = "pcie1";
+					function = "pcie";
+				};
+
+				pcie_clkreq_pins: pcie-clkreq-pins {
+					groups = "pcie1_clkreq";
+					function = "pcie";
+				};
 			};
 
 			eth0: ethernet@30000 {
-- 
2.32.0

