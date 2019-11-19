Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0B10144E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfKSFc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbfKSFc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939DE21783;
        Tue, 19 Nov 2019 05:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141548;
        bh=4q0wxmlT8LNfXIg3Vz5jn72hLNxKgjL8rMq45doAlCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQAvWg4xCPivlkHUnw5uu6ipj8+GJRgGBAlyYvVGkOJvVuWKGtvMsOb7N/B1HsDvh
         gx0BmioSQckLioRAY5FFa1FVM6Bli5wH1zwvR3C6AENjke8H21S0kNGaloPkvHKm/P
         3ygXvKEXZM/+sK9icQ7H1tAQ8kER8skMc7t/mMe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 199/422] arm64: dts: renesas: r8a77965: Fix HS-USB compatible
Date:   Tue, 19 Nov 2019 06:16:36 +0100
Message-Id: <20191119051411.469544772@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 99584d93e301d820d817bba2eb77b9152e13009c ]

Should be "renesas,usbhs-r8a77965", not "renesas,usbhs-r8a7796".

Fixes: a06e8af801760a98 ("arm64: dts: renesas: r8a77965: add HS-USB node")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index 0da4841162610..2ccb1138cdf0c 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -545,7 +545,7 @@
 		};
 
 		hsusb: usb@e6590000 {
-			compatible = "renesas,usbhs-r8a7796",
+			compatible = "renesas,usbhs-r8a77965",
 				     "renesas,rcar-gen3-usbhs";
 			reg = <0 0xe6590000 0 0x100>;
 			interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.20.1



