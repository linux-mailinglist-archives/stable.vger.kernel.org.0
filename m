Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419681DD82E
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgEUUW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:22:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41766 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgEUUW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:22:26 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrhv-0004ru-CI; Thu, 21 May 2020 21:22:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrhu-007Kwm-U7; Thu, 21 May 2020 21:22:22 +0100
Message-ID: <7e11d3c7436ee273d7ec6a592d6c6091f0f8f85a.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/99] 3.16.84-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, Chen-Yu Tsai <wens@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 21 May 2020 21:22:22 +0100
In-Reply-To: <96227771-f6bd-9508-5a68-ab35df370dc1@roeck-us.net>
References: <lsq.1589984008.673931885@decadent.org.uk>
         <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
         <CAGb2v65AGb+4=+vRn2OdBx=fYXmZLFqASsyh-xh=ruCgbg92ng@mail.gmail.com>
         <96227771-f6bd-9508-5a68-ab35df370dc1@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-hSJFVF7Wr7gbqaVo7CeE"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hSJFVF7Wr7gbqaVo7CeE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-05-21 at 00:40 -0700, Guenter Roeck wrote:
> On 5/20/20 7:47 PM, Chen-Yu Tsai wrote:
> > On Thu, May 21, 2020 at 5:23 AM Guenter Roeck <linux@roeck-us.net> wrot=
e:
> > > On 5/20/20 7:13 AM, Ben Hutchings wrote:
> > > > This is the start of the stable review cycle for the 3.16.84 releas=
e.
> > > > There are 99 patches in this series, which will be posted as respon=
ses
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Fri May 22 20:00:00 UTC 2020.
> > > > Anything received after that time might be too late.
> > > >=20
> > > Build results:
> > >         total: 135 pass: 135 fail: 0
> > > Qemu test results:
> > >         total: 230 pass: 227 fail: 3
> > > Failed tests:
> > >         arm:cubieboard:multi_v7_defconfig:mem512:sun4i-a10-cubieboard=
:initrd
> > >         arm:cubieboard:multi_v7_defconfig:usb:mem512:sun4i-a10-cubieb=
oard:rootfs
> > >         arm:cubieboard:multi_v7_defconfig:sata:mem512:sun4i-a10-cubie=
board:rootfs
> > >=20
> > > The arm tests fail due to a compile error.
> > >=20
> > > drivers/clk/tegra/clk-tegra-periph.c:524:65: error: 'CLK_IS_CRITICAL'=
 undeclared here (not in a function); did you mean 'CLK_IS_BASIC'?
> >=20
> > This looks like a result of having
> >=20
> >       clk: tegra: Mark fuse clock as critical
> >          [bf83b96f87ae2abb1e535306ea53608e8de5dfbb]
> >=20
> > In which case you probably need to add
> >=20
> >     32b9b1096186 clk: Allow clocks to be marked as CRITICAL
> >=20
>=20
> Then you might also need commit ef56b79b66f ("clk: fix critical
> clock locking") which fixes it.

At this stage I don't think it makes sense to add the feature to 3.16.

Ben.

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.



--=-hSJFVF7Wr7gbqaVo7CeE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7G4v4ACgkQ57/I7JWG
EQkgSw/+LagJKQzKmAk/GprCRUkrmizL1QWZDT1a+gOW/9rqPaujDO0wkqyDn2fC
2FC4cqwaSD9ZUOmaV2ip1scZdYFZMGoWTeOegaU+bQ58YWrbqy1/33VrXqpNie3/
wpRx3ET0vICe4Gk3InjUDlENvVTxPq/EwBfpfZxTXzKOQgI1k1SK4l21/5yV055a
cEXjE7qcnTTHDS9FRNlrB2kNYZxg4eLysd6Ld7KvFUw9gO+pUdUryx2eT2nwBQsW
gOoD1KOM1DiaJcYTiUL5HWydswtAJc/yWc7g0RbLY+6ZvtSHmiUjwk1/emlV4mHb
nI8TJ1wZHu/qGmaFZWlI1Q0rU83/ueHks3PiNuKq6+kzfniU9knRuqMJTFRksmg2
rqCWjeZ9oPAY0tZPP+mcEZCHzw2g7a1NVgBpwetKNfHDzvySTlWyqoOV08JXhMd8
mrNln0rhrI0+BijcQmj+TIntoji13YIiQ9XIrLlYsjzaFWvarlfGpcZarbzOPcp7
zBCBmUgcLNQyXgXQrM9sqrDaiMM+txT2Vg4GH1oktJrGXuHWFJP3TPfx9w+ABRi7
++4YG2qiFidYYIoCCNPcWS8ngDYFlqd+WSrYCHBEVAidPIFNTAB18K2YMl6Ba1HU
WmtUrr7ytiHjfMfFay4cjeCFdfLsHuGIqVfeC3QkO1eJCzWRC8E=
=aajN
-----END PGP SIGNATURE-----

--=-hSJFVF7Wr7gbqaVo7CeE--
