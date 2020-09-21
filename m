Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34226272DD2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgIUQn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgIUQn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59F523976;
        Mon, 21 Sep 2020 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706605;
        bh=8levo4MoopQaue4g/FT6w+WjBnkfLjjUK2zGVSjvYug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mlr4X4NYDf1ncO+uleAnLY8Se1NxFXj4ll0S+nveMwBz/JbhbuhE1/9JDIp26mJZ3
         tzwOaTFum2T1BIKsUrKfBGOl/A3Ld+q9sABchcbS+lDiG3Rjz6IGJcZ80dKEc9K1Fi
         PJxF/2Oo/vqzmbfIFmtTIEtBOm1KsYmyREEpklOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.8 002/118] dt-bindings: spi: Fix spi-bcm-qspi compatible ordering
Date:   Mon, 21 Sep 2020 18:26:54 +0200
Message-Id: <20200921162036.451956243@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit fcd2e4b9ca20faf6de959f67df5b454a5b055c56 upstream.

The binding is currently incorrectly defining the compatible strings
from least specifice to most specific instead of the converse. Re-order
them from most specific (left) to least specific (right) and fix the
examples as well.

Fixes: 5fc78f4c842a ("spi: Broadcom BRCMSTB, NSP, NS2 SoC bindings")
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.txt |   16 ++++++------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.txt
+++ b/Documentation/devicetree/bindings/spi/brcm,spi-bcm-qspi.txt
@@ -23,8 +23,8 @@ Required properties:
 
 - compatible:
     Must be one of :
-    "brcm,spi-bcm-qspi", "brcm,spi-brcmstb-qspi" : MSPI+BSPI on BRCMSTB SoCs
-    "brcm,spi-bcm-qspi", "brcm,spi-brcmstb-mspi" : Second Instance of MSPI
+    "brcm,spi-brcmstb-qspi", "brcm,spi-bcm-qspi" : MSPI+BSPI on BRCMSTB SoCs
+    "brcm,spi-brcmstb-mspi", "brcm,spi-bcm-qspi" : Second Instance of MSPI
 						   BRCMSTB  SoCs
     "brcm,spi-bcm7425-qspi", "brcm,spi-bcm-qspi", "brcm,spi-brcmstb-mspi" : Second Instance of MSPI
     			     			  			    BRCMSTB  SoCs
@@ -36,8 +36,8 @@ Required properties:
     			     			  			    BRCMSTB  SoCs
     "brcm,spi-bcm7278-qspi", "brcm,spi-bcm-qspi", "brcm,spi-brcmstb-mspi" : Second Instance of MSPI
     			     			  			    BRCMSTB  SoCs
-    "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi"     : MSPI+BSPI on Cygnus, NSP
-    "brcm,spi-bcm-qspi", "brcm,spi-ns2-qspi"     : NS2 SoCs
+    "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi"     : MSPI+BSPI on Cygnus, NSP
+    "brcm,spi-ns2-qspi", "brcm,spi-bcm-qspi"     : NS2 SoCs
 
 - reg:
     Define the bases and ranges of the associated I/O address spaces.
@@ -86,7 +86,7 @@ BRCMSTB SoC Example:
     spi@f03e3400 {
 		#address-cells = <0x1>;
 		#size-cells = <0x0>;
-		compatible = "brcm,spi-brcmstb-qspi", "brcm,spi-brcmstb-qspi";
+		compatible = "brcm,spi-brcmstb-qspi", "brcm,spi-bcm-qspi";
 		reg = <0xf03e0920 0x4 0xf03e3400 0x188 0xf03e3200 0x50>;
 		reg-names = "cs_reg", "mspi", "bspi";
 		interrupts = <0x6 0x5 0x4 0x3 0x2 0x1 0x0>;
@@ -149,7 +149,7 @@ BRCMSTB SoC Example:
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clocks = <&upg_fixed>;
-		compatible = "brcm,spi-brcmstb-qspi", "brcm,spi-brcmstb-mspi";
+		compatible = "brcm,spi-brcmstb-mspi", "brcm,spi-bcm-qspi";
 		reg = <0xf0416000 0x180>;
 		reg-names = "mspi";
 		interrupts = <0x14>;
@@ -160,7 +160,7 @@ BRCMSTB SoC Example:
 iProc SoC Example:
 
     qspi: spi@18027200 {
-	compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
+	compatible = "brcm,spi-nsp-qspi", "brcm,spi-bcm-qspi";
 	reg = <0x18027200 0x184>,
 	      <0x18027000 0x124>,
 	      <0x1811c408 0x004>,
@@ -191,7 +191,7 @@ iProc SoC Example:
  NS2 SoC Example:
 
 	       qspi: spi@66470200 {
-		       compatible = "brcm,spi-bcm-qspi", "brcm,spi-ns2-qspi";
+		       compatible = "brcm,spi-ns2-qspi", "brcm,spi-bcm-qspi";
 		       reg = <0x66470200 0x184>,
 			     <0x66470000 0x124>,
 			     <0x67017408 0x004>,


