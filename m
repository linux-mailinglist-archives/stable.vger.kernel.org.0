Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAF517FA36
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgCJNDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:03:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730616AbgCJNDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E51AE2468D;
        Tue, 10 Mar 2020 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845415;
        bh=HSl3dLx2M5ysKWZ4wfyF7RTrJDrkrEhpjXI7JvzD0Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeodUGU3xyKLPD0MNCojG3nW/cgLl7ARpjmTatzi4ytmbuBEGnDBVH15oSYr0v+kz
         wP8wtx6IJ0eqTc7tBsOqCIYxijlMXwXtQ7C/v4eeewaXiKxL3O31W6CQjuieHs1GG/
         Us18XNuXxtGf+faII5ORWYYt5miNxi13Sz94Vlog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanchayan Maity <maitysanchayan@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: [PATCH 5.5 175/189] ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties
Date:   Tue, 10 Mar 2020 13:40:12 +0100
Message-Id: <20200310123657.443556491@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit bcbf53a0dab50980867476994f6079c1ec5bb3a3 upstream.

The sram-node compatible properties have mistakingly combined the
model-specific string with the generic "mtd-ram" string.

Note that neither "cy7c1019dv33-10zsxi, mtd-ram" or
"cy7c1019dv33-10zsxi" are used by any in-kernel driver and they are
not present in any binding.

The physmap driver will however bind to platform devices that specify
"mtd-ram".

Fixes: fc48e76489fd ("ARM: dts: imx6: Add support for Toradex Colibri iMX6 module")
Cc: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/imx6dl-colibri-eval-v3.dts
@@ -275,7 +275,7 @@
 
 	/* SRAM on Colibri nEXT_CS0 */
 	sram@0,0 {
-		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
+		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
 		reg = <0 0 0x00010000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -286,7 +286,7 @@
 
 	/* SRAM on Colibri nEXT_CS1 */
 	sram@1,0 {
-		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
+		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
 		reg = <1 0 0x00010000>;
 		#address-cells = <1>;
 		#size-cells = <1>;


