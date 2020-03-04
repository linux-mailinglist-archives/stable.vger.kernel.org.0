Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2151793D5
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgCDPox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:44:53 -0500
Received: from foss.arm.com ([217.140.110.172]:35994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbgCDPox (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 10:44:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBA0D31B;
        Wed,  4 Mar 2020 07:44:52 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CFE93F6CF;
        Wed,  4 Mar 2020 07:44:52 -0800 (PST)
Date:   Wed, 4 Mar 2020 15:44:50 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jaroslav Kysela <perex@perex.cz>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Pierre-louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <20200304154450.GB5646@sirena.org.uk>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 04:25:54PM +0100, Jaroslav Kysela wrote:
> Hi,
>=20
>   could we cherry-pick patch 8cd9956f61c65022209ce6d1e55ed12aea12357d to =
the
> 5.5 stable tree?
>=20
> 8cd9956f61c65022209ce6d1e55ed12aea12357d :
>  "ASoC: intel/skl/hda - export number of digital microphones via control
> components"

This looks more like a new feature than a bug fix and I've been trying
to get the stable people to calm down with the backports, there's been
*far* too many regressions introduced recently in just the x86 stuff
found after the fact.  Does this fix systems that used to work?

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5fzPIACgkQJNaLcl1U
h9Dv9gf/Zo6deZO28PePM4ljeLF17V7sBRWBsvSmjroL09kiUjDOofrckNa+ndnD
EN5nJq4x2nJn8+9cP1OJnZ8byZOj3Pz1PIGJvb1o92KoJgNCIE0vaWoRzP/5WwS6
RHBiXIA5TYfQ95VTNiCQblTS6cQ+zFh3xkTNTN1K6pRUik1UPtcXvgItXwH4TCY5
KC2xkTguF72fOodW7LYGtarqs6M2oGZMVozPgE4ePP4LOo9TuIYNKis6NcAn0nHV
Z4joo3Xz+2pr23cErldqtTKoamyHfCt5KKo3PExkxcxIp4Nf/ikau7AkfGaCLXE6
EJwvXHeIFjec4f7+dh+wlCxDLUgvGA==
=exwD
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
