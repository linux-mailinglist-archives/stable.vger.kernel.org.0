Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF125410D05
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 21:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhISTQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 15:16:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35312 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhISTQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 15:16:42 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E6B211C0B82; Sun, 19 Sep 2021 21:15:15 +0200 (CEST)
Date:   Sun, 19 Sep 2021 21:15:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 080/306] SUNRPC query transports source port
Message-ID: <20210919191515.GC12836@amd>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155756.781145663@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <20210916155756.781145663@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a8482488a7d6d320f63a9ee1912dbb5ae5b80a61 ]
>=20
> Provide ability to query transport's source port.

This adds unused function to 5.10 kernel. Next patch fixes it up, but
user does not show up. Do we want it in 5.10-stable?

Best regards,
								Pavel

> +++ b/net/sunrpc/xprtsock.c
> @@ -1639,6 +1639,13 @@ static int xs_get_srcport(struct sock_xprt *transp=
ort)
>  	return port;
>  }
> =20
> +unsigned short get_srcport(struct rpc_xprt *xprt)
> +{
> +	struct sock_xprt *sock =3D container_of(xprt, struct sock_xprt, xprt);
> +	return sock->srcport;
> +}
> +EXPORT_SYMBOL(get_srcport);
> +
>  static unsigned short xs_next_srcport(struct sock_xprt *transport, unsig=
ned short port)
>  {
>  	if (transport->srcport !=3D 0)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFHjEMACgkQMOfwapXb+vJ4iQCfUMaMR3foHMBW/0B/hbsMKLs+
OHMAoJMJn1EagVCn597O71ll0htPse+q
=lCw6
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
