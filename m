Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9E17FC14
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgCJNS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbgCJNKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:10:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B78320409;
        Tue, 10 Mar 2020 13:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845845;
        bh=Xsc8LvYZIeFd8bE6v1ZDxoI41P161LSVCjfpgOa/g1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdJHVHWMB5jexepJW7SAcUFcxB6QgGgADwo9CMiq9WshJYvjjcUSz+soOWENXB8Yz
         +yzPDX+kWV/JQX9MISsZS7+FavBId0eLSoC7+5HOAzw01Cet4dblSOgmy1zHHmuas6
         Kdl5iKi/UEhJ1XZmYa8QW4XxVKO6lbcKAQAbpsjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanchayan Maity <maitysanchayan@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: [PATCH 4.14 121/126] ARM: dts: imx6dl-colibri-eval-v3: fix sram compatible properties
Date:   Tue, 10 Mar 2020 13:42:22 +0100
Message-Id: <20200310124211.171806692@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
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
@@ -231,7 +231,7 @@
 
 	/* SRAM on Colibri nEXT_CS0 */
 	sram@0,0 {
-		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
+		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
 		reg = <0 0 0x00010000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -242,7 +242,7 @@
 
 	/* SRAM on Colibri nEXT_CS1 */
 	sram@1,0 {
-		compatible = "cypress,cy7c1019dv33-10zsxi, mtd-ram";
+		compatible = "cypress,cy7c1019dv33-10zsxi", "mtd-ram";
 		reg = <1 0 0x00010000>;
 		#address-cells = <1>;
 		#size-cells = <1>;


