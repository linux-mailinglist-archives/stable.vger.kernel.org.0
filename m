Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE491DD842
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgEUU2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:28:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41830 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728365AbgEUU2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:28:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrnX-0005TN-Id; Thu, 21 May 2020 21:28:11 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrnX-007L2o-4w; Thu, 21 May 2020 21:28:11 +0100
Message-ID: <8b2623680c557828814dda4602d29c5cc5d889d8.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 35/99] pxa168fb: Fix the function used to release
 some memory in an error handling path
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lubomir Rintel <lkundrak@v3.sk>
Date:   Thu, 21 May 2020 21:28:10 +0100
In-Reply-To: <104d4c9f-48d8-19b1-d529-a34fcc1e5606@wanadoo.fr>
References: <lsq.1589984008.562400019@decadent.org.uk>
         <95e4cf2d-5f50-e7bd-6e1e-a1d172eb24b6@wanadoo.fr>
         <104d4c9f-48d8-19b1-d529-a34fcc1e5606@wanadoo.fr>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-eGPjTjEFzfhK1i4lI6/p"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-eGPjTjEFzfhK1i4lI6/p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-05-21 at 16:31 +0200, Marion & Christophe JAILLET wrote:
> Hi,
>=20
> sorry for the noise, I have messed up my=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ usage.
> I thought I was looking at the 3.16.83 branch, but I was not.
>=20
> The patch looks good to me.

Thanks for reviewing,

Ben.

> CJ
>=20
> Le 21/05/2020 =C3=A0 16:09, Marion & Christophe JAILLET a =C3=A9crit :
> > Hi,
> >=20
> > I don't think that this one is applicable to 3.16.x
> >=20
> > The remove function and the error handling path of the probe function=
=20
> > both use 'dma_free_wc'.
> > I've not look in details, but it looks consistent and the patch would=
=20
> > not apply as-is anyway.
> >=20
> > just my 2c.
> >=20
> > CJ
> >=20
> > Le 20/05/2020 =C3=A0 16:14, Ben Hutchings a =C3=A9crit :
> > > 3.16.84-rc1 review patch.  If anyone has any objections, please let=
=20
> > > me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > >=20
> > > commit 3c911fe799d1c338d94b78e7182ad452c37af897 upstream.
> > >=20
> > > In the probe function, some resources are allocated using=20
> > > 'dma_alloc_wc()',
> > > they should be released with 'dma_free_wc()', not 'dma_free_coherent(=
)'.
> > >=20
> > > We already use 'dma_free_wc()' in the remove function, but not in the
> > > error handling path of the probe function.
> > >=20
> > > Also, remove a useless 'PAGE_ALIGN()'. 'info->fix.smem_len' is alread=
y
> > > PAGE_ALIGNed.
> > >=20
> > > Fixes: 638772c7553f ("fb: add support of LCD display controller on=
=20
> > > pxa168/910 (base layer)")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
> > > CC: YueHaibing <yuehaibing@huawei.com>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Link:=20
> > > https://patchwork.freedesktop.org/patch/msgid/20190831100024.3248-1-c=
hristophe.jaillet@wanadoo.fr
> > > [bwh: Backported to 3.16: Use dma_free_writecombine().]
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >   drivers/video/fbdev/pxa168fb.c | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > >=20
> > > --- a/drivers/video/fbdev/pxa168fb.c
> > > +++ b/drivers/video/fbdev/pxa168fb.c
> > > @@ -772,8 +772,8 @@ failed_free_cmap:
> > >   failed_free_clk:
> > >       clk_disable(fbi->clk);
> > >   failed_free_fbmem:
> > > -    dma_free_coherent(fbi->dev, info->fix.smem_len,
> > > -            info->screen_base, fbi->fb_start_dma);
> > > +    dma_free_writecombine(fbi->dev, info->fix.smem_len,
> > > +                  info->screen_base, fbi->fb_start_dma);
> > >   failed_free_info:
> > >       kfree(info);
> > >   failed_put_clk:
> > > @@ -809,7 +809,7 @@ static int pxa168fb_remove(struct platfo
> > >         irq =3D platform_get_irq(pdev, 0);
> > >   -    dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len)=
,
> > > +    dma_free_writecombine(fbi->dev, info->fix.smem_len,
> > >                   info->screen_base, info->fix.smem_start);
> > >         clk_disable(fbi->clk);
> > >=20
--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.



--=-eGPjTjEFzfhK1i4lI6/p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7G5FoACgkQ57/I7JWG
EQnlIg/8DPBUEQplThVJUI1rGjlEnVGkCtmkzyyIOrIH4eXPi9yVFAob/sClKsC6
cYQYp1W5q2Mb1wTSB7MqFaL8eA6naX4QAiGY5MuviH34EAR3t/PST1HG1zBrkQzE
SMNCXzO5tB1tTukEQ9eDhAS0my35LJUpmKXHgXILuChXMt6rabmzEGUtAAMblJuN
L1szUgfBw43stMq6wM5xpOH2RW1DR5Uklk7D6IDiyvCfXyDTBPUCaHOQhfoMh7pU
jgN2+Zd3xAK+COeim9HUxsAIuon0IrbjbPBoUR9jI4APNSxLHyVUcbh8YyeATmBK
o9QDmBNtOZipyWygY5T9R+58K7VMQlcv0H++s6Cx4ucViVjufWN7Fs3iG9JOc6tl
slRDOVMK3CldbdxpTTj+1GHpwtwGYTbhoMT7Y+JZSFw4FGFmn90vM+TK7VaRy3bH
T3fDUo1rTboeas4f+15fnbpNScnz2ZEfSY43/3vvz7jpCn5uHoaeysuTrooUp1bn
b0juvE4XCh6jtokd3Q4KFKP8Dy4NU6E6+J6PhqFVwXftsmYmlXxDueXuTHQu7HUX
uenwyaz4phkfbj40Ecl7iziaPn8jCUZUjakYaE0nxw/FTAHEheEZsSjKdcqA/aN3
lH5mFYc0xvuYgkI6heaSzvvqnezNMVk6bsas+TkQu65Qn8J1qR0=
=fXcE
-----END PGP SIGNATURE-----

--=-eGPjTjEFzfhK1i4lI6/p--
