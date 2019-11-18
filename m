Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E56510077B
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 15:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKROgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 09:36:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58190 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKROgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 09:36:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5FDC71C17F8; Mon, 18 Nov 2019 15:36:37 +0100 (CET)
Date:   Mon, 18 Nov 2019 15:36:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, pavel@denx.de,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        alexander.shishkin@linux.intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/uncore: Remove unnecessary check for uncore_pmu
Message-ID: <20191118143636.GD22736@duo.ucw.cz>
References: <1573652102-131731-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1573652102-131731-1-git-send-email-kan.liang@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C+ts3FVlLX8+P6JN
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

Sorry, sent email too fast.

I agree this is good fix for mainline, but as the code is a tiny bit
ineffective but correct, I don't think we neccessarily need it in
stable.

Best regards,
							Pavel
						=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdKsdAAKCRAw5/Bqldv6
8mU3AJ9+JUK3UhvtIbQf/OVMZgQQFuaLqACeMvHDB/bq1neMOohhJzKkkzdH1gU=
=T8Gj
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
