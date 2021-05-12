Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A964137C58E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhELPlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhELPhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895F461C44;
        Wed, 12 May 2021 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832700;
        bh=dWA+btwXG3IgrPt36VbOk0yrIjI6sypODftnJ/d+vJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu+jJ4IhSglDthRCpjV8vD5ye1Riux89o28Wjr+yCrv8aXv8hIVJSywk19jw+sGwx
         7Nn2zUTwoAQftbaS6SeLOZBlRbUsQ7vqJNogcI9Cr5e6MNVU8l1HbFZq8vKf6gDN97
         iduMZiSlT6YBWi58fGQKEX+WvSuTMFUf3C1SdPQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/530] mips: bmips: fix syscon-reboot nodes
Date:   Wed, 12 May 2021 16:48:17 +0200
Message-Id: <20210512144832.498530663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 5acb49b61867..365fa75cd9ac 100644
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
index c98f9111e3c8..0b2adefd75ce 100644
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



