Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8C179487
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgCDQJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 11:09:19 -0500
Received: from foss.arm.com ([217.140.110.172]:36288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgCDQJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 11:09:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5408031B;
        Wed,  4 Mar 2020 08:09:18 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8AED3F6CF;
        Wed,  4 Mar 2020 08:09:17 -0800 (PST)
Date:   Wed, 4 Mar 2020 16:09:16 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jaroslav Kysela <perex@perex.cz>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Pierre-louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <20200304160916.GC5646@sirena.org.uk>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
 <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2020 at 04:53:27PM +0100, Jaroslav Kysela wrote:
> Dne 04. 03. 20 v 16:44 Mark Brown napsal(a):

> > This looks more like a new feature than a bug fix and I've been trying
> > to get the stable people to calm down with the backports, there's been
> > *far* too many regressions introduced recently in just the x86 stuff
> > found after the fact.  Does this fix systems that used to work?

> The released ALSA UCM does not work correctly for some platforms without
> this information (the number of digital microphones is not identified
> correctly).

That's not the question I asked - have these platforms ever worked with
older kernel versions?

> The regression probability is really low for this one and we're using it in
> Fedora kernels for months without issues (in this code).

It's partly the principle of the thing, if it were just patches that
had individually been identified as being good for stable by someone
with some understanding of the code (like this one :/ ) that were being
backported I'd be a lot less concerned but the automated selections are
missing dependencies or other context and people are reporting problems
with them so I'm inclined to push back on things.

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5f0qsACgkQJNaLcl1U
h9BadQf+O1EQDc7YktVj1dC5/GTJz8ZI39rao4i3XGtN7dx08fwW2RXYC18WBt+x
riZeag6zydhoqeV55meXCXfC2jLybdLPqmVmVaRd6nKm1oTeaounn0gs7ftCGkz4
gWcnYcKpOuDbKFRqY8BDZX9f0LwO0huWXRm8+AAaflC0504sJuIerJXZcX3feFmG
e5ISl0zjH1CUYglUmhpDc/KCuEBF2V+o6zz54klclEgmGYlSJe3eC6JJOX3XrO/p
N3Tp0rgUVpgF2bcskQtdDx8KeOyejo8wf8a7MV+fG9daHi0Wr4HPBsCcHSvd1OHy
phspjKXc1sWogPFibsNvaF22PQWA0g==
=1QQV
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
