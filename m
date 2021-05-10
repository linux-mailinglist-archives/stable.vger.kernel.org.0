Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9C37897C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhEJL3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238340AbhEJLR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB3B261878;
        Mon, 10 May 2021 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645184;
        bh=/QXs1V0fQyD+GjBv7ZumL6DtjWsKNPv+fGAGzMarQZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iN75Boo5/LWBZJThdm7RVnReVfSG83kKCjN6cPToYUmmLWt0KYucCigts/gB8to5G
         JaWs0y02zXRP5lMCcoHzieR631RE0lihK47fKMfV6J37VE+MTEbrfZ0otnCO8RZN05
         D71J1Yl8kqiBIuwlN5EyeefLLWEOJg4bkWYjUzqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.12 380/384] pinctrl: Ingenic: Add missing pins to the JZ4770 MAC MII group.
Date:   Mon, 10 May 2021 12:22:49 +0200
Message-Id: <20210510102027.309864869@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

commit 65afd97630a9d6dd9ea83ff182dfdb15bc58c5d1 upstream.

The MII group of JZ4770's MAC should have 7 pins, add missing
pins to the MII group.

Fixes: 5de1a73e78ed ("Pinctrl: Ingenic: Add missing parts for JZ4770 and JZ4780.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/1618757073-1724-2-git-send-email-zhouyanjie@wanyeetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -667,7 +667,9 @@ static int jz4770_pwm_pwm7_pins[] = { 0x
 static int jz4770_mac_rmii_pins[] = {
 	0xa9, 0xab, 0xaa, 0xac, 0xa5, 0xa4, 0xad, 0xae, 0xa6, 0xa8,
 };
-static int jz4770_mac_mii_pins[] = { 0xa7, 0xaf, };
+static int jz4770_mac_mii_pins[] = {
+	0x7b, 0x7a, 0x7d, 0x7c, 0xa7, 0x24, 0xaf,
+};
 
 static const struct group_desc jz4770_groups[] = {
 	INGENIC_PIN_GROUP("uart0-data", jz4770_uart0_data, 0),


