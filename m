Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA11A40DF32
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhIPQHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233462AbhIPQHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 724816127A;
        Thu, 16 Sep 2021 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808348;
        bh=qb2B1/pj+fPKuwMKjMFok1Pbe1N93Mzx558OS35UmKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgQUJweZ2+vTSj/IRNxdvpPzwt9hctVYZ2d2A0g9QiF6RHSFOhzgVORROFhme9FAq
         afBZT+a8yOBCvOv7Y4Cq09E3ay8BwCk+A9tISjuMkMhELwf2mFsqEZd2aJ/eMsJ2u6
         dzuR3JobOTD/VN5GgF6/kT0cJnvAuabCX0vjzPXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Zhaoyu Liu <zackaryliu@yeah.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/306] pinctrl: remove empty lines in pinctrl subsystem
Date:   Thu, 16 Sep 2021 17:56:41 +0200
Message-Id: <20210916155755.853120138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhaoyu Liu <zackary.liu.pro@gmail.com>

[ Upstream commit 43878eb7c83d3335af7737dcce1fa79071065dfe ]

Remove all empty lines at the end of functions in pinctrl subsystem,
and make the code neat.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Zhaoyu Liu <zackaryliu@yeah.net>
Link: https://lore.kernel.org/r/X98NP6NFK1Afzrgd@manjaro
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/actions/pinctrl-owl.c         | 1 -
 drivers/pinctrl/core.c                        | 1 -
 drivers/pinctrl/freescale/pinctrl-imx1-core.c | 1 -
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c   | 1 -
 drivers/pinctrl/pinctrl-at91.c                | 1 -
 drivers/pinctrl/pinctrl-st.c                  | 1 -
 drivers/pinctrl/pinctrl-sx150x.c              | 1 -
 drivers/pinctrl/qcom/pinctrl-sdm845.c         | 1 -
 drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c       | 1 -
 drivers/pinctrl/renesas/pfc-r8a77950.c        | 1 -
 drivers/pinctrl/renesas/pfc-r8a77951.c        | 1 -
 drivers/pinctrl/renesas/pfc-r8a7796.c         | 1 -
 drivers/pinctrl/renesas/pfc-r8a77965.c        | 1 -
 13 files changed, 13 deletions(-)

diff --git a/drivers/pinctrl/actions/pinctrl-owl.c b/drivers/pinctrl/actions/pinctrl-owl.c
index 903a4baf3846..c8b3e396ea27 100644
--- a/drivers/pinctrl/actions/pinctrl-owl.c
+++ b/drivers/pinctrl/actions/pinctrl-owl.c
@@ -444,7 +444,6 @@ static int owl_group_config_get(struct pinctrl_dev *pctrldev,
 	*config = pinconf_to_config_packed(param, arg);
 
 	return ret;
-
 }
 
 static int owl_group_config_set(struct pinctrl_dev *pctrldev,
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 20b477cd5a30..6e6825d17a1d 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -2119,7 +2119,6 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		return ERR_PTR(error);
 
 	return pctldev;
-
 }
 EXPORT_SYMBOL_GPL(pinctrl_register);
 
diff --git a/drivers/pinctrl/freescale/pinctrl-imx1-core.c b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
index 08d110078c43..70186448d2f4 100644
--- a/drivers/pinctrl/freescale/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
@@ -290,7 +290,6 @@ static const struct pinctrl_ops imx1_pctrl_ops = {
 	.pin_dbg_show = imx1_pin_dbg_show,
 	.dt_node_to_map = imx1_dt_node_to_map,
 	.dt_free_map = imx1_dt_free_map,
-
 };
 
 static int imx1_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 68894e9e05d2..5a68e242f6b3 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -188,7 +188,6 @@ static struct armada_37xx_pin_group armada_37xx_nb_groups[] = {
 	PIN_GRP_GPIO_2("led1_od", 12, 1, BIT(21), BIT(21), 0, "led"),
 	PIN_GRP_GPIO_2("led2_od", 13, 1, BIT(22), BIT(22), 0, "led"),
 	PIN_GRP_GPIO_2("led3_od", 14, 1, BIT(23), BIT(23), 0, "led"),
-
 };
 
 static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 72edc675431c..9015486e38c1 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -733,7 +733,6 @@ static const struct at91_pinctrl_mux_ops sam9x60_ops = {
 	.get_slewrate   = at91_mux_sam9x60_get_slewrate,
 	.set_slewrate   = at91_mux_sam9x60_set_slewrate,
 	.irq_type	= alt_gpio_irq_type,
-
 };
 
 static struct at91_pinctrl_mux_ops sama5d3_ops = {
diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 7b8c7a0b13de..43d9e6c7fd81 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -541,7 +541,6 @@ static void st_pinconf_set_retime_packed(struct st_pinctrl *info,
 	st_regmap_field_bit_set_clear_pin(rt_p->delay_0, delay & 0x1, pin);
 	/* 2 bit delay, msb */
 	st_regmap_field_bit_set_clear_pin(rt_p->delay_1, delay & 0x2, pin);
-
 }
 
 static void st_pinconf_set_retime_dedicated(struct st_pinctrl *info,
diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index c110f780407b..484a3b9e875c 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -443,7 +443,6 @@ static void sx150x_gpio_set(struct gpio_chip *chip, unsigned int offset,
 		sx150x_gpio_oscio_set(pctl, value);
 	else
 		__sx150x_gpio_set(pctl, offset, value);
-
 }
 
 static void sx150x_gpio_set_multiple(struct gpio_chip *chip,
diff --git a/drivers/pinctrl/qcom/pinctrl-sdm845.c b/drivers/pinctrl/qcom/pinctrl-sdm845.c
index 2834d2c1338c..c51793f6546f 100644
--- a/drivers/pinctrl/qcom/pinctrl-sdm845.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdm845.c
@@ -1310,7 +1310,6 @@ static const struct msm_pinctrl_soc_data sdm845_pinctrl = {
 	.ngpios = 151,
 	.wakeirq_map = sdm845_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(sdm845_pdc_map),
-
 };
 
 static const struct msm_pinctrl_soc_data sdm845_acpi_pinctrl = {
diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c b/drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c
index 681d8dcf37e3..92e7f2602847 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-mpp.c
@@ -617,7 +617,6 @@ static void pm8xxx_mpp_dbg_show_one(struct seq_file *s,
 		}
 		break;
 	}
-
 }
 
 static void pm8xxx_mpp_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/drivers/pinctrl/renesas/pfc-r8a77950.c b/drivers/pinctrl/renesas/pfc-r8a77950.c
index 04812e62f3a4..9d89da2319e5 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77950.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77950.c
@@ -1668,7 +1668,6 @@ static const unsigned int avb_mii_pins[] = {
 	PIN_AVB_RX_CTL, PIN_AVB_RXC, PIN_AVB_RD0,
 	PIN_AVB_RD1, PIN_AVB_RD2, PIN_AVB_RD3,
 	PIN_AVB_TXCREFCLK,
-
 };
 static const unsigned int avb_mii_mux[] = {
 	AVB_TX_CTL_MARK, AVB_TXC_MARK, AVB_TD0_MARK,
diff --git a/drivers/pinctrl/renesas/pfc-r8a77951.c b/drivers/pinctrl/renesas/pfc-r8a77951.c
index a94ebe0bf5d0..4aea6e4b7157 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77951.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77951.c
@@ -1727,7 +1727,6 @@ static const unsigned int avb_mii_pins[] = {
 	PIN_AVB_RX_CTL, PIN_AVB_RXC, PIN_AVB_RD0,
 	PIN_AVB_RD1, PIN_AVB_RD2, PIN_AVB_RD3,
 	PIN_AVB_TXCREFCLK,
-
 };
 static const unsigned int avb_mii_mux[] = {
 	AVB_TX_CTL_MARK, AVB_TXC_MARK, AVB_TD0_MARK,
diff --git a/drivers/pinctrl/renesas/pfc-r8a7796.c b/drivers/pinctrl/renesas/pfc-r8a7796.c
index 3878d6b0db14..a67fa0e4df7c 100644
--- a/drivers/pinctrl/renesas/pfc-r8a7796.c
+++ b/drivers/pinctrl/renesas/pfc-r8a7796.c
@@ -1732,7 +1732,6 @@ static const unsigned int avb_mii_pins[] = {
 	PIN_AVB_RX_CTL, PIN_AVB_RXC, PIN_AVB_RD0,
 	PIN_AVB_RD1, PIN_AVB_RD2, PIN_AVB_RD3,
 	PIN_AVB_TXCREFCLK,
-
 };
 static const unsigned int avb_mii_mux[] = {
 	AVB_TX_CTL_MARK, AVB_TXC_MARK, AVB_TD0_MARK,
diff --git a/drivers/pinctrl/renesas/pfc-r8a77965.c b/drivers/pinctrl/renesas/pfc-r8a77965.c
index 7a50b9b69a7d..7db2b7f2ff67 100644
--- a/drivers/pinctrl/renesas/pfc-r8a77965.c
+++ b/drivers/pinctrl/renesas/pfc-r8a77965.c
@@ -1736,7 +1736,6 @@ static const unsigned int avb_mii_pins[] = {
 	PIN_AVB_RX_CTL, PIN_AVB_RXC, PIN_AVB_RD0,
 	PIN_AVB_RD1, PIN_AVB_RD2, PIN_AVB_RD3,
 	PIN_AVB_TXCREFCLK,
-
 };
 static const unsigned int avb_mii_mux[] = {
 	AVB_TX_CTL_MARK, AVB_TXC_MARK, AVB_TD0_MARK,
-- 
2.30.2



