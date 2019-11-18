Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC845100776
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 15:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfKROfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 09:35:15 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58060 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKROfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 09:35:15 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 26D831C17F8; Mon, 18 Nov 2019 15:35:14 +0100 (CET)
Date:   Mon, 18 Nov 2019 15:35:13 +0100
From:   Pavel Machek <pavel@denx.de>
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, pavel@denx.de,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        alexander.shishkin@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/uncore: Remove unnecessary check for uncore_pmu
Message-ID: <20191118143513.GC22736@duo.ucw.cz>
References: <1573652102-131731-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1573652102-131731-1-git-send-email-kan.liang@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-11-13 05:35:02, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
>=20
> The uncore_pmu pointer in uncore_pmu_enable/disable() is from
> container_of, which never be NULL.
>=20
> Remove the unnecessary check for uncore_pmu.
>=20
> Fixes: 75be6f703a14 ("perf/x86/uncore: Fix event group support")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Cc: stable@vger.kernel.org

Thanks for doing this.

Acked-by: Pavel Machek <pavel@denx.de>

								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdKsIQAKCRAw5/Bqldv6
8oU4AJ9qXjKZ6eS3hZq6KZBaV2lKij8A1QCfVqsQu62Em0IeIUoQ+pix2D4ZYZU=
=0Qai
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
