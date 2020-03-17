Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6D51881B5
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgCQLSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgCQLFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:05:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59B5D2073E;
        Tue, 17 Mar 2020 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443109;
        bh=Q2KuvY2wUIITZZ23RE0KyIC+rdvVru0ndU38jehTFXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/sQoccfP8PKK0Fu1cJnrBdkqKbzGp5gvoDzIH7Ag9p3qJAXVueO1yGe+b2kKbKzz
         RlkkJex/19XkZD99f3uBOalzgm9gZfZskRBpLSzyVhRL9Ciwzt4M2xX3U7RjHbdPUh
         VW3oQZhNOj9fF01r0pgO1Hn1so9KUAJfDVrRm2ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Nicolas Belin <nbelin@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 099/123] pinctrl: meson-gxl: fix GPIOX sdio pins
Date:   Tue, 17 Mar 2020 11:55:26 +0100
Message-Id: <20200317103317.809677515@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Belin <nbelin@baylibre.com>

commit dc7a06b0dbbafac8623c2b7657e61362f2f479a7 upstream.

In the gxl driver, the sdio cmd and clk pins are inverted. It has not caused
any issue so far because devices using these pins always take both pins
so the resulting configuration is OK.

Fixes: 0f15f500ff2c ("pinctrl: meson: Add GXL pinctrl definitions")
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Nicolas Belin <nbelin@baylibre.com>
Link: https://lore.kernel.org/r/1582204512-7582-1-git-send-email-nbelin@baylibre.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/meson/pinctrl-meson-gxl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/meson/pinctrl-meson-gxl.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
@@ -147,8 +147,8 @@ static const unsigned int sdio_d0_pins[]
 static const unsigned int sdio_d1_pins[]	= { GPIOX_1 };
 static const unsigned int sdio_d2_pins[]	= { GPIOX_2 };
 static const unsigned int sdio_d3_pins[]	= { GPIOX_3 };
-static const unsigned int sdio_cmd_pins[]	= { GPIOX_4 };
-static const unsigned int sdio_clk_pins[]	= { GPIOX_5 };
+static const unsigned int sdio_clk_pins[]	= { GPIOX_4 };
+static const unsigned int sdio_cmd_pins[]	= { GPIOX_5 };
 static const unsigned int sdio_irq_pins[]	= { GPIOX_7 };
 
 static const unsigned int nand_ce0_pins[]	= { BOOT_8 };


