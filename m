Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3640837C20E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhELPGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233291AbhELPFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 470BB61941;
        Wed, 12 May 2021 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831591;
        bh=HOAR6x9aEH1v2p5/ELqIkvIsmRCrWWMQEJx9nenHQw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMzz4zxEGplwY64Z1mb9VLzxAzB73yDD4G2jwbmTS1d0k2uEGwwgofilq+aT1QeDL
         +EFy9X7VMTMBe3NfT6awz96Z2z1OhL2NDhHKha9EsIcBa4TX0ZeaYVBkox2TBOGb9p
         dsw5HXZ29o7pHl+wFLdaobC1isBw6YQdyZc3LK68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/244] mips: bmips: fix syscon-reboot nodes
Date:   Wed, 12 May 2021 16:49:12 +0200
Message-Id: <20210512144748.789653470@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit cde58b861a1d365568588adda59d42351c0c4ad3 ]

Commit a23c4134955e added the clock controller nodes, incorrectly changing the
syscon-reboot nodes addresses.

Fixes: a23c4134955e ("MIPS: BMIPS: add clock controller nodes")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/brcm/bcm3368.dtsi  | 2 +-
 arch/mips/boot/dts/brcm/bcm63268.dtsi | 2 +-
 arch/mips/boot/dts/brcm/bcm6358.dtsi  | 2 +-
 arch/mips/boot/dts/brcm/bcm6362.dtsi  | 2 +-
 arch/mips/boot/dts/brcm/bcm6368.dtsi  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/boot/dts/brcm/bcm3368.dtsi b/arch/mips/boot/dts/brcm/bcm3368.dtsi
index 69cbef472377..d4b2b430dad0 100644
--- a/arch/mips/boot/dts/brcm/bcm3368.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm3368.dtsi
@@ -59,7 +59,7 @@
 
 		periph_cntl: syscon@fff8c008 {
 			compatible = "syscon";
-			reg = <0xfff8c000 0x4>;
+			reg = <0xfff8c008 0x4>;
 			native-endian;
 		};
 
diff --git a/arch/mips/boot/dts/brcm/bcm63268.dtsi b/arch/mips/boot/dts/brcm/bcm63268.dtsi
index beec24145af7..30fdd38aef6d 100644
--- a/arch/mips/boot/dts/brcm/bcm63268.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm63268.dtsi
@@ -59,7 +59,7 @@
 
 		periph_cntl: syscon@10000008 {
 			compatible = "syscon";
-			reg = <0x10000000 0xc>;
+			reg = <0x10000008 0x4>;
 			native-endian;
 		};
 
diff --git a/arch/mips/boot/dts/brcm/bcm6358.dtsi b/arch/mips/boot/dts/brcm/bcm6358.dtsi
index f21176cac038..89a3107cad28 100644
--- a/arch/mips/boot/dts/brcm/bcm6358.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm6358.dtsi
@@ -59,7 +59,7 @@
 
 		periph_cntl: syscon@fffe0008 {
 			compatible = "syscon";
-			reg = <0xfffe0000 0x4>;
+			reg = <0xfffe0008 0x4>;
 			native-endian;
 		};
 
diff --git a/arch/mips/boot/dts/brcm/bcm6362.dtsi b/arch/mips/boot/dts/brcm/bcm6362.dtsi
index 8ae6981735b8..e48946a51242 100644
--- a/arch/mips/boot/dts/brcm/bcm6362.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm6362.dtsi
@@ -59,7 +59,7 @@
 
 		periph_cntl: syscon@10000008 {
 			compatible = "syscon";
-			reg = <0x10000000 0xc>;
+			reg = <0x10000008 0x4>;
 			native-endian;
 		};
 
diff --git a/arch/mips/boot/dts/brcm/bcm6368.dtsi b/arch/mips/boot/dts/brcm/bcm6368.dtsi
index 449c167dd892..b84a3bfe8c51 100644
--- a/arch/mips/boot/dts/brcm/bcm6368.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm6368.dtsi
@@ -59,7 +59,7 @@
 
 		periph_cntl: syscon@100000008 {
 			compatible = "syscon";
-			reg = <0x10000000 0xc>;
+			reg = <0x10000008 0x4>;
 			native-endian;
 		};
 
-- 
2.30.2



