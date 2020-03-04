Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F00179894
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 20:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388221AbgCDTGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 14:06:23 -0500
Received: from foss.arm.com ([217.140.110.172]:38604 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388171AbgCDTGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 14:06:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1B841FB;
        Wed,  4 Mar 2020 11:06:22 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F5D63F6C4;
        Wed,  4 Mar 2020 11:06:22 -0800 (PST)
Date:   Wed, 4 Mar 2020 19:06:20 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <20200304190620.GF5646@sirena.org.uk>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
 <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
 <20200304160916.GC5646@sirena.org.uk>
 <44cf4ff8-120f-79fd-8801-47807b03f912@linux.intel.com>
 <20200304181113.GE5646@sirena.org.uk>
 <669e6e57-3a84-7cf5-398f-eefdd333fadb@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XStn23h1fwudRqtG"
Content-Disposition: inline
In-Reply-To: <669e6e57-3a84-7cf5-398f-eefdd333fadb@linux.intel.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XStn23h1fwudRqtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2020 at 12:50:54PM -0600, Pierre-Louis Bossart wrote:

> > This thread is the first suggestion I've seen that this is any kind of
> > bug fix.  There's no Fixes tag and the patch description itself sounds
> > like it's adding a new feature to enable new functionality in userspace
> > (autodetection by UCM) and it was posted as part of a series "ASoC: SOF:
> > initial cleanup for DT and multi-client support" which again doesn't
> > give any indication that this might be supposed to be a bug fix.

> the initial patch came from Jaroslav on 11/26, not from me. Quoting your own
> words:

> "Since Pierre seems happy with it even if he didn't ack it explicitly
> I'll guess I'll apply it.  If git can figure out applying it after the
> merge window and it doesn't get negative reviews there's no need to
> resend.  If it can't and it doesn't turn up in a bigger series before
> then I'll let you know.
> "

Right, that's me saying I'll apply something that looks like normal
development work after the merge window as with other normal development
work (even Jaroslav's initial version was sent after the merge window
opened), not that I'll apply it as a fix.  There's no hint in any of
that thread or in your resend that this was anything other than a new
feature, and indeed you were talking about wanting to integrate it with
a series that you didn't want to see in v5.5.  Jaroslav mentioned not
wanting to delay if it'd cause him to miss the merge window but didn't
seem to complain when I said he'd missed it with his initial posting.

Anyway, is my understanding correct that this is fixing a regression
caused by switching the default to SOF?

--XStn23h1fwudRqtG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5f/CwACgkQJNaLcl1U
h9C/pgf/ZLqxQ0CidWhCp+xoVj9ABSLg1tNOQdn2xq9fZ7ZFgc1QvANfCngXHwkQ
7zBRGVwEjdOL352TT+357ujSngq4dUTq99i5Bawc3kl0svQ/JD/m7XQpR48ArZOy
NtU8ScLIDyh+CbG+pydLHWqLmxawlR5jLjTdYKsuLtFRtnpyDZ+Q6rzLth/TCLfU
sqhVKT+lMWyd3tNP9TJID/lNxiyQTZAysrMFcEsGthjl/3hfI+FqnHSCpT/wgkfx
GjssgQM+HCHdoY3vD7ixiP/kr0P0VpJ1bcGcYxs+BPufAjDSPtuLb3+BviFq98Ku
dJvw08/6U9gzydffjIIENbdcBB598Q==
=EZ2J
-----END PGP SIGNATURE-----

--XStn23h1fwudRqtG--
