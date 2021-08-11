Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCB93E9A21
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 22:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhHKU55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 16:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhHKU55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 16:57:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4400C0613D5
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 13:57:32 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k29so4894780wrd.7
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 13:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dNhY6rEB/uVahfdaM4U9VtiEqvClWKVV7DhngtZoag0=;
        b=KaZ/koqQS1vS40yGJNVN/UBPiXZtxvIGF+Ue5wdXTxr1xHQv3IqZ1Dr/Y1uSsZlRRb
         X4OEK5gY74809C4jA3nEka4kTvl0kheYC1HR5l9njEKk1/l5OF+VBHCPOkyvikF6zAy0
         A1tPu7TrBiSSvepG7ZC0YLKYbUpaydModsLaNNyBe+L6gIckuceXqP2A5GC6p9ae6mqI
         GS3LN2YcsPRiSxJ9HMnODXOlqOi7FXjAdQJj7kQxNXLJA1Cif2tgDlI2VfQSVehNLpWl
         M86QXCe83MC8n5Cb2l3HX8RJXi7rrviJTx0GaW12mCeFkPWhbg+T7qAPG2SeLWKy3sum
         f3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dNhY6rEB/uVahfdaM4U9VtiEqvClWKVV7DhngtZoag0=;
        b=EEpMBsUXnsFdGFH+ds37Z/IjR5u65hfq99+Gzn0/16iTwNVLzm0DtDbgsYGzfMqfPs
         gInzFceJBbTkFyUsOJGuj7NwBb+Cxvj2IK5ZpwFePq+6Yao3cald+1vdqfLFE0Zuv1aw
         rvfKucyiiMQWiDD6wd2aPMqk/1n8nKY1d4aLPAq6lHiE6L8iZsHWGVL4hJkFMBM9Tjyb
         MCb1cat3KO00qd8kkOy9E8phMOJnMFOlEeR+YeIJX8e10ItOmMw/YjcPZ1h+yJ+Ju30d
         ZgoQungCVjMw0RLrVyc/6n63e7VXOU1wO9HwGOq2gD9VTrwPBnDE6tJ2ah8TO8+uu46z
         pi7w==
X-Gm-Message-State: AOAM5300byGF2mvn/Jyn/yJcJ/AtSWmoHbJpPiBCH2R/cLsZblTdKNSD
        LZf6QDVYa5SZyVNmrA7WhxnseCjC2sxnsw==
X-Google-Smtp-Source: ABdhPJytR++rA6LrRmLagAvsdiHO35Ljuu7gQMNaQA8+obwDKUKA9DulrnIxOQqFtafkdAGUysdeRQ==
X-Received: by 2002:adf:a442:: with SMTP id e2mr366787wra.52.1628715451573;
        Wed, 11 Aug 2021 13:57:31 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id r129sm313647wmr.7.2021.08.11.13.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:57:30 -0700 (PDT)
Date:   Wed, 11 Aug 2021 21:57:29 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     aford173@gmail.com, geert+renesas@glider.be, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: dts: renesas: beacon: Fix USB ref
 clock references" failed to apply to 5.10-stable tree
Message-ID: <YRQ5uSbybJgxaQm7@debian>
References: <1626979705124214@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oFzO5U3W3p1I7zo1"
Content-Disposition: inline
In-Reply-To: <1626979705124214@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oFzO5U3W3p1I7zo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, Jul 22, 2021 at 08:48:25PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

There was another failed mail for 56bc54496f5d ("arm64: dts: renesas:
beacon: Fix USB extal reference"). So, that one and this one together
with e1076ce07b77 ("arm64: dts: renesas: rzg2: Add usb2_clksel to
RZ/G2 M/N/H") which is needed for these two to work.

--
Regards
Sudip

--oFzO5U3W3p1I7zo1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-arm64-dts-renesas-rzg2-Add-usb2_clksel-to-RZ-G2-M-N-.patch"

From df0f82caf1b0c8dbb9178bd88743d0d18d483d70 Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Mon, 28 Dec 2020 14:22:21 -0600
Subject: [PATCH 1/3] arm64: dts: renesas: rzg2: Add usb2_clksel to RZ/G2 M/N/H

commit e1076ce07b7736aed269c5d8154f2442970d9137 upstream

Per the reference manual for the RZ/G Series, 2nd Generation,
the RZ/G2M, RZ/G2N, and RZ/G2H have a bit that can be set to
choose between a crystal oscillator and an external oscillator.

Because only boards that need this should enable it, it's marked
as disabled by default for backwards compatibility with existing
boards.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20201228202221.2327468-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi | 15 +++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi | 15 +++++++++++++++
 arch/arm64/boot/dts/renesas/r8a774e1.dtsi | 15 +++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
index db091fa75115..c58a0846db50 100644
--- a/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774a1.dtsi
@@ -836,6 +836,21 @@ hsusb: usb@e6590000 {
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774a1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774A1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774a1-usb-dmac",
 				     "renesas,usb-dmac";
diff --git a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
index 39a1a26ffb54..9ebf6e58ba31 100644
--- a/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774b1.dtsi
@@ -709,6 +709,21 @@ hsusb: usb@e6590000 {
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774b1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774B1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774b1-usb-dmac",
 				     "renesas,usb-dmac";
diff --git a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
index c29643442e91..708258696b4f 100644
--- a/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774e1.dtsi
@@ -890,6 +890,21 @@ hsusb: usb@e6590000 {
 			status = "disabled";
 		};
 
+		usb2_clksel: clock-controller@e6590630 {
+			compatible = "renesas,r8a774e1-rcar-usb2-clock-sel",
+				     "renesas,rcar-gen3-usb2-clock-sel";
+			reg = <0 0xe6590630 0 0x02>;
+			clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+				 <&usb_extal_clk>, <&usb3s0_clk>;
+			clock-names = "ehci_ohci", "hs-usb-if",
+				      "usb_extal", "usb_xtal";
+			#clock-cells = <0>;
+			power-domains = <&sysc R8A774E1_PD_ALWAYS_ON>;
+			resets = <&cpg 703>, <&cpg 704>;
+			reset-names = "ehci_ohci", "hs-usb-if";
+			status = "disabled";
+		};
+
 		usb_dmac0: dma-controller@e65a0000 {
 			compatible = "renesas,r8a774e1-usb-dmac",
 				     "renesas,usb-dmac";
-- 
2.30.2


--oFzO5U3W3p1I7zo1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-arm64-dts-renesas-beacon-Fix-USB-extal-reference.patch"

From 0c3801de5390e3243907854b460644087b94267f Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Thu, 13 May 2021 06:46:15 -0500
Subject: [PATCH 2/3] arm64: dts: renesas: beacon: Fix USB extal reference

commit 56bc54496f5d6bc638127bfc9df3742cbf0039e7 upstream

The USB extal clock reference isn't associated to a crystal, it's
associated to a programmable clock, so remove the extal reference,
add the usb2_clksel.  Since usb_extal is referenced by the versaclock,
reference it here so the usb2_clksel can get the proper clock speed
of 50MHz.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 289cf711307d..e3773b05c403 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -295,8 +295,10 @@ &sdhi3 {
 	status = "okay";
 };
 
-&usb_extal_clk {
-	clock-frequency = <50000000>;
+&usb2_clksel {
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+		  <&versaclock5 3>, <&usb3s0_clk>;
+	status = "okay";
 };
 
 &usb3s0_clk {
-- 
2.30.2


--oFzO5U3W3p1I7zo1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-arm64-dts-renesas-beacon-Fix-USB-ref-clock-reference.patch"

From f3e18e9eec20eced47845842d143b1fdb182600a Mon Sep 17 00:00:00 2001
From: Adam Ford <aford173@gmail.com>
Date: Thu, 13 May 2021 06:46:16 -0500
Subject: [PATCH 3/3] arm64: dts: renesas: beacon: Fix USB ref clock references

commit ebc666f39ff67a01e748c34d670ddf05a9e45220 upstream

The RZ/G2 boards expect there to be an external clock reference for
USB2 EHCI controllers.  For the Beacon boards, this reference clock
is controlled by a programmable versaclock.  Because the RZ/G2
family has a special clock driver when using an external clock,
the third clock reference in the EHCI node needs to point to this
special clock, called usb2_clksel.

Since the usb2_clksel does not keep the usb_extal clock enabled,
the 4th clock entry for the EHCI nodes needs to reference it to
keep the clock running and make USB functional.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-2-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 597388f87127..bc4bb5dd8bae 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -271,12 +271,12 @@ &du_out_rgb {
 &ehci0 {
 	dr_mode = "otg";
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &ehci1 {
 	status = "okay";
-	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>;
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>, <&usb2_clksel>, <&versaclock5 3>;
 };
 
 &hdmi0 {
-- 
2.30.2


--oFzO5U3W3p1I7zo1--
