Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5965C1CC48
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENPyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 11:54:54 -0400
Received: from sauhun.de ([88.99.104.3]:48886 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfENPyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 11:54:54 -0400
Received: from localhost (p54B3310E.dip0.t-ipconnect.de [84.179.49.14])
        by pokefinder.org (Postfix) with ESMTPSA id 580052C2868;
        Tue, 14 May 2019 17:54:51 +0200 (CEST)
Date:   Tue, 14 May 2019 17:54:51 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     "George G. Davis" <george_davis@mentor.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chris Brandt <chris.brandt@renesas.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS 
        <devicetree@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] serial: sh-sci: disable DMA for uart_console
Message-ID: <20190514155450.GB6508@kunai>
References: <1557762446-23811-1-git-send-email-george_davis@mentor.com>
 <CAMuHMdVaNWa=Q-7K-+_rM-8yYWB0-+4_o4hgACK6o-4BOrY07A@mail.gmail.com>
 <20190514153021.GC18528@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20190514153021.GC18528@mam-gdavis-lt>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > Fixes: https://patchwork.kernel.org/patch/10929511/
> >=20
> > I don't think this is an appropriate reference, as it points to a patch=
 that
> > was never applied.
>=20
> I included it as a link to an upstream problem report similar to other co=
mmits
> that I previewed. The link provides the extra context that I was perhaps =
to
> lazy to note in the commit header.

We have a "Link:" tag for things like this, e.g.:

Link: https://patchwork.kernel.org/patch/10929511/


--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlza5MYACgkQFA3kzBSg
KbbkfQ/+PL1lLGOvBp4WLSQof0j9gnQWmDJDxCG61/wtuAsqm6CkBe4BlgZIhoDq
ZgOk6lcFvge3gPJPP+DOiPVa9Uebjx84+gJV8t/hJx5EkZ5d/VBzxLS9C74ae9KQ
yC1BN8slbFbu4aS4bzbOoYCOGjRq2Wh7Se6MtdV5pCHZA6DxV60KvbrwvgVD8DrT
2YgoyE5pVyou/2gn4FxoUVzKDPTxvFr7rTTcJLHdEBXiXxy5x+5gBIGsl0521+qy
XIsJdaQXkI1wyssp/gRrUhZiAf/Du8W9MW0g4vXTC0a7nX8O5ENKW23FyV6FrzoX
BpPl7ICCxAarMabDkaNvhlO+TCC8f88yhYaiZ8UZ2ZyzIg8MPGJBQ0jdOTOeWjkU
DoLS5eVr8C2N9jT6iFY/f2UI/RfJlCx2gjdpgX23dUtn2uAkGjeFke4hXN0hmNnF
HYHyfTDOODnfnM3QzowRGaMOHE9nVcUcTcR5VKK8M0GtnzKHr8yBzfFJJkfKeiHi
CLjR9N37CcCUCKe5qDhIxwnmkXjJoUp6rgZxAS2hewGiv/CKi0WtfCvk6BzEkUV9
Eg3rZ1Ipeqt0fSHK4EK4ltIrs+iSZp+nhx7W61UE2teWQ6IG+weOdVvBCHpe9FUN
6RMlFFMcVzfvFKw2z+Q8uua9EPlKFFnUe7SAbydWO7d81KNyUGI=
=BcaQ
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
