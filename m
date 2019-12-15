Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8786911F9BE
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLORhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:37:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:25086 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfLORhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576431468;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=LOYCyMsB8QVQ1ZSQb1f9wQw3aY/MZGHW81JbRdeK3PA=;
        b=g3jKxvOdCl9IEHDBmVCO7j+ei43yRxKQxa1hKppr69mGN++3pYjcV9h9s+K9QBfvvo
        1EC0kAuP7hqqSmr+pyW/ENsAbeRW0oKA0ZIriG2kuEk3q4uwt8A2hddGAwMX9TK56ugK
        5cIydbQKhdIwTjfROCVn2ndcSKOFfRqPv1gqH/86R8Azny54zYJw9fakQPy66G4AB00C
        BEiC5Lcmi5HokezAok0ySxntKVW8UH8qV8bLpA+4sdHf+CI8IXeZY+8a895qUVov0O9N
        LDnl4Wy31zIVSPC7JUEXxDa+oXxF4MYiq/6HfU02r97dKtz4zqrPr569xtMzqOUhIJm3
        ZuVg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PgwDGiVw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id i03ca8vBFHbkE3H
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sun, 15 Dec 2019 18:37:46 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and" failed to apply to 4.9-stable tree
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1576416779222224@kroah.com>
Date:   Sun, 15 Dec 2019 18:37:46 +0100
Cc:     stable@vger.kernel.org, tony@atomide.com, ulf.hansson@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6E106337-4D9E-4A5C-B737-33A352EA29BC@goldelico.com>
References: <1576416779222224@kroah.com>
To:     gregkh@linuxfoundation.org
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply this before: https://patchwork.kernel.org/patch/11232473/

> Am 15.12.2019 um 14:32 schrieb gregkh@linuxfoundation.org:
>=20
>=20
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git =
commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> =46rom 2398c41d64321e62af54424fd399964f3d48cdc2 Mon Sep 17 00:00:00 =
2001
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
> Date: Thu, 7 Nov 2019 11:30:39 +0100
> Subject: [PATCH] omap: pdata-quirks: remove openpandora quirks for =
mmc3 and
> wl1251
>=20
> With a wl1251 child node of mmc3 in the device tree decoded
> in omap_hsmmc.c to handle special wl1251 initialization, we do
> no longer need to instantiate the mmc3 through pdata quirks.
>=20
> We also can remove the wlan regulator and reset/interrupt definitions
> and do them through device tree.
>=20
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: <stable@vger.kernel.org> # v4.7+
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> diff --git a/arch/arm/mach-omap2/pdata-quirks.c =
b/arch/arm/mach-omap2/pdata-quirks.c
> index 800a602c06ec..1b7cf81ff035 100644
> --- a/arch/arm/mach-omap2/pdata-quirks.c
> +++ b/arch/arm/mach-omap2/pdata-quirks.c
> @@ -310,108 +310,15 @@ static void __init =
omap3_logicpd_torpedo_init(void)
> }
>=20
> /* omap3pandora legacy devices */
> -#define PANDORA_WIFI_IRQ_GPIO		21
> -#define PANDORA_WIFI_NRESET_GPIO	23
>=20
> static struct platform_device pandora_backlight =3D {
> 	.name	=3D "pandora-backlight",
> 	.id	=3D -1,
> };
>=20
> -static struct regulator_consumer_supply pandora_vmmc3_supply[] =3D {
> -	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.2"),
> -};
> -
> -static struct regulator_init_data pandora_vmmc3 =3D {
> -	.constraints =3D {
> -		.valid_ops_mask		=3D REGULATOR_CHANGE_STATUS,
> -	},
> -	.num_consumer_supplies	=3D ARRAY_SIZE(pandora_vmmc3_supply),
> -	.consumer_supplies	=3D pandora_vmmc3_supply,
> -};
> -
> -static struct fixed_voltage_config pandora_vwlan =3D {
> -	.supply_name		=3D "vwlan",
> -	.microvolts		=3D 1800000, /* 1.8V */
> -	.gpio			=3D PANDORA_WIFI_NRESET_GPIO,
> -	.startup_delay		=3D 50000, /* 50ms */
> -	.enable_high		=3D 1,
> -	.init_data		=3D &pandora_vmmc3,
> -};
> -
> -static struct platform_device pandora_vwlan_device =3D {
> -	.name		=3D "reg-fixed-voltage",
> -	.id		=3D 1,
> -	.dev =3D {
> -		.platform_data =3D &pandora_vwlan,
> -	},
> -};
> -
> -static void pandora_wl1251_init_card(struct mmc_card *card)
> -{
> -	/*
> -	 * We have TI wl1251 attached to MMC3. Pass this information to
> -	 * SDIO core because it can't be probed by normal methods.
> -	 */
> -	if (card->type =3D=3D MMC_TYPE_SDIO || card->type =3D=3D =
MMC_TYPE_SD_COMBO) {
> -		card->quirks |=3D MMC_QUIRK_NONSTD_SDIO;
> -		card->cccr.wide_bus =3D 1;
> -		card->cis.vendor =3D 0x104c;
> -		card->cis.device =3D 0x9066;
> -		card->cis.blksize =3D 512;
> -		card->cis.max_dtr =3D 24000000;
> -		card->ocr =3D 0x80;
> -	}
> -}
> -
> -static struct omap2_hsmmc_info pandora_mmc3[] =3D {
> -	{
> -		.mmc		=3D 3,
> -		.caps		=3D MMC_CAP_4_BIT_DATA | =
MMC_CAP_POWER_OFF_CARD,
> -		.gpio_cd	=3D -EINVAL,
> -		.gpio_wp	=3D -EINVAL,
> -		.init_card	=3D pandora_wl1251_init_card,
> -	},
> -	{}	/* Terminator */
> -};
> -
> -static void __init pandora_wl1251_init(void)
> -{
> -	struct wl1251_platform_data pandora_wl1251_pdata;
> -	int ret;
> -
> -	memset(&pandora_wl1251_pdata, 0, sizeof(pandora_wl1251_pdata));
> -
> -	pandora_wl1251_pdata.power_gpio =3D -1;
> -
> -	ret =3D gpio_request_one(PANDORA_WIFI_IRQ_GPIO, GPIOF_IN, =
"wl1251 irq");
> -	if (ret < 0)
> -		goto fail;
> -
> -	pandora_wl1251_pdata.irq =3D gpio_to_irq(PANDORA_WIFI_IRQ_GPIO);
> -	if (pandora_wl1251_pdata.irq < 0)
> -		goto fail_irq;
> -
> -	pandora_wl1251_pdata.use_eeprom =3D true;
> -	ret =3D wl1251_set_platform_data(&pandora_wl1251_pdata);
> -	if (ret < 0)
> -		goto fail_irq;
> -
> -	return;
> -
> -fail_irq:
> -	gpio_free(PANDORA_WIFI_IRQ_GPIO);
> -fail:
> -	pr_err("wl1251 board initialisation failed\n");
> -}
> -
> static void __init omap3_pandora_legacy_init(void)
> {
> 	platform_device_register(&pandora_backlight);
> -	platform_device_register(&pandora_vwlan_device);
> -	omap_hsmmc_init(pandora_mmc3);
> -	omap_hsmmc_late_init(pandora_mmc3);
> -	pandora_wl1251_init();
> }
> #endif /* CONFIG_ARCH_OMAP3 */
>=20
>=20

