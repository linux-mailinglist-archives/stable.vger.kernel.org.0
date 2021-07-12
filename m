Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFB3C47A0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhGLGdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236721AbhGLGcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30F7561106;
        Mon, 12 Jul 2021 06:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071361;
        bh=FRzcyIcbso1JSrsLWdv34UroRo/mtpvctA/RMQRPrdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4G+BRhE7oFZtwbLM0nGAkmeBjhrySBsVd7JosqvbL1OIDpoLtv+hZ0N1Vxy1tlWI
         T+pV+WWAlgGoJwUghJDEw/AS9cusFROhiYbvjje3XrfA1gTLg2Lb387Uw1MfsT7Hal
         ndSWP+19b+JGXrvsHZ5BHGd3qu2OIgu5esb/Opi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.10 038/593] ARM: dts: at91: sama5d4: fix pinctrl muxing
Date:   Mon, 12 Jul 2021 08:03:18 +0200
Message-Id: <20210712060847.380251110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@microchip.com>

commit 253adffb0e98eaf6da2e7cf73ae68695e21f2f3c upstream.

Fix pinctrl muxing, PD28, PD29 and PD31 can be muxed to peripheral A. It
allows to use SCK0, SCK1 and SPI0_NPCS2 signals.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes: 679f8d92bb01 ("ARM: at91/dt: sama5d4: add pioD pin mux mask and enable pioD")
Cc: stable@vger.kernel.org # v4.4+
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20191025084210.14726-1-ludovic.desroches@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sama5d4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -809,7 +809,7 @@
 					0xffffffff 0x3ffcfe7c 0x1c010101	/* pioA */
 					0x7fffffff 0xfffccc3a 0x3f00cc3a	/* pioB */
 					0xffffffff 0x3ff83fff 0xff00ffff	/* pioC */
-					0x0003ff00 0x8002a800 0x00000000	/* pioD */
+					0xb003ff00 0x8002a800 0x00000000	/* pioD */
 					0xffffffff 0x7fffffff 0x76fff1bf	/* pioE */
 					>;
 


