Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDD44B7C4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345146AbhKIWha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345134AbhKIWf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:35:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CC756109D;
        Tue,  9 Nov 2021 22:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496535;
        bh=A0IhG0duW+sokUwebqnXxg/iOEkbWqw7YJjmQJh7+Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VE1My35AdBRjdUT/Q95fU+bWBmYitUzw+DfFkXzyUJUpNNUN1MzMq99HFIJuDZCay
         c/UK147GoPKd5iML6dcvD93nc0bobZcYhY58mofEC2YpUvHGI28gQV9w9tBY3py9Xe
         aFLil523pm6g6L3+XxqzJ9j5w9XjKpJEmccys8xeMhgncqoA/+hXpRwAGw3B0Mgsan
         b8d/0kOJ9aUObHblyYLGq0hbADUq+z6aErADA4SQZQu5EBM5UVhgwb4np1eKUNbqEO
         EGIstuXXBP4oOgnKntxxFYpIZgEC9CHUyF7AkNVMjG84oVtPrus6xEUWE9aALp7t9f
         eRHlfl5jayU5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anatolij Gustschin <agust@denx.de>, Rob Herring <robh@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        benh@kernel.crashing.org, paulus@samba.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 45/50] powerpc/5200: dts: fix memory node unit name
Date:   Tue,  9 Nov 2021 17:20:58 -0500
Message-Id: <20211109222103.1234885-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 408b486b13dff..cd589539f313f 100644
--- a/arch/powerpc/boot/dts/charon.dts
+++ b/arch/powerpc/boot/dts/charon.dts
@@ -35,7 +35,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;	// 128MB
 	};
diff --git a/arch/powerpc/boot/dts/digsy_mtc.dts b/arch/powerpc/boot/dts/digsy_mtc.dts
index 0e5e9d3acf79f..19a14e62e65f4 100644
--- a/arch/powerpc/boot/dts/digsy_mtc.dts
+++ b/arch/powerpc/boot/dts/digsy_mtc.dts
@@ -16,7 +16,7 @@
 	model = "intercontrol,digsy-mtc";
 	compatible = "intercontrol,digsy-mtc";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x02000000>;	// 32MB
 	};
 
diff --git a/arch/powerpc/boot/dts/lite5200.dts b/arch/powerpc/boot/dts/lite5200.dts
index cb2782dd6132c..e7b194775d783 100644
--- a/arch/powerpc/boot/dts/lite5200.dts
+++ b/arch/powerpc/boot/dts/lite5200.dts
@@ -32,7 +32,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
diff --git a/arch/powerpc/boot/dts/lite5200b.dts b/arch/powerpc/boot/dts/lite5200b.dts
index 2b86c81f90485..547cbe726ff23 100644
--- a/arch/powerpc/boot/dts/lite5200b.dts
+++ b/arch/powerpc/boot/dts/lite5200b.dts
@@ -31,7 +31,7 @@
 		led4 { gpios = <&gpio_simple 2 1>; };
 	};
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x10000000>;	// 256MB
 	};
 
diff --git a/arch/powerpc/boot/dts/media5200.dts b/arch/powerpc/boot/dts/media5200.dts
index 61cae9dcddef4..f3188018faceb 100644
--- a/arch/powerpc/boot/dts/media5200.dts
+++ b/arch/powerpc/boot/dts/media5200.dts
@@ -32,7 +32,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;	// 128MB RAM
 	};
 
diff --git a/arch/powerpc/boot/dts/mpc5200b.dtsi b/arch/powerpc/boot/dts/mpc5200b.dtsi
index 648fe31795f49..8b796f3b11da7 100644
--- a/arch/powerpc/boot/dts/mpc5200b.dtsi
+++ b/arch/powerpc/boot/dts/mpc5200b.dtsi
@@ -33,7 +33,7 @@
 		};
 	};
 
-	memory: memory {
+	memory: memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
diff --git a/arch/powerpc/boot/dts/o2d.dts b/arch/powerpc/boot/dts/o2d.dts
index 24a46f65e5299..e0a8d3034417f 100644
--- a/arch/powerpc/boot/dts/o2d.dts
+++ b/arch/powerpc/boot/dts/o2d.dts
@@ -12,7 +12,7 @@
 	model = "ifm,o2d";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;  // 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o2d.dtsi b/arch/powerpc/boot/dts/o2d.dtsi
index 6661955a2be47..b55a9e5bd828c 100644
--- a/arch/powerpc/boot/dts/o2d.dtsi
+++ b/arch/powerpc/boot/dts/o2d.dtsi
@@ -19,7 +19,7 @@
 	model = "ifm,o2d";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o2dnt2.dts b/arch/powerpc/boot/dts/o2dnt2.dts
index eeba7f5507d5d..c2eedbd1f5fcb 100644
--- a/arch/powerpc/boot/dts/o2dnt2.dts
+++ b/arch/powerpc/boot/dts/o2dnt2.dts
@@ -12,7 +12,7 @@
 	model = "ifm,o2dnt2";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;  // 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/o3dnt.dts b/arch/powerpc/boot/dts/o3dnt.dts
index fd00396b0593e..e4c1bdd412716 100644
--- a/arch/powerpc/boot/dts/o3dnt.dts
+++ b/arch/powerpc/boot/dts/o3dnt.dts
@@ -12,7 +12,7 @@
 	model = "ifm,o3dnt";
 	compatible = "ifm,o2d";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x04000000>;  // 64MB
 	};
 
diff --git a/arch/powerpc/boot/dts/pcm032.dts b/arch/powerpc/boot/dts/pcm032.dts
index 780e13d99e7b8..1895bc95900cc 100644
--- a/arch/powerpc/boot/dts/pcm032.dts
+++ b/arch/powerpc/boot/dts/pcm032.dts
@@ -20,7 +20,7 @@
 	model = "phytec,pcm032";
 	compatible = "phytec,pcm032";
 
-	memory {
+	memory@0 {
 		reg = <0x00000000 0x08000000>;	// 128MB
 	};
 
diff --git a/arch/powerpc/boot/dts/tqm5200.dts b/arch/powerpc/boot/dts/tqm5200.dts
index 9ed0bc78967e1..5bb25a9e40a01 100644
--- a/arch/powerpc/boot/dts/tqm5200.dts
+++ b/arch/powerpc/boot/dts/tqm5200.dts
@@ -32,7 +32,7 @@
 		};
 	};
 
-	memory {
+	memory@0 {
 		device_type = "memory";
 		reg = <0x00000000 0x04000000>;	// 64MB
 	};
-- 
2.33.0

