Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B93D0411
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 23:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGTVI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 17:08:29 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42104 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhGTVIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 17:08:11 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6CED81C0B7C; Tue, 20 Jul 2021 23:48:48 +0200 (CEST)
Date:   Tue, 20 Jul 2021 23:48:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wysochanski <dwysocha@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 147/243] NFSD: Fix TP_printk() format specifier in
 nfsd_clid_class
Message-ID: <20210720214847.GB704@amd>
References: <20210719144940.904087935@linuxfoundation.org>
 <20210719144945.657682587@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20210719144945.657682587@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a948b1142cae66785521a389cab2cce74069b547 ]
>=20
> Since commit 9a6944fee68e ("tracing: Add a verifier to check string
> pointers for trace events"), which was merged in v5.13-rc1,
> TP_printk() no longer tacitly supports the "%.*s" format specifier.
>=20
> These are low value tracepoints, so just remove them.

So I understand we want this for mainline, but AFAICT 5.10 does not
have 9a6944fee68e ("tracing: Add a verifier to check string pointers
for trace events") commit, so this does not fix any bug and removal of
tracepoints can be surprising.

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmD3RL8ACgkQMOfwapXb+vLDrACfW36vdkRGR10QmAgw0nCLoBdW
ZOcAoMBcL8dJt95haFYQmrnDcyNMEAxj
=+twP
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
