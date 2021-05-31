Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7E3968B8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhEaU2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:28:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51322 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhEaU2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:28:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 22BD71C0B7C; Mon, 31 May 2021 22:26:37 +0200 (CEST)
Date:   Mon, 31 May 2021 22:26:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH 5.10 053/252] serial: core: fix suspicious
 security_locked_down() call
Message-ID: <20210531202636.GB18772@amd>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130659.786984803@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20210531130659.786984803@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ondrej Mosnacek <omosnace@redhat.com>

=2E..

> Fixes: 794edf30ee6c ("lockdown: Lock down TIOCSSERIAL")
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20210507115719.140799-1-omosnace@redhat.c=
om
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm not sure if it is going to cause any problems, but two signoffs
like this look quite unusual.

Best regards,
							Pavel
						=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1RnwACgkQMOfwapXb+vKKTgCgi8kd6RMnPVZAoZHERWV1D7At
jGkAoIFkCEhKPzAlI8w6Z9DYTT9Yzp0A
=KJhG
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
