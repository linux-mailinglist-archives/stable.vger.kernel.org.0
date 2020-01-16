Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E313F7F0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbgAPQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733153AbgAPQ4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B9324656;
        Thu, 16 Jan 2020 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193765;
        bh=c2hNHnL4TNS07Aetuk3vCqWMT2ZbIifbwtjjzl9FM2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1C8lG9D62BdViRON1E6J6XNHGF7VYJwOQ7Do9kbTUu/fSpkY6E2IzaOdgJJ2vGLyn
         BNllSazXEy77aYWt3SMEXCnvV/5pH9KMotgsepQF+SKYfu6DPJevoGBZ2kgcee3w6W
         aGYf5JA0qTJRCoI5xz4dFPbA/1XrSXjCm2bzytFo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 050/671] pinctrl: meson-gxl: remove invalid GPIOX tsin_a pins
Date:   Thu, 16 Jan 2020 11:44:41 -0500
Message-Id: <20200116165502.8838-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit d801064cb871806e6843738ecad38993646f53f7 ]

The GPIOX tsin_a pins wrongly uses the SDCard pinctrl bits, this
patch completely removes these pins entries until we find out what
are the correct bits and registers to be used instead.

Fixes: 5a6ae9b80139 ("pinctrl: meson-gxl: add tsin_a pins")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-gxl.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxl.c b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
index 158f618f1695..0c0a5018102b 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxl.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
@@ -239,13 +239,9 @@ static const unsigned int eth_link_led_pins[]	= { GPIOZ_14 };
 static const unsigned int eth_act_led_pins[]	= { GPIOZ_15 };
 
 static const unsigned int tsin_a_d0_pins[]	= { GPIODV_0 };
-static const unsigned int tsin_a_d0_x_pins[]	= { GPIOX_10 };
 static const unsigned int tsin_a_clk_pins[]	= { GPIODV_8 };
-static const unsigned int tsin_a_clk_x_pins[]	= { GPIOX_11 };
 static const unsigned int tsin_a_sop_pins[]	= { GPIODV_9 };
-static const unsigned int tsin_a_sop_x_pins[]	= { GPIOX_8 };
 static const unsigned int tsin_a_d_valid_pins[] = { GPIODV_10 };
-static const unsigned int tsin_a_d_valid_x_pins[] = { GPIOX_9 };
 static const unsigned int tsin_a_fail_pins[]	= { GPIODV_11 };
 static const unsigned int tsin_a_dp_pins[] = {
 	GPIODV_1, GPIODV_2, GPIODV_3, GPIODV_4, GPIODV_5, GPIODV_6, GPIODV_7,
@@ -432,10 +428,6 @@ static struct meson_pmx_group meson_gxl_periphs_groups[] = {
 	GROUP(spi_miso,		5,	2),
 	GROUP(spi_ss0,		5,	1),
 	GROUP(spi_sclk,		5,	0),
-	GROUP(tsin_a_sop_x,	6,	3),
-	GROUP(tsin_a_d_valid_x,	6,	2),
-	GROUP(tsin_a_d0_x,	6,	1),
-	GROUP(tsin_a_clk_x,	6,	0),
 
 	/* Bank Z */
 	GROUP(eth_mdio,		4,	23),
@@ -698,8 +690,8 @@ static const char * const eth_led_groups[] = {
 };
 
 static const char * const tsin_a_groups[] = {
-	"tsin_a_clk", "tsin_a_clk_x", "tsin_a_sop", "tsin_a_sop_x",
-	"tsin_a_d_valid", "tsin_a_d_valid_x", "tsin_a_d0", "tsin_a_d0_x",
+	"tsin_a_clk", "tsin_a_sop",
+	"tsin_a_d_valid", "tsin_a_d0",
 	"tsin_a_dp", "tsin_a_fail",
 };
 
-- 
2.20.1

