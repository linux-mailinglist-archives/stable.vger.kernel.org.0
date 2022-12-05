Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E14642CD4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiLEQbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLEQbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:31:32 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9C71E722;
        Mon,  5 Dec 2022 08:31:30 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B0222FF806;
        Mon,  5 Dec 2022 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670257889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9EE3fQMr3pSS04VorK2MV9hiMfHZVXwxlbDklYuvHA=;
        b=Q2HsDL+5s3L7eQ8Z5HOvuFUiLBtCuucxTpAFLJvFPIYZqm1r/6Nqmeft1/+HSfEOzOWJ+M
        H1CSYCD8edKGBmIwAXQj4Aj+LWAtNDI38iTxYn2cPSfwtYgbcdxbcndbc/tZcSmir1jd8n
        J+Z6uZzfy4dBZpWcXTYDROchI7cx7rKt9D0PN/1/SUL6h75aebpgB0IGpsZG31BKMqJ5it
        TrSFD9tE2ZjDrW1OHzL4Lo4xrfzcrFlQlvQLpr9JEJ+Bh26qNOtDchoDGgMGRJXjhp5g2r
        o2nA5cYG/cw9MBedF7ojvLj99epW77r7ZGXu52RSZUAuN6+6dirU4j2iA81JAA==
Date:   Mon, 5 Dec 2022 17:31:17 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <20221205172754.5a67e51d@xps-13>
In-Reply-To: <20221205152327.26881-1-francesco@dolcini.it>
References: <20221205152327.26881-1-francesco@dolcini.it>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Mon,  5 Dec 2022 16:23:27 +0100:

> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>=20
> This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
>=20
> It introduced a boot regression on colibri-imx7, and potentially any
> other i.MX7 boards with MTD partition list generated into the fdt by
> U-Boot.
>=20
> While the commit we are reverting here is not obviously wrong, it fixes
> only a dt binding checker warning that is non-functional, while it
> introduces a boot regression and there is no obvious fix ready.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.torad=
ex.com/
> Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

> ---
>  arch/arm/boot/dts/imx7s.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> index 03d2e8544a4e..0fc9e6b8b05d 100644
> --- a/arch/arm/boot/dts/imx7s.dtsi
> +++ b/arch/arm/boot/dts/imx7s.dtsi
> @@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
>  			clocks =3D <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
>  		};
> =20
> -		gpmi: nand-controller@33002000 {
> +		gpmi: nand-controller@33002000{
>  			compatible =3D "fsl,imx7d-gpmi-nand";
>  			#address-cells =3D <1>;
> -			#size-cells =3D <0>;
> +			#size-cells =3D <1>;
>  			reg =3D <0x33002000 0x2000>, <0x33004000 0x4000>;
>  			reg-names =3D "gpmi-nand", "bch";
>  			interrupts =3D <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;


Thanks,
Miqu=C3=A8l
