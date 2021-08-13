Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222F53EBCDB
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhHMTzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 15:55:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52266 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbhHMTzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 15:55:51 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8FCF81C0B76; Fri, 13 Aug 2021 21:55:23 +0200 (CEST)
Date:   Fri, 13 Aug 2021 21:55:23 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.10 04/19] bpf: Add _kernel suffix to internal
 lockdown_bpf_read
Message-ID: <20210813195523.GA4577@duo.ucw.cz>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150522.774143311@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20210813150522.774143311@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Daniel Borkmann <daniel@iogearbox.net>
>=20
> commit 71330842ff93ae67a066c1fa68d75672527312fa upstream.
>=20
> Rename LOCKDOWN_BPF_READ into LOCKDOWN_BPF_READ_KERNEL so we have naming
> more consistent with a LOCKDOWN_BPF_WRITE_USER option that we are
> adding.

As far as I can tell, next bpf patch does not depend on this one and
we don't need it in 5.10. (Likely same situation with 5.13).

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRbOKwAKCRAw5/Bqldv6
8rkbAKC8/UThc601ypMAptZLgZZZswLUzACghlIN4L2iQoOTHHEeyDKqsZPQnvE=
=Yxs9
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
