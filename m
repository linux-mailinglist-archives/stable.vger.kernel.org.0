Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D059B378F0B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhEJN11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55146 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343499AbhEJMNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:13:46 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 806821C0B79; Mon, 10 May 2021 14:12:40 +0200 (CEST)
Date:   Mon, 10 May 2021 14:12:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 108/299] platform/x86: intel_pmc_core: Dont use
 global pmcdev in quirks
Message-ID: <20210510121240.GD3547@duo.ucw.cz>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102008.507160403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <20210510102008.507160403@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: David E. Box <david.e.box@linux.intel.com>
>=20
> [ Upstream commit c9f86d6ca6b5e23d30d16ade4b9fff5b922a610a ]
>=20
> The DMI callbacks, used for quirks, currently access the PMC by getting
> the address a global pmc_dev struct. Instead, have the callbacks set a
> global quirk specific variable. In probe, after calling dmi_check_system(=
),
> pass pmc_dev to a function that will handle each quirk if its variable
> condition is met. This allows removing the global pmc_dev later.

This does not fix a bug.. it is preparation for further cleanups that
are not queued to 5.10 stable. So this should not be in 5.10 either.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJkjOAAKCRAw5/Bqldv6
8pDnAJ9gKppI4pC9TTb4erKtW2Z4q5ES+gCgwHYngmR60ODKvSO4uoBGpmQ4X3M=
=IF1o
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
