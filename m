Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2847F34C833
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhC2IUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhC2IT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61B661959;
        Mon, 29 Mar 2021 08:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005995;
        bh=pOih8Rd6RtCLJ2yoxnomHOd1MNcqtIZTOi+gSy7mnM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guAUvoBKqAZTQFaoZ97hDICvk95a/AufBVA+GQoY8G2Mo3/pe9147/Xi0QTGDVMJs
         mYxhXV5144SA2/fDfbGcAiMSEGVqbwKX9K0ok/ecttmlZyr4Zmo7Ig+yeD9NR8rV5u
         Xx5WNLJdLz7irEw4ArcarCkLeIf36i3eZp4W5ox0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Federico Pellegrin <fede@evolware.org>,
        Sandeep Sheriker Mallikarjun 
        <sandeepsheriker.mallikarjun@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.10 080/221] ARM: dts: at91: sam9x60: fix mux-mask for PA7 so it can be set to A, B and C
Date:   Mon, 29 Mar 2021 09:56:51 +0200
Message-Id: <20210329075631.885690574@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Federico Pellegrin <fede@evolware.org>

commit 664979bba8169d775959452def968d1a7c03901f upstream.

According to the datasheet PA7 can be set to either function A, B or
C (see table 6-2 of DS60001579D). The previous value would permit just
configuring with function C.

Signed-off-by: Federico Pellegrin <fede@evolware.org>
Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Cc: <stable@vger.kernel.org> # 5.6+
Cc: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -336,7 +336,7 @@
 &pinctrl {
 	atmel,mux-mask = <
 			 /*	A	B	C	*/
-			 0xFFFFFE7F 0xC0E0397F 0xEF00019D	/* pioA */
+			 0xFFFFFEFF 0xC0E039FF 0xEF00019D	/* pioA */
 			 0x03FFFFFF 0x02FC7E68 0x00780000	/* pioB */
 			 0xffffffff 0xF83FFFFF 0xB800F3FC	/* pioC */
 			 0x003FFFFF 0x003F8000 0x00000000	/* pioD */


