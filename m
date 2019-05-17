Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7F821670
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 11:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfEQJmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 05:42:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49946 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729022AbfEQJmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 05:42:37 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRZNo-0001cl-2u; Fri, 17 May 2019 10:42:32 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRZNn-0003cN-TD; Fri, 17 May 2019 10:42:31 +0100
Message-ID: <a09049c8a31e05447bb750ca7a3822b223588edc.camel@decadent.org.uk>
Subject: Re: [PATCH 4.4 180/266] x86: stop exporting msr-index.h to userland
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 17 May 2019 10:42:26 +0100
In-Reply-To: <20190517080637.GA17012@amd>
References: <20190515090722.696531131@linuxfoundation.org>
         <20190515090729.016771030@linuxfoundation.org> <20190517080637.GA17012@amd>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Q5jGkmlNyuSlyx6Q8HIY"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Q5jGkmlNyuSlyx6Q8HIY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-05-17 at 10:06 +0200, Pavel Machek wrote:
> Hi!
>=20
> > commit 25dc1d6cc3082aab293e5dad47623b550f7ddd2a upstream.
> >=20
> > Even if this file was not in an uapi directory, it was exported
> > because
> > it was listed in the Kbuild file.
> >=20
>=20
> While good idea for mainline, I don't think this belongs to stable.
>=20
> Dropping it should not result in problems.

If we apply "x86/msr-index: Cleanup bit defines" and not this, then
"make headers_install" stops working.

Ben.

--=20
Ben Hutchings
Man invented language to satisfy his deep need to complain.
                                                          - Lily Tomlin


--=-Q5jGkmlNyuSlyx6Q8HIY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzeggIACgkQ57/I7JWG
EQnwCg//bF0cD5vgPbIOInR4E9r98yKLE+GIcH+M5+SdBqFaxn/2yGp1qAeQgJA9
oebAcs95QSkccWgcaBSQQZb1rmvBtP7XydFe8c+OfUUAbEcM4DO70YIrvJ5GA4K6
5OQaVN/9hEevM+Bja0U0367uDtMys+ayC0UG1NKZibuT2XzpXso/ZXe9LDn7Rvzl
sbgf9Zth/WntmcL/KmukT5znDomi4nGxuleLTkGuxFTXDqoGggh62tonQMLAN3RW
qptrou1NHO7B2Qp6mh5pOGqU9RmiZGv/v8EB0/fyjNk37ceV1asIDIRHI6VXi3th
cvpffpu/Hquk8OKJ5P/DutMB3B1TqlT7Izyw4z18xAVFAHtfd6TDeQ+EyzXNZ6du
ML4wfz5gIyvhjkey5b+8a25Xv3mbWjAPcfP3HY2c8bLsteFGled6losO/ffd3A6J
Qk88TLDegCYjkvtW8VY5vKQvNL2OXY50txr0ZBt8nAntVb8IWMm+iTj7iI7yn7Te
sC1rTTKGcaUva5decfewJxfPkA3tWYYwxkh4mkWs3xwnwKIIQrN2Yt8nOEXBsihM
mJ7aFMf3Ae0y8xIDP1mIEKstmWkKXX894Xjpj6/z3cw1fO9teqZNE1dzaVqmT3yU
NMeuMR/5wFVNQRF2tb2m0F7CYZMeCgvk6SKlG6PBO50PsnUupTc=
=37Qy
-----END PGP SIGNATURE-----

--=-Q5jGkmlNyuSlyx6Q8HIY--
