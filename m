Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A127049172F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345063AbiARCiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:38:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46150 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiARCgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:36:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AA31B81250;
        Tue, 18 Jan 2022 02:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ACAC36AEB;
        Tue, 18 Jan 2022 02:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473370;
        bh=WPGA4wX77LsCu5PS/VvihOLuWHh9TstN6MR8pI3A1io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnctaMn5WEVjyKreiB0Kao3DCy9qEn9o7N07HX0IvClH3VP6WggGXC3P+8dgdmFYx
         1TlQsocXWMHe5GRmMdQRd9lQqzgbDubAZR2RRFS+PT6BwCWwTDrEnXbuM7Ehf5tAwr
         BHs2bNWAHuZ6Q3RMI8+f0SGmhHL7OlAgC1qwhbv4ru3nG3OYx9hKKYWrCw1+GaZd3v
         c/nh++ATTRnGXd+Gkje0hWL952iS+aODkR2PEiKLD+M5NRLWwHIBogCV3/ZkaA5N5P
         Hmw62WXko32eZC4rLqWPxwH5YOCvyyWagzqA8UFLTCSumWxkQpDMtfpyv9gCGXBhyH
         0VkMWQ9yZwinQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, magnus.damm@gmail.com,
        robh+dt@kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 089/188] arm64: dts: renesas: Fix thermal bindings
Date:   Mon, 17 Jan 2022 21:30:13 -0500
Message-Id: <20220118023152.1948105-89-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit 82ce79391d0ec25ec8aaae3c0617b71048ff0836 ]

The binding node names for the thermal zones are not successfully
validated by the dt-schemas.

Fix the validation by changing from sensor-thermalN or thermal-sensor-N
to sensorN-thermal.  Provide node labels of the form sensorN_thermal to
ensure consistency with the other platform implementations.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20211104224033.3997504-1-kieran.bingham+renesas@ideasonboard.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a77951.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a77960.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a77961.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a77965.dtsi |  6 +++---
 arch/arm64/boot/dts/renesas/r8a77980.dtsi |  4 ++--
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 10 +++++-----
 9 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index 6f4fffacfca21..e70aa5a087402 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -2784,7 +2784,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2799,7 +2799,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -2814,7 +2814,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 0f7bdfc90a0dc..6c5694fa66900 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -2629,7 +2629,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2644,7 +2644,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -2659,7 +2659,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index 379a1300272ba..62209ab6deb9a 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -2904,7 +2904,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2919,7 +2919,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -2934,7 +2934,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77951.dtsi b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
index 1768a3e6bb8da..193d81be40fc4 100644
--- a/arch/arm64/boot/dts/renesas/r8a77951.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77951.dtsi
@@ -3375,7 +3375,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -3390,7 +3390,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -3405,7 +3405,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77960.dtsi b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
index 2bd8169735d35..b526e4f0ee6a8 100644
--- a/arch/arm64/boot/dts/renesas/r8a77960.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77960.dtsi
@@ -2972,7 +2972,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2987,7 +2987,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -3002,7 +3002,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77961.dtsi b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
index 041473aa5cd09..21fc95397c3c2 100644
--- a/arch/arm64/boot/dts/renesas/r8a77961.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77961.dtsi
@@ -2719,7 +2719,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2734,7 +2734,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -2749,7 +2749,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index 08df75606430b..f9679a4dd85fa 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -2784,7 +2784,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -2799,7 +2799,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -2814,7 +2814,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
diff --git a/arch/arm64/boot/dts/renesas/r8a77980.dtsi b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
index 6347d15e66b64..21fe602bd25af 100644
--- a/arch/arm64/boot/dts/renesas/r8a77980.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77980.dtsi
@@ -1580,7 +1580,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		thermal-sensor-1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -1599,7 +1599,7 @@ sensor1-critical {
 			};
 		};
 
-		thermal-sensor-2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index 631d520cebee5..26899fb768a73 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -1149,7 +1149,7 @@ prr: chipid@fff00044 {
 	};
 
 	thermal-zones {
-		sensor_thermal1: sensor-thermal1 {
+		sensor1_thermal: sensor1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 0>;
@@ -1163,7 +1163,7 @@ sensor1_crit: sensor1-crit {
 			};
 		};
 
-		sensor_thermal2: sensor-thermal2 {
+		sensor2_thermal: sensor2-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 1>;
@@ -1177,7 +1177,7 @@ sensor2_crit: sensor2-crit {
 			};
 		};
 
-		sensor_thermal3: sensor-thermal3 {
+		sensor3_thermal: sensor3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 2>;
@@ -1191,7 +1191,7 @@ sensor3_crit: sensor3-crit {
 			};
 		};
 
-		sensor_thermal4: sensor-thermal4 {
+		sensor4_thermal: sensor4-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 3>;
@@ -1205,7 +1205,7 @@ sensor4_crit: sensor4-crit {
 			};
 		};
 
-		sensor_thermal5: sensor-thermal5 {
+		sensor5_thermal: sensor5-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 			thermal-sensors = <&tsc 4>;
-- 
2.34.1

