Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CC11F9C3
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLORjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:39:23 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:35430 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLORjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576431559;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=fdgKggMUba6Oxo9Sbd6k1gi4bnvfIV5Tbh/7SrFsNk4=;
        b=nyAG/dayz2LaJghMH5sjL/h/O7uW7zK/X4dXUwJXWVFHR7wHLVlC8ghXzV95grqizy
        KAIWurJ+lqpnb7HGN/QE1eaYUg56uSNrUWL/ZaL5oNSmec3xqDTpTZLga/ds7wKHZv+y
        EDabfPbJwvEHZ2HMI2DElAXPgLG2o/hXVaicRufZTKWm42bCyoZ/kDLmeNBNmUaQXPxh
        FdSfYaRMfRilBDFVOUB5871GjQI1i+ARpYZg4Yary0/TLhitOsvPRmj6sRNSolHfrSOw
        BLenJEvVvNPK6u6neAkZ5BAYWWoCouzVO0/PRg6Xc+H9hUwWbHP976LzGz5xeg/a95/Y
        yo4Q==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PgwDGiVw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id i03ca8vBFHdHE3Q
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sun, 15 Dec 2019 18:39:17 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: FAILED: patch "[PATCH] omap: pdata-quirks: remove openpandora quirks for mmc3 and" failed to apply to 5.4-stable tree
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <15764167786972@kroah.com>
Date:   Sun, 15 Dec 2019 18:39:17 +0100
Cc:     stable@vger.kernel.org, tony@atomide.com, ulf.hansson@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2098B44E-4542-40E7-9D55-7A6DAB433D6C@goldelico.com>
References: <15764167786972@kroah.com>
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
> The patch below does not apply to the 5.4-stable tree.
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

