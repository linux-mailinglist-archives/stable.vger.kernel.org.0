Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C55418B535
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgCSNQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbgCSNQc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0555C21556;
        Thu, 19 Mar 2020 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623791;
        bh=HHwE0TbQhSiAvn+ZMbqACCvTK1kzXfONIL2U8HuOR04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt0XjUEp1965t63dLpKYWwgL5SPtOjCvUfpJCyOdh5kXL06Qgj6JTeK/WnnKL6ugG
         zwKD+VFCf6tEzGe4FT1GUfbUEE7x7MdCGiwh+UjCn+DUXhBs8/OSdCDGkTWc+DGuOe
         pHM71jj7sxWw2/xVNB+OREyPwKO0qB/OJ3voz5sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Nicolas Belin <nbelin@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 54/99] pinctrl: meson-gxl: fix GPIOX sdio pins
Date:   Thu, 19 Mar 2020 14:03:32 +0100
Message-Id: <20200319123958.276963230@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -158,8 +158,8 @@ static const unsigned int sdio_d0_pins[]
 static const unsigned int sdio_d1_pins[] = { PIN(GPIOX_1, EE_OFF) };
 static const unsigned int sdio_d2_pins[] = { PIN(GPIOX_2, EE_OFF) };
 static const unsigned int sdio_d3_pins[] = { PIN(GPIOX_3, EE_OFF) };
-static const unsigned int sdio_cmd_pins[] = { PIN(GPIOX_4, EE_OFF) };
-static const unsigned int sdio_clk_pins[] = { PIN(GPIOX_5, EE_OFF) };
+static const unsigned int sdio_clk_pins[] = { PIN(GPIOX_4, EE_OFF) };
+static const unsigned int sdio_cmd_pins[] = { PIN(GPIOX_5, EE_OFF) };
 static const unsigned int sdio_irq_pins[] = { PIN(GPIOX_7, EE_OFF) };
 
 static const unsigned int nand_ce0_pins[]	= { PIN(BOOT_8, EE_OFF) };


