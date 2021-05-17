Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C4D382C0A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhEQM0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:26:40 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:54674 "EHLO
        manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbhEQM0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:26:35 -0400
Date:   Mon, 17 May 2021 14:25:16 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config
 does
Message-ID: <1621254246@msgid.manchmal.in-ulm.de>
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de>
 <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de>
 <1621251685@msgid.manchmal.in-ulm.de>
 <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jack Wang wrote...

> Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> =E4=BA=8E2021=E5=
=B9=B45=E6=9C=8817=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=881:52=E5=86=
=99=E9=81=93=EF=BC=9A
> >
> > Christoph Biedl wrote...
> >
> > > Thanks for taking care, unfortunately no improvement with 5.10.38-rc1=
 here.
> >
> > So in case this is related to the .config, I'm attaching it. Hardware i=
s,
> > as said before, an old Thinkpad x200, vendor BIOS and no particular mod=
ifications.
> > After disabling all vga/video/fbcon parameters I see the system suffers
> > a kernel panic but unfortunately only the last 25 lines are visible.
> > Possibly (typos are mine)
> >
> >     RIP: 0010:__domain_mapping+0xa7/0x3a0
> >
> > is a hint into the right direction?
> This looks intel_iommu related, can you try boot with
> "intel_iommu=3Doff" in kernel parameter?

Gotcha. System boots up fine then.

    Christoph

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEWXMI+726A12MfJXdxCxY61kUkv0FAmCiYKkACgkQxCxY61kU
kv3OtA//ddEx7kYOaHzvJ9W3qeGm1BuDAC6kNguj/roud2NdKWERoVT++17Zbplq
bWic8NQLO5aKdi3hUD6Jn1HJMSuRVf4icnpTPaIpZD3VzS9fAB17owi5UnDlHlRI
P+Vg/bp+CtRMzPpSe4iK9Z/or9BPorej7FdFIMieRmfeqBG3+ZC0geaUfiKhF8Dr
NJmGY+/kPAcJmfy2vfesQ53KL/C6nv9q43oK6pQx0wpieuRRdE2nP0Vu8XQVX73S
op4KDeM43zpzXJnl5CmbGr3EwZARuALMEg0W8jLZDFnFn22ZAaYDS3JlBOLTNQeG
pCUwuijWjgAwV34gKnA5EbMRdqomRMb1d2AAhIKBTPIwdLgygepJChl7m1Mgbru8
eb9Cr0bxam7hVrQea+4GIRnRKynAAAj/GhwRyHqUDscY4xHDiLLlODpyrTlEIvp8
D29QYGDA/onIiv+SKARgm7y7HbvGmgRywPwfxK1cRDVHJ+UCxQ11mA5xVwi9gZxJ
FYAcQTj3LZZNIsw+fFDbDzB2VCLl8NwIMEvoMlE5looOL7QfL9A7nEzn+GfA+FDJ
wafcXOyD+HVOLa3+O5LmZqoodUvn1FoMAYidhof57hqELjmmeWtRRzj7iHxtI5ox
aCarbYOmuSqNfOv3YGPHtX5CA9EyCVFcCUnZUjRxuDZEmhQSGTw=
=53rx
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
