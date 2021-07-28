Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E37D3D8918
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 09:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhG1Hsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 03:48:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40556 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbhG1Hsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 03:48:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8DED71C0B7C; Wed, 28 Jul 2021 09:48:29 +0200 (CEST)
Date:   Wed, 28 Jul 2021 09:48:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 014/167] net: Introduce preferred busy-polling
Message-ID: <20210728074828.GA28860@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153839.841834200@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20210726153839.841834200@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bj=F6rn T=F6pel <bjorn.topel@intel.com>
>=20
> [ Upstream commit 7fd3253a7de6a317a0683f83739479fb880bffc8 ]
>=20
> The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
> option or system-wide using the /proc/sys/net/core/busy_read knob, is
> an opportunistic. That means that if the NAPI context is not

Do we need this in -stable? It is rather long at 400 lines, and
introduces new API feature, does not fix a bug.

I can revert it on top of 5.10-stable, so I don't believe we have
bugfix depending on it.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEBC8wACgkQMOfwapXb+vI6/QCfSm725dj6X03s11p0VOo4DPRn
SN4AoKIyovifQCui152lZM9+nPY9m9Vo
=h5pZ
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
