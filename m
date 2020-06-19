Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E5F200F59
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392451AbgFSPQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391953AbgFSPQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1BD206DB;
        Fri, 19 Jun 2020 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579767;
        bh=uv2kvTbckQQzxzS5LFDIVglVH5WrWYKtxASxfY7wk0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XVfqKiLg2gY7ZGRhaYl/B9FVQbTt4ugi/+ek0lwPcuTdyBKOt7lZo60EG7/DqQ8Q
         rI2OTXmI/BLqZbFCbqoaM2r3J6PcXE3JUADRcGDNGveQ7Z/VQ0iTNnQryUvVPVVHg+
         l4AHeK903Kw3cVUtN8kA/KKdXuoI29bmH5L09qAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 228/261] ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin
Date:   Fri, 19 Jun 2020 16:33:59 +0200
Message-Id: <20200619141700.787277817@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@microchip.com>

commit baa998aecb75c04d62be0a4ab6b724af6d73a0f9 upstream.

The gpio property for the vbus pin doesn't match the pinctrl and is
not correct.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes: 42ed535595ec "ARM: dts: at91: introduce the sama5d2 ptc ek board"
Cc: stable@vger.kernel.org # 4.19 and later
Link: https://lore.kernel.org/r/20200401221947.41502-1-ludovic.desroches@microchip.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -40,7 +40,7 @@
 
 	ahb {
 		usb0: gadget@300000 {
-			atmel,vbus-gpio = <&pioA PIN_PA27 GPIO_ACTIVE_HIGH>;
+			atmel,vbus-gpio = <&pioA PIN_PB11 GPIO_ACTIVE_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_usba_vbus>;
 			status = "okay";


