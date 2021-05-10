Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B23D3783A3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhEJKqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232853AbhEJKom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09CBB61464;
        Mon, 10 May 2021 10:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642835;
        bh=L8Mq9F8NhmcMlt+HJ8dj+qsv/EiXcUScL+urgJmpI1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSsgi0CKy3sapyJzFAz4l6Wc4N5jhIHmncIlWRtWzBORXvfmIg9QztfNSx+lXqIwr
         kP9mHj8hCgy9DIlkbm05xyUoBv+aH3HIYUnwgWbdTiPwxflpUrfbfCX9cxDYsZfLW/
         /nI1AwAqyXHK16Yz3HeFH/ErAh5BZ8AYKOw7hY48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/299] ARM: dts: BCM5301X: fix "reg" formatting in /memory node
Date:   Mon, 10 May 2021 12:17:48 +0200
Message-Id: <20210510102007.258863825@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 43986f38818278bb71a7fef6de689637bb734afe ]

This fixes warnings/errors like:
arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml: /: memory@0:reg:0: [0, 134217728, 2281701376, 402653184] is too long
        From schema: /lib/python3.6/site-packages/dtschema/schemas/reg.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts        | 4 ++--
 arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts        | 4 ++--
 arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts  | 4 ++--
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        | 4 ++--
 arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts     | 4 ++--
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts      | 4 ++--
 arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts        | 4 ++--
 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts | 4 ++--
 arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts  | 4 ++--
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts        | 4 ++--
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts  | 4 ++--
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts       | 4 ++--
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts        | 4 ++--
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts        | 4 ++--
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts    | 4 ++--
 arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts      | 4 ++--
 arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts   | 4 ++--
 arch/arm/boot/dts/bcm47094-netgear-r8500.dts       | 4 ++--
 arch/arm/boot/dts/bcm47094-phicomm-k3.dts          | 4 ++--
 23 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts b/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts
index 6a96655d8626..8ed403767540 100644
--- a/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts
+++ b/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts b/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts
index 3b0029e61b4c..667b118ba4ee 100644
--- a/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts
+++ b/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts b/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts
index 90f57bad6b24..ff31ce45831a 100644
--- a/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts
+++ b/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	spi {
diff --git a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
index fed75e6ab58c..61c7b137607e 100644
--- a/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
+++ b/arch/arm/boot/dts/bcm4708-netgear-r6250.dts
@@ -22,8 +22,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts b/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts
index 79542e18915c..4c60eda296d9 100644
--- a/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts
+++ b/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
index abd35a518046..7d46561fca3c 100644
--- a/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
+++ b/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts b/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts
index c29950b43a95..0e273c598732 100644
--- a/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts
+++ b/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts b/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
index 4dcec6865469..083ec4036bd7 100644
--- a/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
+++ b/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	spi {
diff --git a/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts b/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts
index 0e349e39f608..8b1a05a0f1a1 100644
--- a/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts
+++ b/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	spi {
diff --git a/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts b/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
index 8f1e565c3db4..6c6bb7b17d27 100644
--- a/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
+++ b/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts
@@ -21,8 +21,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts b/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
index ce888b1835d1..d29e7f80ea6a 100644
--- a/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
+++ b/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts
@@ -21,8 +21,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts b/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
index ed8619b54d69..38fbefdf2e4e 100644
--- a/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
+++ b/arch/arm/boot/dts/bcm4709-linksys-ea9200.dts
@@ -18,8 +18,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	gpio-keys {
diff --git a/arch/arm/boot/dts/bcm4709-netgear-r7000.dts b/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
index 1f87993eae1d..7989a53597d4 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r7000.dts
@@ -21,8 +21,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
index 6c6199a53d09..87b655be674c 100644
--- a/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
+++ b/arch/arm/boot/dts/bcm4709-netgear-r8000.dts
@@ -32,8 +32,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
index 911c65fbf251..e635a15041dd 100644
--- a/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
+++ b/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts
@@ -21,8 +21,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	nand: nand@18028000 {
diff --git a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
index 0faae8950375..36d63beba8cd 100644
--- a/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
+++ b/arch/arm/boot/dts/bcm47094-linksys-panamera.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	gpio-keys {
diff --git a/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts b/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
index 50f7cd08cfbb..a6dc99955e19 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts b/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
index bcc420f85b56..ff98837bc0db 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
index 9ae815ddbb4b..2666195b6ffe 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
@@ -18,8 +18,8 @@
 
 	memory {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
index a21b2d185596..9f798025748b 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x08000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x08000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
index 4d5c5aa7dc42..c8dfa4c58d2f 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-netgear-r8500.dts b/arch/arm/boot/dts/bcm47094-netgear-r8500.dts
index f42a1703f4ab..42097a4c2659 100644
--- a/arch/arm/boot/dts/bcm47094-netgear-r8500.dts
+++ b/arch/arm/boot/dts/bcm47094-netgear-r8500.dts
@@ -18,8 +18,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	leds {
diff --git a/arch/arm/boot/dts/bcm47094-phicomm-k3.dts b/arch/arm/boot/dts/bcm47094-phicomm-k3.dts
index ac3a4483dcb3..a2566ad4619c 100644
--- a/arch/arm/boot/dts/bcm47094-phicomm-k3.dts
+++ b/arch/arm/boot/dts/bcm47094-phicomm-k3.dts
@@ -15,8 +15,8 @@
 
 	memory@0 {
 		device_type = "memory";
-		reg = <0x00000000 0x08000000
-		       0x88000000 0x18000000>;
+		reg = <0x00000000 0x08000000>,
+		      <0x88000000 0x18000000>;
 	};
 
 	gpio-keys {
-- 
2.30.2



