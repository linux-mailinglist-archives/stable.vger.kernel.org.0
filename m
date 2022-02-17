Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0584BA953
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbiBQTMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:12:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245046AbiBQTMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:12:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA4213D6D;
        Thu, 17 Feb 2022 11:11:50 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id cm8so1768065edb.3;
        Thu, 17 Feb 2022 11:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TX+i2rJBhVc8Ji7AAyvRVaOO70R/bzYPwOxKs7xg62w=;
        b=XuawKnlBh9ZCJ+/jSG/NmLWLfKvrlKONWf70+KQwzmXzTZ2IiaBi0izw7w3kCKkc2n
         eCGgDISqvfgoNj/HOKjgfe/Mb1KkWmnjX62PqSYTBONxTlgthvFqcq/jAK2O4Y3UPjmz
         +LbeRlYTw2aeUXBMOVke4YJBwzE9oDv93Pdn1OHFfaiWjaNSYVRYpe8FtKT6zw61SOAd
         2gO1KSjWZT407pLBXnL7BIu3D+B+kXToO2W9E7bTTLWvankXsWSi8W6ogFG/GEH6XKSr
         MMU3Xul1Bli3MCHzAj/01K8M63L7VLQG4/5DEqJuSuIDDUToGAvQJdYVK4c3a3mkafhM
         gHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TX+i2rJBhVc8Ji7AAyvRVaOO70R/bzYPwOxKs7xg62w=;
        b=fYnKOvoT8gcxiC6A6uihDqogm8p+rzBiUqZNUZSRrgy4c0DZy2hKoM3aPGSLCcIgBU
         +lUl2MVycCOo+T90nUXvq+zPk18xACrY0RY+/v/s0foUZFiOSaY0RyMPRZ8v0kx/n9hp
         NgeEm3DQwcqxciciBBZadbgKfz/nV5aUK11pOQp14ogUikpNlkxkqjdUG1dSBBVcaUjf
         /lou7ZKVqWmkvqVfYZjNFTp1V+2394NNLrBwLImYEhUpgpLU/21Wc/GOOh6T9E5ReNVg
         2xszjxyMvMHxRC3B7BRfLpADxpjSBaJe9VyOgyq2mZgOXG9NzOp+zhoB51A72QQIsUMv
         x+CA==
X-Gm-Message-State: AOAM531Q4aVI3rkzfxSRokjflNuG/7SvySJWZ5369LFe2dqKgONuH+8R
        F6ui5RBmanljSYy6JFiZMtY=
X-Google-Smtp-Source: ABdhPJxgH2DgWizKKJzC29G3LV6F67vPpe3/78sEqblc64FXeRk4FNLfrXuSd0akFhntK9lUPN7tPQ==
X-Received: by 2002:a50:8d4e:0:b0:408:3655:812f with SMTP id t14-20020a508d4e000000b004083655812fmr4289538edt.108.1645125109242;
        Thu, 17 Feb 2022 11:11:49 -0800 (PST)
Received: from orome (p200300e41f0a6900000000000000043a.dip0.t-ipconnect.de. [2003:e4:1f0a:6900::43a])
        by smtp.gmail.com with ESMTPSA id kw5sm1501435ejc.140.2022.02.17.11.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 11:11:47 -0800 (PST)
Date:   Thu, 17 Feb 2022 20:11:45 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Message-ID: <Yg6d8aWACA0jrnD0@orome>
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info>
 <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com>
 <37d074c7-b264-acac-4bf6-65caa4dbab1a@leemhuis.info>
 <CACjc_5o4n9CNXoER5Va6u0fQhuE9osnUSUwSbHPx0K1yiPUj8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dfwSPnWJeF4AJFKm"
Content-Disposition: inline
In-Reply-To: <CACjc_5o4n9CNXoER5Va6u0fQhuE9osnUSUwSbHPx0K1yiPUj8g@mail.gmail.com>
User-Agent: Mutt/2.2 (7160e05a) (2022-02-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dfwSPnWJeF4AJFKm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 11, 2022 at 09:09:15PM -0300, Marcelo Roberto Jimenez wrote:
> Hi,
>=20
> On Mon, Jan 10, 2022 at 4:02 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > Hi, this is your Linux kernel regression tracker speaking.
> >
> > On 20.12.21 21:41, Marcelo Roberto Jimenez wrote:
> > > On Mon, Dec 20, 2021 at 11:57 AM Bartosz Golaszewski <brgl@bgdev.pl> =
wrote:
> > >> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
> > >> <regressions@leemhuis.info> wrote:
> > >>>
> > >>> [TLDR: I'm adding this regression to regzbot, the Linux kernel
> > >>> regression tracking bot; most text you find below is compiled from =
a few
> > >>> templates paragraphs some of you might have seen already.]
> > >>>
> > >>> On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > >>>> Some GPIO lines have stopped working after the patch
> > >>>> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-=
ranges")
> > >>>>
> > >>>> And this has supposedly been fixed in the following patches
> > >>>> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > >>>> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not d=
efined")
> > >>>
> > >>> There seems to be a backstory here. Are there any entries and bug
> > >>> trackers or earlier discussions everyone that looks into this shoul=
d be
> > >>> aware of?
> > >>
> > >> Agreed with Thorsten. I'd like to first try to determine what's wrong
> > >> before reverting those, as they are correct in theory but maybe the
> > >> implementation missed something.
> > >>
> > >> Have you tried tracing the execution on your platform in order to see
> > >> what the driver is doing?
> > >
> > > Yes. The problem is that there is no list defined for the sysfs-gpio
> > > interface. The driver will not perform pinctrl_gpio_request() and will
> > > return zero (failure).
> > >
> > > I don't know if this is the case to add something to a global DTD or
> > > to fix it in the sysfs-gpio code.
> >
> > Out of interest, has any progress been made on this front?
> >
> > BTW, there was a last-minute commit for 5.16 yesterday that referenced
> > the culprit Marcelo specified:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?h=3Dmaster&id=3Dc8013355ead68dce152cf426686f8a5f80d88b40
> >
> > This was for a BCM283x and BCM2711 devices, so I assume it won't help.
> > Wild guess (I don't know anything about this area of the kernel):
> > Marcelo, do the dts files for your hardware maybe need a similar fix?
>=20
> I have tried to add "gpio-ranges" to the gpio-controllers in
> at91sam9x5.dtsi, but the system deadlocks, because in pinctrl-at91.c,
> function at91_pinctrl_probe() we have:
>=20
> /*
> * We need all the GPIO drivers to probe FIRST, or we will not be able
> * to obtain references to the struct gpio_chip * for them, and we
> * need this to proceed.
> */
> for (i =3D 0; i < gpio_banks; i++)
>         if (gpio_chips[i])
>                 ngpio_chips_enabled++;
>=20
>         if (ngpio_chips_enabled < info->nactive_banks) {
>                 dev_warn(&pdev->dev,
>                       "All GPIO chips are not registered yet (%d/%d)\n",
>                       ngpio_chips_enabled, info->nactive_banks);
>                devm_kfree(&pdev->dev, info);
>                 return -EPROBE_DEFER;
>         }
>=20
> On the other hand, in gpiolib-of.c, function
> of_gpiochip_add_pin_range() we have:
>=20
> if (!pctldev)
>         return -EPROBE_DEFER;
>=20
> In other words, the pinctrl needs all the gpio-controllers, and the
> gpio-controllers need the pinctrl. Each returns -EPROBE_DEFER and the
> system deadlocks.

Ugh, yeah, this sounds like a really bad idea. Conceptually GPIO drivers
are consumers of a pinctrl device and by now making the pinctrl device
depend on GPIO chips you make the dependency recursive, which is exactly
what you're observing here. And it's honestly not a surprise that this
breaks. It is rather surprising that this has worked before in the first
place.

Now, looking through some of the pin control documentation, I see that
this kind of setup is actually encouraged (see "Interaction with the
GPIO subsystem" in Documentation/driver-api/pin-control.rst). This may
make sense for cases where the GPIO chips can be hard-coded, but I don't
see how that would work in practice.

Looking at a random sampling of drivers, I see a lot of those that are
calling pinctrl_add_gpio_range() are setting the .gc field to point at a
GPIO controller. However, in the cases that I've seen, they are all very
tightly integrated with the pinctrl such that they don't have to do that
same dance that AT91 does (where pinctrl and GPIO drivers are separate),
so they avoid the circular dependency. A couple of examples are here:

	- bcm/pinctrl-bcm2835.c
	- pinctrl-starfive.c
	- pinctrl-st.c
	- renesas/pinctrl-rza1.c
	- renesas/pinctrl-rza2.c
	- samsung/pinctrl-samsung.c
	- stm32/pinctrl-stm32.c

pinctrl-xway.c is another, slightly different variant that references a
file-scoped struct gpio_chip, so it's again in that "tightly coupled"
category.

tegra/pinctrl-tegra.c gets away without setting the .gc field and
instead uses a hard-coded number of GPIO lines in the range. The same
goes for mvebu/pinctrl-mvebu.c which uses platform data to pass GPIO
ranges information.

Given all of the above, it sounds to me like the right way to fix this
would be to do two things:

	1) avoid the circular dependency by not waiting for all GPIO
	   chips to get probed within the pinctrl driver's ->probe()

	2) use the standard, DT-based mechanism to register GPIO ranges
	   with the pinctrl

Typically 2) would involve adding the gpio-ranges properties to the GPIO
controllers' DT nodes. However, it looks like it might also be possible
to avoid this in the AT91 driver by making it register the GPIO ranges
=66rom the GPIO driver's ->probe() function. That would typically be
slightly tricky because you don't typically have a back-reference to the
pinctrl device from the GPIO chip. *However*, it looks like on AT91-
based platforms the GPIO controllers are actually children of the pin
controller, which would nicely solve that problem (you can get the
reference to the pin controller via the GPIO controllers' parent). I
have not checked exhaustively if that's always the case, just for a
couple of AT91-based DTS files, but I suspect that this is a common
scheme for this type of device.

Note that the fact that GPIO controllers are children of the pin
controller is another indicator for why the circular dependency is a bad
idea. After all you can't have children without a parent. Parents need
to be "fully initialized" before they can procreate.

If you wanted to make this really complicated you could perhaps achieve
what that driver is currently trying by using the component driver
infrastructure. That would basically involve initializing the pin
controller fully so that it's ready to be used by the GPIO controllers
and then once all GPIO controllers have been added, a special callback
will be called, allowing you to complete the initialization of all the
components (which could then be used to add the GPIO ranges). I don't
think that's necessary in this case, though.

Thierry

> > Ciao, Thorsten
> >
> > P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
> > on my table. I can only look briefly into most of them. Unfortunately
> > therefore I sometimes will get things wrong or miss something important.
> > I hope that's not the case here; if you think it is, don't hesitate to
> > tell me about it in a public reply, that's in everyone's interest.
> >
> > BTW, I have no personal interest in this issue, which is tracked using
> > regzbot, my Linux kernel regression tracking bot
> > (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
> > this mail to get things rolling again and hence don't need to be CC on
> > all further activities wrt to this regression.
> >
> > #regzbot poke
> >
>=20
> Regards,
> Marcelo.

--dfwSPnWJeF4AJFKm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmIOne4ACgkQ3SOs138+
s6EN6w//YZq2fScOKNwqbRJk9mkrI383ip0TkB37cTwnY00r7y74mI1UtcZzJlPD
uGSsnnZP09bym6Yr1+NLYE1KaFozr0uaGoLl6w9d1++LlAq4L1uuPyVa5uqMcIde
3f1ML5OHnpWcn7aPgbS1ft8CAsRvEkBE7yg6sD1hgb3MjRVLMaFI+gbFA+ZfuIKg
GMentcJRL8Z+BqpJ3cg+hgWGFI1LXKGqdj0vXR5SdneoryyepyTJaEjTn0faKoW0
XrsUuGSp8kkbUsXBJLqD7whdewnNksH1hEa0R1B5ty/lD5C7Ao2lc783U0suOJCi
N4W2QBv91r7Zk2Ml0ik3qQm14KOdijAc3ANgsuY8eSB1c2XfwSdYSeDtitKuXrG8
p4Vm5GxtI9YKTboBBle0PXUiq8/2VwrBo9qhvIx4zl/vD/GX8D1qsaQI57/sHlg8
q7qHDi1nuKLWsDN9iGq5mU4Ys4xBau3cfk9gKXW4GPGRhTvpUY7ZOCJZVymO2rK6
hao7kU/mrfxgSgoRWHmYS3JB7yk5irsiukAnGf9+EtkC+oDp7An8Pa+JT77Xv7wh
B3daRb7B+LzK5zyy/2h7b2U3dxJPU/f+CUQ1XenPECjnbZmwsukCpcaSKbQaLqty
A1n1X3xoMJeT7OZXMShl7wrakAzP+08HWJJk5k39pWAp9cPTkq8=
=0pmC
-----END PGP SIGNATURE-----

--dfwSPnWJeF4AJFKm--
