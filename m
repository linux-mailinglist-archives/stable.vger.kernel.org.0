Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02240BA32C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 18:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbfIVQdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 12:33:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50728 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387745AbfIVQdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Sep 2019 12:33:24 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iC4na-0004Nv-6N; Sun, 22 Sep 2019 17:33:22 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iC4nZ-0001Ih-VF; Sun, 22 Sep 2019 17:33:21 +0100
Message-ID: <70fd21c92c10c0ed08d647d5a67310c20ff9f052.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sun, 22 Sep 2019 17:33:17 +0100
In-Reply-To: <63537eba-48f6-a394-f220-45b4ad543dee@roeck-us.net>
References: <lsq.1568989414.954567518@decadent.org.uk>
         <20190920200423.GA26056@roeck-us.net>
         <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
         <63537eba-48f6-a394-f220-45b4ad543dee@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-t/NL/Z79JmtltRmHOd3K"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-t/NL/Z79JmtltRmHOd3K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-09-20 at 18:35 -0700, Guenter Roeck wrote:
> On 9/20/19 2:16 PM, Ben Hutchings wrote:
> > On Fri, 2019-09-20 at 13:04 -0700, Guenter Roeck wrote:
> > > On Fri, Sep 20, 2019 at 03:23:34PM +0100, Ben Hutchings wrote:
> > > > This is the start of the stable review cycle for the 3.16.74 releas=
e.
> > > > There are 132 patches in this series, which will be posted as respo=
nses
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
> > > > Anything received after that time might be too late.
> > > >=20
> > >=20
> > > Build results:
> > > 	total: 136 pass: 135 fail: 1
> > > Failed builds:
> > > 	arm:allmodconfig
> > > Qemu test results:
> > > 	total: 229 pass: 229 fail: 0
> > >=20
> > > Build errors in arm:allmodconfig are along the line of
> > >=20
> > > In file included from include/linux/printk.h:5,
> > >                   from include/linux/kernel.h:13,
> > >                   from include/linux/clk.h:16,
> > >                   from drivers/gpu/drm/tilcdc/tilcdc_drv.h:21,
> > >                   from drivers/gpu/drm/tilcdc/tilcdc_drv.c:20:
> > > include/linux/init.h:343:7: error: 'cleanup_module'
> > > 	specifies less restrictive attribute than its target 'tilcdc_drm_fin=
i': 'cold'
> > >=20
> > > In addition to a few errors like that, there are literally thousands
> > > of similar warnings.
> >=20
> > It looks like this is triggered by you switching arm builds from gcc 8
> > to 9, rather than by any code change.
> >=20
>=20
> After reverting to gcc 8.3.0 for arm, I get:
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0
>
> Sorry for the noise.

Great, thanks for checking.

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett



--=-t/NL/Z79JmtltRmHOd3K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2Hok0ACgkQ57/I7JWG
EQn8TQ/+LbWjYZ1CLsHC8nr7ODBS2AU7AFGfWX+sGLIZAYusGZ9ULZ+oaqUhlCOH
hPElZD1A7l0D5PszfnMweAxF2yseoosUS2TrjwoFhgFH5tpz9bjKOq7dSfkTcqaw
yiVQGyYmKbJt1EDQE95/qdGfweppUADgo9cjYCiNouvlHSm5wVBSTtp2VAL6XdLd
IoO9+fs2n+SQEV12Tvrdz5fcWOLvpPzbkeH2MXXGsynmvD1YEW1B/Dg8Grg73b04
qLZnlNetkWDQs9HSsxPM4WghTWrpMm6VuXweBIwP2JxZBfCdhVGoHjVZYxT62Q5k
LiQYSOdH+/oBRhXwao2zU3aMF47MGh+I5S2fcm6a8kP1Ia8R3BnABPceYkLJVtjM
Hel2bWplKU/yLNPy+J4wWxAxy4PQhtNFUMGyedI1C/7nY1QgDL7mNHqXnPAHWA0t
rY4JbthPTGI+mkR7Vgm190vnm4H2CvuZeqcVX0+kXiuRw1q+2S4IoAP4P03Z2xvF
/MTlk2ADnGg+YWdRNovOoRRulvPruPahGpxpN7UM6RBJBEe1Mnwh96lCg7Rhq9IR
TjzRvQAEx3cOJWa/5iW+OjgljSq9gUTfnX17+0brkxb6TEVeTaurxuxgjasCbcEl
mpfTju5T8pBiyk5ECx11HItmXUB5Mx25Krn8ENLuApNuxgkKAkE=
=sc49
-----END PGP SIGNATURE-----

--=-t/NL/Z79JmtltRmHOd3K--
