Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10FD45BAED
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbhKXMP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242560AbhKXMMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE2C61074;
        Wed, 24 Nov 2021 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755611;
        bh=uhUFfBpuoDu4WC0xjH4CkbA2dKcnwk3j6VeoLLPXras=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrFaV3EyRsro4v3X6LTqmg5SJgLWtsIqn/BhTIr5BRKIjO1hLzS5ob2HbgYWDrYhS
         kOaCWV9jP5Ahp+w6mcAEpBvDcLADuYDGJp0c/6i20JI/SjHaDOA2ONtjCjQnZBZrmN
         1Z03lEnQNdNkMOhe6e1M6GdR0beHHVHSXP7Csvtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatolij Gustschin <agust@denx.de>,
        Rob Herring <robh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 126/162] powerpc/5200: dts: fix memory node unit name
Date:   Wed, 24 Nov 2021 12:57:09 +0100
Message-Id: <20211124115702.375098829@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatolij Gustschin <agust@denx.de>

[ Upstream commit aed2886a5e9ffc8269a4220bff1e9e030d3d2eb1 ]

Fixes build warnings:
Warning (unit_address_vs_reg): /memory: node has a reg or ranges property, but no unit name

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211013220532.24759-4-agust@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/charon.dts    | 2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts | 2 +-
 arch/powerpc/boot/dts/lite5200.dts  | 2 +-
 arch/powerpc/boot/dts/lite5200b.dts | 2 +-
 arch/powerpc/boot/dts/media5200.dts | 2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi | 2 +-
 arch/powerpc/boot/dts/o2d.dts       | 2 +-
 arch/powerpc/boot/dts/o2d.dtsi      | 2 +-
 arch/powerpc/boot/dts/o2dnt2.dts    | 2 +-
 arch/powerpc/boot/dts/o3dnt.dts     | 2 +-
 arch/powerpc/boot/dts/pcm032.dts    | 2 +-
 arch/powerpc/boot/dts/tqm5200.dts   | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/boot/dts/charon.dts b/arch/powerpc/boot/dts/charon.dts
index 0e00e508eaa6a..1c8fe20752e6a 100644
--- a/arch/powerpc/boot/dts/charon.dts
+++ b/arch/powerpc/boot/dts/charon.dts
@@ -39,7 +39,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;	// 128MB
 	};
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index 955bff629df3c..bf511255f3ae8 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -20,7 +20,7 @@
 	model = "intercontrol,digsy-mtc";
 	compatible = "intercontrol,digsy-mtc";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x02000000>;	// 32MB
 	};
 
diff --git a/arch/powerpc/boot/dts/lite5200.dts b/arch/powerpc/boot/dts/lite5200.dts
index 179a1785d6454..18d137a3393f0 100644
--- a/arch/powerpc/boot/dts/lite5200.dts
+++ b/arch/powerpc/boot/dts/lite5200.dts
@@ -36,7 +36,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index 5abb46c5cc951..29419cf81e044 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -35,7 +35,7 @@
 		led4 { gpios = <&gpio_simple 2 1>; };
 	};
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x10000000>;	// 256MB
 	};
 
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index b5413cb85f134..3d57463bc49da 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -36,7 +36,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;	// 128MB RAM
 	};
 
diff --git a/arch/powerpc/boot/dts/mpc5200b.dtsi b/arch/powerpc/boot/dts/mpc5200b.dtsi
index 969b2200b2f97..ecfba675b5611 100644
--- a/arch/powerpc/boot/dts/mpc5200b.dtsi
+++ b/arch/powerpc/boot/dts/mpc5200b.dtsi
@@ -37,7 +37,7 @@
 		};
 	};
 
-	memory: memory {
+	memory: memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
diff --git a/arch/powerpc/boot/dts/o2d.dts b/arch/powerpc/boot/dts/o2d.dts
index 9f6dd4d889b32..5a676e8141caf 100644
--- a/arch/powerpc/boot/dts/o2d.dts
+++ b/arch/powerpc/boot/dts/o2d.dts
@@ -16,7 +16,7 @@
 	model = "ifm,o2d";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;  // 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o2d.dtsi b/arch/powerpc/boot/dts/o2d.dtsi
index cf073e693f24d..1b4df5f64b580 100644
--- a/arch/powerpc/boot/dts/o2d.dtsi
+++ b/arch/powerpc/boot/dts/o2d.dtsi
@@ -23,7 +23,7 @@
 	model = "ifm,o2d";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o2dnt2.dts b/arch/powerpc/boot/dts/o2dnt2.dts
index a0f5b97a4f06e..5184c461a205f 100644
--- a/arch/powerpc/boot/dts/o2dnt2.dts
+++ b/arch/powerpc/boot/dts/o2dnt2.dts
@@ -16,7 +16,7 @@
 	model = "ifm,o2dnt2";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;  // 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o3dnt.dts b/arch/powerpc/boot/dts/o3dnt.dts
index acce49326491b..045b901719245 100644
--- a/arch/powerpc/boot/dts/o3dnt.dts
+++ b/arch/powerpc/boot/dts/o3dnt.dts
@@ -16,7 +16,7 @@
 	model = "ifm,o3dnt";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x04000000>;  // 64MB
 	};
 
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 96b139bf50e9c..ac3f53c1a1f5b 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -26,7 +26,7 @@
 	model = "phytec,pcm032";
 	compatible = "phytec,pcm032";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;	// 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/tqm5200.dts b/arch/powerpc/boot/dts/tqm5200.dts
index 1db07f6cf133c..68b9e8240fb5b 100644
--- a/arch/powerpc/boot/dts/tqm5200.dts
+++ b/arch/powerpc/boot/dts/tqm5200.dts
@@ -36,7 +36,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
-- 
2.33.0



