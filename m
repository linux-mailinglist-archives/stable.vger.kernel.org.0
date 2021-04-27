Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD9936C80F
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhD0Ozo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbhD0Ozo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 10:55:44 -0400
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Apr 2021 07:55:00 PDT
Received: from mx3.securetransport.de (mx3.securetransport.de [IPv6:2a01:4f8:c0c:92be::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ADEC061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dh-electronics.com;
        s=dhelectronicscom; t=1619534826;
        bh=w6KyEtLlOhQ+TiRjRc02HMw2v9pd+xaEA9GeEV/oIps=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=JHs9Xje8mylAngTFWp9Qp3mnwoPAM+xPvj0Fw31Sqk11snE+TX/Lmuox4RfeUe9Y7
         smgUMBxscsFFekNEITVgE9Bi/u+CiDBUhTLumTRPvGlPk9IJMQpaHalmHVzUZ8jsXO
         b1htH9rkS4eHNk/GOjmgyQQcuEUGsgvWDR/iwwqOg7C4iDgVC2/NXdB0+7/tT0R4oX
         hmHQZdPxxJx+JEvyyhu9FS3hINqS3N8ZECfWUsdixkxS+TccKgSNL6N59qlyTAURRz
         GL1j4FkQ9IaGTj/LIr7GPPreGXLl49oN0xZqYoYlwxncLwWjYjvpaCLm9vP7iw6o68
         OevWy19UW3Paw==
X-secureTransport-forwarded: yes
From:   Christoph Niedermaier <cniedermaier@dh-electronics.com>
Complaints-To: abuse@cubewerk.de
To:     Marek Vasut <marex@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     "arnd@arndb.de" <arnd@arndb.de>,
        Fabio Estevam <festevam@gmail.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V3] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
Thread-Topic: [PATCH V3] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5
 regulators
Thread-Index: AQHXOoZCGOmuc8egpkWTyk5VKo1VPKrIcmGQ
Date:   Tue, 27 Apr 2021 14:46:55 +0000
Message-ID: <a5b1890db288453991089c3f3eca9af6@dh-electronics.com>
References: <20210426102321.5039-1-marex@denx.de>
In-Reply-To: <20210426102321.5039-1-marex@denx.de>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut [mailto:marex@denx.de]
Sent: Monday, April 26, 2021 12:23 PM

> Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
> via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
> from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.
>=20
> While no instability or problems are currently observed, the regulators
> should be fully described in DT and that description should fully match
> the hardware, else this might lead to unforseen issues later. Fix this.
>=20
> Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM
> and PDK2")
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Ludwig Zenz <lzenz@dh-electronics.com>
> Cc: NXP Linux Team <linux-imx@nxp.com>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: stable@vger.kernel.org
> ---
> V2: Amend commit message
> V3: Reinstate the missing SoB line, add RB
> ---
>  arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> index 236fc205c389..d0768ae429fa 100644
> --- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> +++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> @@ -406,6 +406,18 @@ &reg_soc {
>         vin-supply =3D <&sw1_reg>;
>  };
>=20
> +&reg_pu {
> +       vin-supply =3D <&sw1_reg>;
> +};
> +
> +&reg_vdd1p1 {
> +       vin-supply =3D <&sw2_reg>;
> +};
> +
> +&reg_vdd2p5 {
> +       vin-supply =3D <&sw2_reg>;
> +};
> +
>  &uart1 {
>         pinctrl-names =3D "default";
>         pinctrl-0 =3D <&pinctrl_uart1>;
> --
> 2.30.2

Reviewed-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
