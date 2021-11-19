Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8945784C
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhKSVs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 16:48:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45688 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbhKSVs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 16:48:28 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8A4211C0BAA; Fri, 19 Nov 2021 22:45:24 +0100 (CET)
Date:   Fri, 19 Nov 2021 22:45:22 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10 03/21] loop: Use blk_validate_block_size() to
 validate block size
Message-ID: <20211119214522.GA23353@amd>
References: <20211119171443.892729043@linuxfoundation.org>
 <20211119171444.002617211@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20211119171444.002617211@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit af3c570fb0df422b4906ebd11c1bf363d89961d5 upstream.
>=20
> Remove loop_validate_block_size() and use the block layer helper
> to validate block size.

This is just a cleanup, and it needs previous cleanup to be
applied. I would not mind if both were dropped from stable series.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGYGvIACgkQMOfwapXb+vIFOQCeNUN9DNC5RArImjX8Kwg4axXF
XBYAoIPvOEm+53K6UGouBlMtcgNeN82F
=71AH
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
