Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475E92128F6
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgGBQFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGBQFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 12:05:31 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C36520720;
        Thu,  2 Jul 2020 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593705931;
        bh=+ViH9gg1N4vHnbvW09Osmv3jgSWPSKTM98itdeGHjxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lCqEjgToa9YAhlJo1P8SbSYSZUeSeu/pHkTTDYA3v5owSvPxgpYFbtqNG5GGDIXC3
         dsm6bXEs1n031wwtKAjWbzf1IL2MTt1e3w9Hapd1UpsRoSYJV1JwbmdHFJ2SR4sHdP
         LF5TlWhXdyM5G8azXBd4kwt9NPAhYivwFXJZIxo0=
Date:   Thu, 2 Jul 2020 17:05:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 15/53] ASoC: SOF: Intel: add PCI IDs for
 ICL-H and TGL-H
Message-ID: <20200702160528.GL4483@sirena.org.uk>
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-15-sashal@kernel.org>
 <20200702111835.GB4483@sirena.org.uk>
 <0baf17f3-1af8-a4a1-644c-ab27490f9b44@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CgTrtGVSVGoxAIFj"
Content-Disposition: inline
In-Reply-To: <0baf17f3-1af8-a4a1-644c-ab27490f9b44@linux.intel.com>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CgTrtGVSVGoxAIFj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2020 at 10:42:21AM -0500, Pierre-Louis Bossart wrote:
> On 7/2/20 6:18 AM, Mark Brown wrote:
> > On Wed, Jul 01, 2020 at 09:21:24PM -0400, Sasha Levin wrote:
> > > From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

> > > [ Upstream commit c8d2e2bfaeffa0f914330e8b4e45b986c8d30b58 ]

> > > Usually the DSP is not traditionally enabled on H skews but this might
> > > be used moving forward.

> > "This might be used moving forward"?

> There are two conditions for the SOF driver to be used in a distro:
> a) the DSP needs to be enabled (as reported by the pci class info)
> b) sound/hda/intel-dsp-config.c needs to contain a quirk to select SOF over
> the legacy HDaudio, such as presence of DMIC/SoundWire or a known vendor
> DMI.

> Traditionally for desktops neither a) nor b) are true, but this is changing:
> we will start adding quirks for specific product lines as requested by OEMs.

> Does this answer to your question?

The question was more of a why is this being backported one - without
those extra quirks this does nothing, and frankly with them it seems
like a *major* change someone might see in stable if they update their
kernel and it suddenly switches to an entirely different DSP software
stack.

--CgTrtGVSVGoxAIFj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7+BcgACgkQJNaLcl1U
h9D9WQf/eYD0E9xMzfnYMjmvItrYNt7IX6kw7q7O/der/0OiCiMdvfKFLFr6bPBF
61VoeZFlJkpui/EcoPgTsf5qlJLPMoCy1Ht7i/TacZppBWp2I07uEw+rtioDkDRe
SAy+8LDiHk+Z6JQAXTXUmvdeUcI+tq9dfvQG8KY1wvAlh0+6dyLu4NOnlsTJHgFN
xYM6xR1n/y33C8oU7AnQNMZEN1U1O7QH78iHqUmktoWM/71PbE/e+54ZjshjXteV
nniGaCewi0NFozRzQaLS6e4SdPssH3Rh3npqa+cQOkLtTn+2U4zt1/mu9VGqmmLp
ojykL5QiFLb6CxUSm33uvn2zV8V6gw==
=iB43
-----END PGP SIGNATURE-----

--CgTrtGVSVGoxAIFj--
