Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED769CCD61
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 02:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJFAJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 20:09:23 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:36820 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfJFAJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 20:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1570320560; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1j4oXBffe5ZkgZJTuc7oM2MD1utYIT3EJrl9bGvZIMk=;
        b=AEQ0GGq55VVrrZtgkGjqM7Ui8mEkrQd1TT09AprvlL/O6m2DohVLBDuTReO54PJKzfxcN2
        gUkIVnq/8BEm4IarOEpXAl1dBef9CqRGo2q6SUs/Rk8fTl68WyufqB0NYnXThGPoIOQ3V4
        SyZ1ILmqKN7IpKVQpsMNPJ+FDBV7OPU=
Date:   Sun, 06 Oct 2019 02:09:15 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: Patch "clk: jz4740: Add TCU clock" has been added to the
 4.4-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Message-Id: <1570320555.3.0@crapouillou.net>
In-Reply-To: <20191005235655.C47C7206DF@mail.kernel.org>
References: <20191005235655.C47C7206DF@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I think this patch shouldn't be added to the stable trees; it will=20
cause the TCU clock to be managed by the clock framework and=20
automatically gated after bootup since it has no client, causing a=20
global system lockup. It's only really applicable to 5.3.

Thanks,
-Paul



Le sam., oct. 5, 2019 at 19:56, Sasha Levin <sashal@kernel.org> a=20
=E9crit :
> This is a note to let you know that I've just added the patch titled
>=20
>     clk: jz4740: Add TCU clock
>=20
> to the 4.4-stable tree which can be found at:
>    =20
> http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.git;a=
=3Dsummary
>=20
> The filename of the patch is:
>      clk-jz4740-add-tcu-clock.patch
> and it can be found in the queue-4.4 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable=20
> tree,
> please let <stable@vger.kernel.org> know about it.
>=20
>=20
>=20
> commit c72b7e327a8b4d3b870f76011f674134f9ac38f6
> Author: Paul Cercueil <paul@crapouillou.net>
> Date:   Wed Jul 24 13:16:10 2019 -0400
>=20
>     clk: jz4740: Add TCU clock
>=20
>     [ Upstream commit 73dd11dc1a883d4c994d729dc9984f4890001157 ]
>=20
>     Add the missing TCU clock to the list of clocks supplied by the=20
> CGU for
>     the JZ4740 SoC.
>=20
>     Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>     Tested-by: Mathieu Malaterre <malat@debian.org>
>     Tested-by: Artur Rojek <contact@artur-rojek.eu>
>     Acked-by: Stephen Boyd <sboyd@kernel.org>
>     Acked-by: Rob Herring <robh@kernel.org>
>     Signed-off-by: Paul Burton <paul.burton@mips.com>
>     Cc: Ralf Baechle <ralf@linux-mips.org>
>     Cc: James Hogan <jhogan@kernel.org>
>     Cc: Jonathan Corbet <corbet@lwn.net>
>     Cc: Lee Jones <lee.jones@linaro.org>
>     Cc: Arnd Bergmann <arnd@arndb.de>
>     Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: Michael Turquette <mturquette@baylibre.com>
>     Cc: Jason Cooper <jason@lakedaemon.net>
>     Cc: Marc Zyngier <marc.zyngier@arm.com>
>     Cc: Rob Herring <robh+dt@kernel.org>
>     Cc: Mark Rutland <mark.rutland@arm.com>
>     Cc: devicetree@vger.kernel.org
>     Cc: linux-kernel@vger.kernel.org
>     Cc: linux-doc@vger.kernel.org
>     Cc: linux-mips@vger.kernel.org
>     Cc: linux-clk@vger.kernel.org
>     Cc: od@zcrc.me
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/clk/ingenic/jz4740-cgu.c=20
> b/drivers/clk/ingenic/jz4740-cgu.c
> index 305a26c2a800e..01b5b8b103888 100644
> --- a/drivers/clk/ingenic/jz4740-cgu.c
> +++ b/drivers/clk/ingenic/jz4740-cgu.c
> @@ -211,6 +211,12 @@ static const struct ingenic_cgu_clk_info=20
> jz4740_cgu_clocks[] =3D {
>  		.parents =3D { JZ4740_CLK_EXT, -1, -1, -1 },
>  		.gate =3D { CGU_REG_CLKGR, 5 },
>  	},
> +
> +	[JZ4740_CLK_TCU] =3D {
> +		"tcu", CGU_CLK_GATE,
> +		.parents =3D { JZ4740_CLK_EXT, -1, -1, -1 },
> +		.gate =3D { CGU_REG_CLKGR, 1 },
> +	},
>  };
>=20
>  static void __init jz4740_cgu_init(struct device_node *np)
> diff --git a/include/dt-bindings/clock/jz4740-cgu.h=20
> b/include/dt-bindings/clock/jz4740-cgu.h
> index 43153d3e9bd26..ff7c27bc98e37 100644
> --- a/include/dt-bindings/clock/jz4740-cgu.h
> +++ b/include/dt-bindings/clock/jz4740-cgu.h
> @@ -33,5 +33,6 @@
>  #define JZ4740_CLK_ADC		19
>  #define JZ4740_CLK_I2C		20
>  #define JZ4740_CLK_AIC		21
> +#define JZ4740_CLK_TCU		22
>=20
>  #endif /* __DT_BINDINGS_CLOCK_JZ4740_CGU_H__ */

=

