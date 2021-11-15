Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A889D451F3A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355806AbhKPAil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344216AbhKOTYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05C496363D;
        Mon, 15 Nov 2021 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002445;
        bh=jLx/TiqCWkq6M2IK5tjtNuEWhV933eY9CLLnZYAahz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuXKTPo6ZQiSzMxBA9whlwMtVTqhXzXEhVmbP/ezlxHapU1VEVQfRi9m+eElk+BRF
         E3aeTVq0RjQGqrUHSVXwUDp6wNrIftRP3D0MsOCQD9h954mHVgxyGM3Bb2SRymq/2U
         EP3kSIH3XExU8QUW1ozQVmegV/H9qGWykIVTTAFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 570/917] ARM: dts: BCM5301X: Fix memory nodes names
Date:   Mon, 15 Nov 2021 18:01:05 +0100
Message-Id: <20211115165448.110819296@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit c5e1df3276d7a500678da9453be31a66ad115150 ]

Thix fixes:
arch/arm/boot/dts/bcm4708-netgear-r6250.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 134217728]]}
arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 134217728]]}
arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 402653184]]}
arch/arm/boot/dts/bcm4709-linksys-ea9200.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 134217728]]}
arch/arm/boot/dts/bcm4709-netgear-r7000.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 134217728]]}
arch/arm/boot/dts/bcm4709-netgear-r8000.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 134217728]]}
arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728]]}
arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728], [2281701376, 402653184]]}
arch/arm/boot/dts/bcm53016-meraki-mr32.dt.yaml: /: memory: False schema does not allow {'reg': [[0, 134217728]], 'device_type': ['memory']}
arch/arm/boot/dts/bcm94708.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728]]}
arch/arm/boot/dts/bcm94709.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 134217728]]}

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts       | 2 +-
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts       | 2 +-
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts | 2 +-
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts      | 2 +-
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts       | 2 +-
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts       | 2 +-
 arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts | 2 +-
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts     | 2 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts        | 2 +-
 arch/arm/boot/dts/bcm94708.dts                    | 2 +-
 arch/arm/boot/dts/bcm94709.dts                    | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
index 61c7b137607e5..7900aac4f35a9 100644
--- a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
+++ b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
@@ -20,7 +20,7 @@
 		bootargs = "console=ttyS0,115200 earlycon";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x08000000>;
diff --git a/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts b/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
index 6c6bb7b17d27a..7546c8d07bcd7 100644
--- a/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
+++ b/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
@@ -19,7 +19,7 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x08000000>;
diff --git a/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts b/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
index d29e7f80ea6aa..beae9eab9cb8c 100644
--- a/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
+++ b/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
@@ -19,7 +19,7 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x18000000>;
diff --git a/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts b/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
index 9b6887d477d86..7879f7d7d9c33 100644
--- a/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
+++ b/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
@@ -16,7 +16,7 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x08000000>;
diff --git a/arch/arm/boot/dts/bcm4709-netgear-r7000.dts b/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
index 7989a53597d4f..56d309dbc6b0d 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
@@ -19,7 +19,7 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x08000000>;
diff --git a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
index 87b655be674c5..184e3039aa864 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
@@ -30,7 +30,7 @@
 		bootargs = "console=ttyS0,115200";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x08000000>;
diff --git a/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts b/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts
index f806be5da7237..c2a266a439d05 100644
--- a/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts
+++ b/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dts
@@ -15,7 +15,7 @@
 		bootargs = "console=ttyS0,115200 earlycon";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;
 	};
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
index 452b8d0ab180e..b0d8a688141d3 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
@@ -16,7 +16,7 @@
 		bootargs = "earlycon";
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>,
 		      <0x88000000 0x18000000>;
diff --git a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
index 3b978dc8997a4..612d61852bfb9 100644
--- a/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
+++ b/arch/arm/boot/dts/bcm53016-meraki-mr32.dts
@@ -20,7 +20,7 @@
 		bootargs = " console=ttyS0,115200n8 earlycon";
 	};
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;
 		device_type = "memory";
 	};
diff --git a/arch/arm/boot/dts/bcm94708.dts b/arch/arm/boot/dts/bcm94708.dts
index 3d13e46c69494..d9eb2040b9631 100644
--- a/arch/arm/boot/dts/bcm94708.dts
+++ b/arch/arm/boot/dts/bcm94708.dts
@@ -38,7 +38,7 @@
 	model = "NorthStar SVK (BCM94708)";
 	compatible = "brcm,bcm94708", "brcm,bcm4708";
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;
 	};
diff --git a/arch/arm/boot/dts/bcm94709.dts b/arch/arm/boot/dts/bcm94709.dts
index 5017b7b259cbe..618c812eef73e 100644
--- a/arch/arm/boot/dts/bcm94709.dts
+++ b/arch/arm/boot/dts/bcm94709.dts
@@ -38,7 +38,7 @@
 	model = "NorthStar SVK (BCM94709)";
 	compatible = "brcm,bcm94709", "brcm,bcm4709", "brcm,bcm4708";
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;
 	};
-- 
2.33.0



