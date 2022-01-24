Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3039B49A9FF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323945AbiAYD34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3413920AbiAYAlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:41:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A695DC06F8C1;
        Mon, 24 Jan 2022 12:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E188B811FB;
        Mon, 24 Jan 2022 20:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC00C340E5;
        Mon, 24 Jan 2022 20:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055168;
        bh=P3mP2RwBxJp/EBT6OaLms76ZlqOs6NnvvLLYqQRsXt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHUA8STDh5vtodANNM32prNOIkTT4K9p/J40NrxScIqnkebr9L+pyiFBgna7QgtKC
         GUWAwWdyN4sof0sog8aiJFpEp4qkQjnvWEv7sn2gUjmvW2iVux24sBrlC/Hbf415wC
         lfCpTRJ/l4Ums0cxhG391kn7ZgHaF7UhcvKyZmzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hari Prasath <Hari.PrasathGE@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.15 063/846] ARM: dts: at91: update alternate function of signal PD20
Date:   Mon, 24 Jan 2022 19:33:00 +0100
Message-Id: <20220124184103.143884503@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


