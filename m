Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B9829D6A1
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgJ1WQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:16:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54638 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730800AbgJ1WQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:16:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D77A11C0BAC; Wed, 28 Oct 2020 07:58:04 +0100 (CET)
Date:   Wed, 28 Oct 2020 07:58:04 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.19 018/264] chelsio/chtls: correct function return and
 return type
Message-ID: <20201028065803.GA8084@amd>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135431.522408687@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20201027135431.522408687@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>=20
> [ Upstream commit 8580a61aede28d441e1c80588803411ee86aa299 ]
>=20
> csk_mem_free() should return true if send buffer is available,
> false otherwise.

> Fixes: 3b8305f5c844 ("crypto: chtls - wait for memory sendmsg, sendpage")

This does not fix anything. In fact, binary code should be exactly
equivalent. It does not need to be in 4.19-stable.

Best regards,
								Pavel


> --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> @@ -914,9 +914,9 @@ static int tls_header_read(struct tls_hd
>  	return (__force int)cpu_to_be16(thdr->length);
>  }
> =20
> -static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
> +static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
>  {
> -	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
> +	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
>  }
> =20
>  static int csk_wait_memory(struct chtls_dev *cdev,
>=20

--=20
http://www.livejournal.com/~pavelmachek

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+ZFnsACgkQMOfwapXb+vJNTgCeItp/T9ZclAOY2oIVNBMk8CoR
lA4AoLJMrpmAXhRkMkZ511r7rU8Romm1
=0raj
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
