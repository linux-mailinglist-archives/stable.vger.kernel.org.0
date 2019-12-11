Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0B11AD3A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfLKOTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:19:23 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:16868 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfLKOTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:19:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576073961;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GrzTM+TsO29atSE6ztAgl6moUiJhEJ0A3bogXQ5BowQ=;
        b=rWrtYFxdYtuIIwwVVEAxNnixwAL6TzFgtG3cbPDeslOdMr0GQEM9HTKOt423Q19sdX
        6xBmT5bEdasPnrwgboUdMi3N7+KNHKyqNosSll4AXGZFGvHhDWKMo8fF1I1AktcMgmli
        1vNH/A0b2w+BJ4puME0KzTE/ShJGx46NLL2qlECEpajJamNix7T8cRbUBLYGkNjgTTQZ
        M7Wyq8WyGVu69sYDpcevfQHa9/KJMP3nUjt+7WtRsW/Ix3I6JEs3DV0y2izUhR4M9620
        QVWtfmZnJj3KSzNNLZ8sLBDOEwqiOFMFU15PYPGFz1XAXeqn2SGqX9bpCwu94eauLbRx
        90SQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrvwDOutHk="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.2 DYNA|AUTH)
        with ESMTPSA id j03ffcvBBEJKYEl
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 11 Dec 2019 15:19:20 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: WTF: patch "[PATCH] net: wireless: ti: wl1251 add device tree support" was seriously submitted to be applied to the 5.4-stable tree?
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1576073193178125@kroah.com>
Date:   Wed, 11 Dec 2019 15:19:19 +0100
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org,
        ulf.hansson@linaro.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8B77E722-80C2-4607-8519-AC36CC42519C@goldelico.com>
References: <1576073193178125@kroah.com>
To:     gregkh@linuxfoundation.org
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
I have checked with Documentation/process/stable-kernel-rules.rst but =
not found out
what is failing.

Basically this belongs to a series to fix a bug

81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting =
DMA channel")

that exists since v4.7 and has been hidden by patches which came into =
the kernel over
the time.

BR and thanks,
Nikolaus Schaller

> Am 11.12.2019 um 15:06 schrieb <gregkh@linuxfoundation.org> =
<gregkh@linuxfoundation.org>:
>=20
> The patch below was submitted to be applied to the 5.4-stable tree.
>=20
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
>=20
> I could be totally wrong, and if so, please respond to=20
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to =
be
> seen again.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> =46rom 9b8d7072d6552ee5c57e5765f211f267041f9557 Mon Sep 17 00:00:00 =
2001
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
> Date: Thu, 7 Nov 2019 11:30:35 +0100
> Subject: [PATCH] net: wireless: ti: wl1251 add device tree support
>=20
> We will have the wl1251 defined as a child node of the mmc interface
> and can read setup for gpios, interrupts and the ti,use-eeprom
> property from there instead of pdata to be provided by pdata-quirks.
>=20
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Cc: <stable@vger.kernel.org> # v4.7+
> [Ulf: Fixed up some complaints from checkpatch]
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> diff --git a/drivers/net/wireless/ti/wl1251/sdio.c =
b/drivers/net/wireless/ti/wl1251/sdio.c
> index 677f1146ccf0..f1224b948f83 100644
> --- a/drivers/net/wireless/ti/wl1251/sdio.c
> +++ b/drivers/net/wireless/ti/wl1251/sdio.c
> @@ -16,6 +16,9 @@
> #include <linux/irq.h>
> #include <linux/pm_runtime.h>
> #include <linux/gpio.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>=20
> #include "wl1251.h"
>=20
> @@ -217,6 +220,7 @@ static int wl1251_sdio_probe(struct sdio_func =
*func,
> 	struct ieee80211_hw *hw;
> 	struct wl1251_sdio *wl_sdio;
> 	const struct wl1251_platform_data *wl1251_board_data;
> +	struct device_node *np =3D func->dev.of_node;
>=20
> 	hw =3D wl1251_alloc_hw();
> 	if (IS_ERR(hw))
> @@ -248,6 +252,17 @@ static int wl1251_sdio_probe(struct sdio_func =
*func,
> 		wl->power_gpio =3D wl1251_board_data->power_gpio;
> 		wl->irq =3D wl1251_board_data->irq;
> 		wl->use_eeprom =3D wl1251_board_data->use_eeprom;
> +	} else if (np) {
> +		wl->use_eeprom =3D of_property_read_bool(np,
> +						       =
"ti,wl1251-has-eeprom");
> +		wl->power_gpio =3D of_get_named_gpio(np, =
"ti,power-gpio", 0);
> +		wl->irq =3D of_irq_get(np, 0);
> +
> +		if (wl->power_gpio =3D=3D -EPROBE_DEFER ||
> +		    wl->irq =3D=3D -EPROBE_DEFER) {
> +			ret =3D -EPROBE_DEFER;
> +			goto disable;
> +		}
> 	}
>=20
> 	if (gpio_is_valid(wl->power_gpio)) {
>=20

