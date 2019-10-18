Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90929DD021
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 22:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443449AbfJRU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 16:27:00 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:8457 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443431AbfJRU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 16:26:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571430351;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=pMHbBt0U2BHK2lkSOiY6byStPby4fYtcUEpZ/uCeAnQ=;
        b=JL8N1+221BYSCMHTrtTxlMZM90hwf/SSMonq6IgrmTGJsGs1BCkbjIz48z1livvf16
        dPYqRM305dYW44jLdWz33t1zq8ScRL2L+/2g/lkOI3enk85zSYmjyLnilmfPiCYNYMX/
        5DKg5WMmwWH2QZWzHH8MejIxZIFV5CzU5VzpUwlRKP3dTud80jZOk+qUI2FYcYU4Z4VF
        TdDk6lPxdcbbcLJlY+9JB5MteGXIaz741SIAag4NK4+6NDScujOCnVieQFNfRgWSyey0
        SjligFcb67Z1GPPldxVteX+UNjZ3/h4DI1TPGgglCwfUs2Srt0glsRaQg2hz1w3XJ+4C
        mP/A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6F3CFF60="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9IKPYDUp
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 18 Oct 2019 22:25:34 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH 3/9] DTS: ARM: pandora-common: define wl1251 as child node of mmc3
Date:   Fri, 18 Oct 2019 22:25:24 +0200
Message-Id: <58c57f194e35b2a055a58081a0ea0d3ffcd07b6d.1571430329.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571430329.git.hns@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since v4.7 the dma initialization requires that there is a
device tree property for "rx" and "tx" channels which is
not provided by the pdata-quirks initialization.

By conversion of the mmc3 setup to device tree this will
finally allows to remove the OpenPandora wlan specific omap3
data-quirks.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.7.0
---
 arch/arm/boot/dts/omap3-pandora-common.dtsi | 37 +++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-pandora-common.dtsi b/arch/arm/boot/dts/omap3-pandora-common.dtsi
index ec5891718ae6..c595b3eb314d 100644
--- a/arch/arm/boot/dts/omap3-pandora-common.dtsi
+++ b/arch/arm/boot/dts/omap3-pandora-common.dtsi
@@ -226,6 +226,18 @@
 		gpio = <&gpio6 4 GPIO_ACTIVE_HIGH>;	/* GPIO_164 */
 	};
 
+	/* wl1251 wifi+bt module */
+	wlan_en: fixed-regulator-wg7210_en {
+		compatible = "regulator-fixed";
+		regulator-name = "vwlan";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		startup-delay-us = <50000>;
+		regulator-always-on;
+		enable-active-high;
+		gpio = <&gpio1 23 GPIO_ACTIVE_HIGH>;
+	};
+
 	/* wg7210 (wifi+bt module) 32k clock buffer */
 	wg7210_32k: fixed-regulator-wg7210_32k {
 		compatible = "regulator-fixed";
@@ -522,9 +534,30 @@
 	/*wp-gpios = <&gpio4 31 GPIO_ACTIVE_HIGH>;*/	/* GPIO_127 */
 };
 
-/* mmc3 is probed using pdata-quirks to pass wl1251 card data */
 &mmc3 {
-	status = "disabled";
+	vmmc-supply = <&wlan_en>;
+
+	bus-width = <4>;
+	non-removable;
+	ti,non-removable;
+	cap-power-off-card;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	wlan: wl1251@1 {
+		compatible = "ti,wl1251";
+
+		reg = <1>;
+
+		interrupt-parent = <&gpio1>;
+		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
+
+		ti,wl1251-has-eeprom;
+	};
 };
 
 /* bluetooth*/
-- 
2.19.1

