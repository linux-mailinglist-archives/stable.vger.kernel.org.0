Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB0F28AAD1
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 00:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgJKWDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 18:03:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54376 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKWDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 18:03:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5813A1C0B77; Mon, 12 Oct 2020 00:03:38 +0200 (CEST)
Date:   Mon, 12 Oct 2020 00:03:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 21/38] spi: fsl-espi: Only process interrupts for
 expected events
Message-ID: <20201011220337.GA21317@amd>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.694666032@linuxfoundation.org>
 <20201006193634.GB8771@duo.ucw.cz>
 <e96519d3-8b58-4715-1ada-6139749e6da3@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <e96519d3-8b58-4715-1ada-6139749e6da3@alliedtelesis.co.nz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> [ Upstream commit b867eef4cf548cd9541225aadcdcee644669b9e1 ]
> >>
> >> The SPIE register contains counts for the TX FIFO so any time the irq
> >> handler was invoked we would attempt to process the RX/TX fifos. Use t=
he
> >> SPIM value to mask the events so that we only process interrupts that
> >> were expected.
> >>
> >> This was a latent issue exposed by commit 3282a3da25bd ("powerpc/64:
> >> Implement soft interrupt replay in C").
> > We don't seem to have commit 3282... in 4.19, so we don't need this
> > one in 4.19-stable according to the changelog.
> Technically 3282... exposed the issue by making it more likely to happen=
=20
> so 4.19 might just have a really low probability of seeing the issue (I=
=20
> think I did try reproducing it on kernels of that vintage). Personally=20
> I'm not too fussed the kernel versions I care about have the fix. Maybe=
=20
> someone from NXP cares enough to pursue it.

Okay, I guess low-probability bugs are still fair game for
-stable. The commit was not dropped from 4.19, so nothing needs to be
done here.

Sorry for the noise,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+DgTkACgkQMOfwapXb+vJkNgCgjq6ULenHyb9JLZZNXtmSMQBD
jW0An0L/u8/KrR5KDde+rGieiXyNeQf/
=W3dM
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
