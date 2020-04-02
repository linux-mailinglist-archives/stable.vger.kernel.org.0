Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9286719CAA1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgDBTx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:53:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49410 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBTx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:53:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A654F1C3115; Thu,  2 Apr 2020 21:53:24 +0200 (CEST)
Date:   Thu, 2 Apr 2020 21:53:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 4.19 105/116] bpf: Explicitly memset the bpf_attr
 structure
Message-ID: <20200402195324.GB8077@duo.ucw.cz>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161555.630698707@linuxfoundation.org>
 <20200402185320.GA8077@duo.ucw.cz>
 <20200402192053.GB3243295@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <20200402192053.GB3243295@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Should we fix gcc, instead?
>=20
> Also, this is allowed in the C standard, and both clang and gcc
> sometimes emit code that does not clear padding in structures.  Changing
> the compiler to not do this would be wonderful, but we still have to
> live with this for the next 10 years as those older compilers age-out.

I agree C standard allows this. It allows to even worse stuff.

I was just surprised that gcc does that.. and that I did not know
about this trap. I was probably telling people to do =3D {} for
structure init...

Should we get "=3D {}" warning for checkpatch?

Is it fair to replace "=3D {}" with memset() as soon as it is returned
to userland, without testing that gcc "miscompiles" this particular
example?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXoZCswAKCRAw5/Bqldv6
8ihMAKC1+WCBXYMpLVByngW+zSRcQ6dYTQCgsZPj1kGk3M52HSqBA3cV4hDWyYQ=
=ixSY
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
