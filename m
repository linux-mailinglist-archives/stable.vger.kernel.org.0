Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9CDACF8F
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfIHPqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 11:46:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:41183 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfIHPqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 11:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1567957589;
        bh=SFrQS2AE6buvSq2XcNrsQJ4HnzDculs7JE6sErBescQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=JO+8z0/XnByWrmxPvyOb1faBCxMcF0FUA8/pZfKP3fW7SQCTHe5fJA2DtFfpXT35m
         KCyXXNWlYDVumbFAZc/s/9B6KlHxzW/8psL0tBwhKDzzOQNnGUvZF6NVVwDZ5urx2Y
         gfca2qqRqCRnzu3dluHaw1SVQg9KjFw2PV/6uNy4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.90]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7sDq-1i39de3QNm-0050ua; Sun, 08
 Sep 2019 17:46:28 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        boris.brezillon@bootlin.com
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, Stefan Wahren <wahrenst@gmx.net>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware."
Date:   Sun,  8 Sep 2019 17:44:53 +0200
Message-Id: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:8SS2m039FZNDDpUlAdXTSHBal6u5+ujaEtxV4T1c3m87WsiWPbb
 nyfhBWj3eZScVg5xk3v6P65yl3Qcc+sNzVQNDYFzbWY9z61kGwjaU9rkHg7xTLUVfOd5qLt
 4iZ5YPEPVod6zIFHiNBxkUea52dqThXP8AhrTbRAEd6R0wJh/otCLINEOIn24Kbj0bmbT1d
 LIEB9T6Ww3qBlBezldbtA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tpXs0A6dc1I=:TjCpWo0lunQ5VVesCO+nDv
 TwoByk8SZxK0ecUDsG9NCVLvB6f0IhUQCXrP3+5q8YiurBxgVbDlDALbrUh+2gIlNGWTeFHko
 f2KAXvtmDhHuT06VVJZh3emH46wrrcYFYxZfSvu+kBVwqJP/49Iy2L2oan/NYU2kyRRh+Lek4
 h29rE+t2IytoTdBVt2rp6NxE83M8pNmYbof7iVORrglJxZhkrB+EN4G2rmOFnKkZvFiFukjKx
 kmCMsfa8kBRw4gfaF5PLfpbTSo1D+tkdBXA0qML546d6o+w+8mJeL5t02kg8nRdHF8rJOcI0G
 E+bnva7qsZlikM/aoFk4eNuKNpQv2K36rJF86weM5LDX16iHXzNaDiKQIhh8V+DvUJuuH22bn
 mSTlqZIeKLMGf94J14RhrXDNfM8heb7XtFnPv6vEKlR7wdU8PYcH67u5fjDYe3ZEK5M2yZEef
 TfxO4ZGtzGXX2ojYYCXrURQDNXrKsci6cf6lEQrEe+H9fk1fOQl1247TIEXiVpjcZ4qjYIUN9
 TO0IxiaAmMb7tdiQbN5ABhUyjCZpmB9hEY+isbItHgvzTKqBm6W2yTUf/ZiUQtS17btRoXUUS
 VjbiAGYaP2BM5n2/gxO2xwLnId4Ksb5fu9hBWDYDwF91QJty+wXzHFix9Hb/Em1X9jfrooAkt
 bhmrit8nGIPB/vbD+S9AH/LyQKkd4FqNthNiqpO9d2MIyrJSkSQVzxRVn9N+MvxDDJRKzV5YH
 /kAgizDCBIXqK9pkzBUHyT+SkUo0RCdLrRhxGwAwg117458SF91hv8V7l4YKjKMkEb96uuo7z
 MVdekbIDR1BH9oBeWL1YsoVGSOPoHVGqQXjCZ0c4uW2GQCIwkwLEQKGFi3MZUziD26UV7km2f
 4XYelyGN2wCZmNhND/TL3YFGUDmaef2s/IxGQWSqIu/O65EQ1QcWELOfiDwSVbsiw32LQ33oi
 E25MqHiopj3KFFn9ZxcNKtZiwzeh2TsG1dsk1QRBUDR8g+J9Hgz8rm9tXMkj71o6Y5uHWNAvg
 v53p8sqnqUnOVagoFA9Y/AIpQXEtMCiWFHWVtegcSSHto2u/YNmq/K9HL6s25dM/9id7A1z7R
 z5DMn5S9RaucG+iCqJdqeOQAsmIub4pdXj0lF7/fDPHlgb4Rn7QAGqTh7ldc/Y/DquJfg1DGs
 +KrN77tt3qIWOlTerxb2HlpsJTHmw4xOP/c/tNiWiSO86J+DXIy0rfminkkelY3vtL1c4=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since release of the new BCM2835 PM driver there has been several reports
of V3D probing issues. This is caused by timeouts during powering-up the
GRAFX PM domain:

  bcm2835-power: Timeout waiting for grafx power OK

I was able to reproduce this reliable on my Raspberry Pi 3B+ after setting
force_turbo=3D1 in the firmware configuration. Since there are no issues
using the firmware PM driver with the same setup, there must be an issue
in the BCM2835 PM driver.

Unfortunately there hasn't been much progress in identifying the root caus=
e
since June (mostly in the lack of documentation), so i decided to switch
back until the issue in the BCM2835 PM driver is fixed.

Link: https://github.com/raspberrypi/linux/issues/3046
Fixes: e1dc2b2e1bef (" ARM: bcm283x: Switch V3D over to using the PM drive=
r instead of firmware.")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 arch/arm/boot/dts/bcm2835-rpi.dtsi | 4 ++++
 arch/arm/boot/dts/bcm283x.dtsi     | 4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm283=
5-rpi.dtsi
index 6c6a7f6..b909e3b 100644
=2D-- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -67,6 +67,10 @@
 	power-domains =3D <&power RPI_POWER_DOMAIN_USB>;
 };

+&v3d {
+	power-domains =3D <&power RPI_POWER_DOMAIN_V3D>;
+};
+
 &vec {
 	power-domains =3D <&power RPI_POWER_DOMAIN_VEC>;
 	status =3D "okay";
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dt=
si
index 2d191fc..b238567 100644
=2D-- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -3,7 +3,6 @@
 #include <dt-bindings/clock/bcm2835-aux.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
-#include <dt-bindings/soc/bcm2835-pm.h>

 /* firmware-provided startup stubs live here, where the secondary CPUs ar=
e
  * spinning.
@@ -121,7 +120,7 @@
 			#interrupt-cells =3D <2>;
 		};

-		pm: watchdog@7e100000 {
+		watchdog@7e100000 {
 			compatible =3D "brcm,bcm2835-pm", "brcm,bcm2835-pm-wdt";
 			#power-domain-cells =3D <1>;
 			#reset-cells =3D <1>;
@@ -641,7 +640,6 @@
 			compatible =3D "brcm,bcm2835-v3d";
 			reg =3D <0x7ec00000 0x1000>;
 			interrupts =3D <1 10>;
-			power-domains =3D <&pm BCM2835_POWER_DOMAIN_GRAFX_V3D>;
 		};

 		vc4: gpu {
=2D-
2.7.4

