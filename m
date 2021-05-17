Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8DB386CF5
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 00:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343810AbhEQWbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 18:31:45 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:57602 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbhEQWbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 18:31:36 -0400
Date:   Tue, 18 May 2021 00:30:15 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Greg KH <greg@kroah.com>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <1621290515@msgid.manchmal.in-ulm.de>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de>
 <1621251685@msgid.manchmal.in-ulm.de>
 <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
 <1621254246@msgid.manchmal.in-ulm.de>
 <CA+res+QRm3VyJSjMaKLYm=KY5+T5nX+6-QhOgrgBcP+d2Ganag@mail.gmail.com>
 <YKJ5ysGAuI32Jpn6@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v2Uk6McLiE8OV1El"
Content-Disposition: inline
In-Reply-To: <YKJ5ysGAuI32Jpn6@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v2Uk6McLiE8OV1El
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg KH wrote...

> On Mon, May 17, 2021 at 02:45:01PM +0200, Jack Wang wrote:

> > So it's caused by this commit[1], and it should be fixed by latest
> > 5.10.38-rc1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git/log/?h=3Dlinux-5.10.y
> > [1]https://lore.kernel.org/stable/20210515132855.4bn7ve2ozvdhpnj4@nabok=
ov.fritz.box/
>=20
> Hopefully the "real" 5.10.38-rc1 release that is out now should fix
> this.  If not, please let us know.

Good news: Fixed with that "real" 5.10.38-rc1.

    Christoph

--v2Uk6McLiE8OV1El
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAmCi7m8ACgkQxCxY61kU
kv3R1w/+OsPyGGnxeMcCjTZTrn/+WJFpR9fcHM13lTfgwjznk+gdR3uQ0QL6la0X
ros7A94fRiJ6QOhl3K5IiuNS7F+mOaaFaSrPtUzFgvqnroj+0tzya6ISxJJQpRSe
GQV/RO/iN8dL1+lnRDDSqIsQmXQrrPgog7Z1XdvDZ43TfRPNMgfoFFgvfyKeOiqk
V7shbi2R7d2kvlPmPV3Mva8Xg+di/KUePLFUT5z8Nvd1c+knA/m2SqCEQ3B79WWC
bzpb/EdxGOQAvj/lgU7vuXvhKKj+1k5+gpr/VVIYdXxwYl26LoKOLpGkWNKnOqZ9
AXVJq/6Zne3h7WKivAYSAq5LOJpeKpCKmOnVNmvZXWe55t8sCPeh6KAP4hJpIY2x
VVyZWsolt8nb8vEyVRn89oJbJfbmY2XaKqphysjr0PDMizmiD3/MAS0C9U6tn/33
OgQHs88svvSC895bCrg3BtzU9SLcboSFpcOpGvL90Oz8vPEwv5ya1zOLqVWR0Qvc
WzXh6CrZ10tUJ5Dak5YCyLwhauCJJ7hDO36t0KYrKCtZseQj8tMm/L+YnIXR4Kia
MU8XasRAI9MVo8EAcJnq83tpMOHVGxTM6EUP1xpeD+tuVjB88Rr4zHcjfP9etdlx
GMvN5TMHQQYK8sZUQyctbW8c8pM0HS6/7iWJqNLWQMFjCVLlHSM=
=BFBR
-----END PGP SIGNATURE-----

--v2Uk6McLiE8OV1El--
