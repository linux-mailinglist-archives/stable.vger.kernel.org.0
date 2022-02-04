Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB64A96F1
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiBDJhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:37:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60026 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbiBDJhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:37:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 027111C0B79; Fri,  4 Feb 2022 10:37:36 +0100 (CET)
Date:   Fri, 4 Feb 2022 10:37:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH 5.10 08/25] perf: Rework perf_event_exit_event()
Message-ID: <20220204093734.GA27857@amd>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.560626177@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20220204091914.560626177@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Peter Zijlstra <peterz@infradead.org>
>=20
> commit ef54c1a476aef7eef26fe13ea10dc090952c00f8 upstream.
>=20
> Make perf_event_exit_event() more robust, such that we can use it from
> other contexts. Specifically the up and coming remove_on_exec.

Do we need this in 5.10? AFAICT the remove_on_exec work is not queued
for 5.10, and this patch is buggy and needs following one to fix it
up.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmH8894ACgkQMOfwapXb+vKK7ACfSNtFyXrTWRJ+yDREXewFddJN
OHwAn1yKQXsGWjcSAHf3tokavGz9cqIb
=bzKq
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
