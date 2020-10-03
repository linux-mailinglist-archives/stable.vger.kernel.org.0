Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FB728247E
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgJCOQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 10:16:06 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:17477 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgJCOQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 10:16:05 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2020 10:16:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1601734563;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=McyS+Bgb2m8s8GrMk1FFTfyKbA2jen/QdtExTM2Ir3Y=;
        b=ny9Od2Q3z3oub5FGrMunr/Pg++Oij1+pu5kPHZ8mrfRL+PmSWbczBiSbRJe8H/oDCS
        TdpFYf0ZeqbJ8pUDjGKuCb+Ch3NGakS7826LiouiTGl8eaEhH5BkgVkHNujBgk+B51NJ
        fEoUyBAEBm2CLlhNJcIz0GBgxXZkzXs923GUzSY8sYLWm44gbkodvBfgFkG0Jv05dbdK
        jXW/180rHMCr89EbfrFHwi6yi1md6XPGwrarzLDhFNw/uzunRjv+4Dq6Chr45OD6ePeJ
        xOUO7nQ+FNp6ELllpKJu4twNkvi4LaiIxAz38pq/T1Ygk/DTuKaFSsyfb2CEIT1c+tFN
        bxew==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pDzZw9i90="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id 3005f6w93EA23C3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 3 Oct 2020 16:10:02 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES
Date:   Sat,  3 Oct 2020 16:10:00 +0200
Message-Id: <b4ce58e4350e460d544ee25938428b363c157496.1601734200.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601734200.git.hns@goldelico.com>
References: <cover.1601734200.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The pinmux control register offset passed to OMAP4_IOPAD is odd.

Fixes: ab9a13665e7c ("ARM: dts: pandaboard: add gpio user button")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap4-panda-es.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index cfa85aa3da085e..6afa8fd7c412de 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -46,7 +46,7 @@ OMAP4_IOPAD(0x0f6, PIN_OUTPUT | MUX_MODE3)	/* gpio_110 */
 
 	button_pins: pinmux_button_pins {
 		pinctrl-single,pins = <
-			OMAP4_IOPAD(0x11b, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
+			OMAP4_IOPAD(0x0fc, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
 		>;
 	};
 };
-- 
2.26.2

