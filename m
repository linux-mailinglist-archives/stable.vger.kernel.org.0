Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364A21333BE
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgAGVDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbgAGVDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0ABD214D8;
        Tue,  7 Jan 2020 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431022;
        bh=MuIb+sqGhjVYAmssrn+7TlscdFUuD8dmFEMaZbKcdMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VO8FFRK1vKkGsUmV7jeJ6pxmgM1GsAxtx9jrp1QsZnE9j4AQtRQJJC59L+6P7Lm5o
         7Ol6Lh2MfoCUCwLNasCRNGS477vJBCVuCaVS76VtRC0GvRfyABH1yt7OVbr5yiK2Pf
         2TruW9pXAkduoQiGF7TaGQd3FsQ1eXKarFWByL9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 166/191] dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example
Date:   Tue,  7 Jan 2020 21:54:46 +0100
Message-Id: <20200107205341.865549681@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 830dbce7c76ea529decac7d23b808c1e7da3d891 upstream.

The documented compatible value for R-Car H3 is
"renesas,r8a7795-rcar-usb2-clock-sel", not
"renesas,r8a77950-rcar-usb2-clock-sel".

Fixes: 311accb64570db45 ("clk: renesas: rcar-usb2-clock-sel: Add R-Car USB 2.0 clock selector PHY")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20191016145650.30003-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.txt
+++ b/Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.txt
@@ -46,7 +46,7 @@ Required properties:
 Example (R-Car H3):
 
 	usb2_clksel: clock-controller@e6590630 {
-		compatible = "renesas,r8a77950-rcar-usb2-clock-sel",
+		compatible = "renesas,r8a7795-rcar-usb2-clock-sel",
 			     "renesas,rcar-gen3-usb2-clock-sel";
 		reg = <0 0xe6590630 0 0x02>;
 		clocks = <&cpg CPG_MOD 703>, <&usb_extal>, <&usb_xtal>;


