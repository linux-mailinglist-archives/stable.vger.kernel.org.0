Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B283D81D8
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 23:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhG0Vft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 17:35:49 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33924 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0Vft (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 17:35:49 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F39E31C0B76; Tue, 27 Jul 2021 23:35:46 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:35:46 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Ekstrand <jason@jlekstrand.net>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 5.10 154/167] Revert "drm/i915: Propagate errors on
 awaiting already signaled fences"
Message-ID: <20210727213546.GA20206@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153844.582795218@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20210726153844.582795218@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

According to changelog, this introduces security hole.

> From: Jason Ekstrand <jason@jlekstrand.net>
>=20
> commit 3761baae908a7b5012be08d70fa553cc2eb82305 upstream.
>=20
> This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> since that commit, we've been having issues where a hang in one
> client

Hmm. Sounds like problem I'm seeing in mainline. So... good to know.

> For backporters: Please note that you _must_ have a backport of
> https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstran=
d.net/
> for otherwise backporting just this patch opens up a security bug.

AFAICT we don't have that c9d9fdbc108af8915d3f497bbdf3898bf8f321b8
drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser" in 5.10 tree.

Hmm, and it needs follow up fix:
6e0b6528d783b2b87bd9e1bea97cf4dac87540d7 drm/i915: Correct the docs
for intel_engine_cmd_parser.

(Someone please double check this).

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEAfDIACgkQMOfwapXb+vIomACgizrxI1sVaubakjiv7j7/yPSr
XAoAoLfLe75C/9jBjXp3wcTz2ueUyNMh
=lUJL
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
