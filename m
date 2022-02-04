Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002204A9783
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 11:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358215AbiBDKMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 05:12:53 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34668 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiBDKMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 05:12:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 36EFC1C0B79; Fri,  4 Feb 2022 11:12:50 +0100 (CET)
Date:   Fri, 4 Feb 2022 11:12:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH 5.10 08/25] perf: Rework perf_event_exit_event()
Message-ID: <20220204101249.GB27857@amd>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.560626177@linuxfoundation.org>
 <20220204093734.GA27857@amd>
 <Yfz0nWtyap5Y3ogJ@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <Yfz0nWtyap5Y3ogJ@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2022-02-04 10:40:45, Greg Kroah-Hartman wrote:
> On Fri, Feb 04, 2022 at 10:37:35AM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Peter Zijlstra <peterz@infradead.org>
> > >=20
> > > commit ef54c1a476aef7eef26fe13ea10dc090952c00f8 upstream.
> > >=20
> > > Make perf_event_exit_event() more robust, such that we can use it from
> > > other contexts. Specifically the up and coming remove_on_exec.
> >=20
> > Do we need this in 5.10? AFAICT the remove_on_exec work is not queued
> > for 5.10, and this patch is buggy and needs following one to fix it
> > up.
>=20
> It's needed by the following patch, which says 5.10 is affected.

9/25 says this patch broke 5.10: Fixes: ef54c1a476ae ("perf: Rework
perf_event_exit_event()"). 8/25 is not claiming to fix anything.

Simply drop 8/25 and 9/25, and 5.10 is okay...

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmH8/CEACgkQMOfwapXb+vKxAQCgpmftfrOaQRHFHxkOvfPV8ePD
cOQAn3PHmS8LM7CgQFVqHdINgaEP0l+M
=L6MF
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
