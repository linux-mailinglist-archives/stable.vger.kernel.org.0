Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC0A49961A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443848AbiAXU7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442949AbiAXUzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34575B8121C;
        Mon, 24 Jan 2022 20:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E4C340E5;
        Mon, 24 Jan 2022 20:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057748;
        bh=P3mP2RwBxJp/EBT6OaLms76ZlqOs6NnvvLLYqQRsXt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7pAyoT8uJ6v22CKD3Av+hqwn11CTwZoHAQ5BVTaYZZZkgU9Di+YhvL+7PBKwuXdx
         u5FWBxS3kTCInjWFeO694Py3hQJ5/qtetKHTUzj2g06SoUPjlNH0DDB7PqoyK3eepS
         tn7j8Wk+x35BxrFGhVKjmT73p7meKKm0vjud3nD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hari Prasath <Hari.PrasathGE@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.16 0067/1039] ARM: dts: at91: update alternate function of signal PD20
Date:   Mon, 24 Jan 2022 19:30:56 +0100
Message-Id: <20220124184127.418111473@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Prasath <Hari.PrasathGE@microchip.com>

commit 12f332d2dd3187472f595b678246adb10d886bd0 upstream.

The alternate function of PD20 is 4 as per the datasheet of
sama7g5 and not 5 as defined earlier.

Signed-off-by: Hari Prasath <Hari.PrasathGE@microchip.com>
Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20211208063553.19807-1-Hari.PrasathGE@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama7g5-pinfunc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/sama7g5-pinfunc.h
+++ b/arch/arm/boot/dts/sama7g5-pinfunc.h
@@ -765,7 +765,7 @@
 #define PIN_PD20__PCK0			PINMUX_PIN(PIN_PD20, 1, 3)
 #define PIN_PD20__FLEXCOM2_IO3		PINMUX_PIN(PIN_PD20, 2, 2)
 #define PIN_PD20__PWMH3			PINMUX_PIN(PIN_PD20, 3, 4)
-#define PIN_PD20__CANTX4		PINMUX_PIN(PIN_PD20, 5, 2)
+#define PIN_PD20__CANTX4		PINMUX_PIN(PIN_PD20, 4, 2)
 #define PIN_PD20__FLEXCOM5_IO0		PINMUX_PIN(PIN_PD20, 6, 5)
 #define PIN_PD21			117
 #define PIN_PD21__GPIO			PINMUX_PIN(PIN_PD21, 0, 0)


