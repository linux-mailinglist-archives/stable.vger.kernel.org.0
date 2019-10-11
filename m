Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DD8D3E42
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJKLV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 07:21:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38420 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfJKLV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 07:21:57 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 795F2802A4; Fri, 11 Oct 2019 13:21:39 +0200 (CEST)
Date:   Fri, 11 Oct 2019 13:21:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 082/114] powerpc/book3s64/radix: Rename
 CPU_FTR_P9_TLBIE_BUG feature flag
Message-ID: <20191011112106.GA28994@amd>
References: <20191010083544.711104709@linuxfoundation.org>
 <20191010083612.352065837@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20191010083612.352065837@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>=20
> Rename the #define to indicate this is related to store vs tlbie
> ordering issue. In the next patch, we will be adding another feature
> flag that is used to handles ERAT flush vs tlbie ordering issue.
>=20
> Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on =
POWER9")
> Cc: stable@vger.kernel.org # v4.16+
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link:
> https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.c=
om

Apparently this is upstream commit
09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 , but the changelog does not
say so.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2gZaIACgkQMOfwapXb+vK/gQCfQ8U3ZXfQ5R+I1xfv+CI2oqBJ
88AAnRfzH4negiIU+ZglUzpRMysY31HV
=5f+A
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
