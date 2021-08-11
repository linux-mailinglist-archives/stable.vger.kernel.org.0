Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70073E8AFD
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhHKHY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:24:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39524 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbhHKHY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 03:24:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8F2F11C0B77; Wed, 11 Aug 2021 09:24:34 +0200 (CEST)
Date:   Wed, 11 Aug 2021 09:24:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 4.19 36/54] tee: add tee_shm_alloc_kernel_buf()
Message-ID: <20210811072434.GB10829@duo.ucw.cz>
References: <20210810172944.179901509@linuxfoundation.org>
 <20210810172945.369365872@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20210810172945.369365872@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit dc7019b7d0e188d4093b34bd0747ed0d668c63bf upstream.
>=20
> Adds a new function tee_shm_alloc_kernel_buf() to allocate shared memory
> from a kernel driver. This function can later be made more lightweight
> by unnecessary dma-buf export.

5.10 contains follow-up patches actually using the export, but 4.19
does not. I believe it should be dropped from 4.19.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRN7MgAKCRAw5/Bqldv6
8gfNAJ9rJTDpB4HbB3M3bF/lAavCwsnk8gCeLvapwhiWui4SB75VY2nYlJNXL98=
=7cDG
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
