Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB07D17991B
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgCDTih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 14:38:37 -0500
Received: from foss.arm.com ([217.140.110.172]:38850 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCDTih (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 14:38:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B41C4B2;
        Wed,  4 Mar 2020 11:38:37 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDA1C3F6C4;
        Wed,  4 Mar 2020 11:38:36 -0800 (PST)
Date:   Wed, 4 Mar 2020 19:38:35 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        ALSA development <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
Subject: Re: 5.5.y - apply "ASoC: intel/skl/hda - export number of digital
 microphones via control components"
Message-ID: <20200304193835.GH5646@sirena.org.uk>
References: <147efa37-eb57-7f17-b9eb-84a9fe5ad475@perex.cz>
 <20200304154450.GB5646@sirena.org.uk>
 <a6d57c14-0794-77d0-5c6f-c0c897d254b5@perex.cz>
 <20200304160916.GC5646@sirena.org.uk>
 <44cf4ff8-120f-79fd-8801-47807b03f912@linux.intel.com>
 <20200304181113.GE5646@sirena.org.uk>
 <669e6e57-3a84-7cf5-398f-eefdd333fadb@linux.intel.com>
 <20200304190620.GF5646@sirena.org.uk>
 <3b00df9a-6b53-def7-4304-d9829de749c6@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <3b00df9a-6b53-def7-4304-d9829de749c6@linux.intel.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 04, 2020 at 01:30:59PM -0600, Pierre-Louis Bossart wrote:
> On 3/4/20 1:06 PM, Mark Brown wrote:

> > Anyway, is my understanding correct that this is fixing a regression
> > caused by switching the default to SOF?

> This is fixing a regression on platforms that have digital microphones,
> where SOF is automatically selected by default. For platforms without DMICs,
> the legacy driver is still used and this patch has no effect.

OK, in that case this should go in then - it's certainly a lot better
than reverting the switch to SOF.

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5gA7oACgkQJNaLcl1U
h9Aqnwf+N5KM/Cmi4GB26cAI4MASpEEAzL4A2C9YOOvYiffNanyIkQMMmKaXRywa
+AulLIdp9/iTKJ/EnFlGujCSH5t83Jt5/H8wS3DdcMPCCpHG70LcUbVmTZchieTq
o+Xh90wM52QI+MRhL9l/pyi62VxbTjzD0uY5Rt9fOPS27h+jjrdwMyFrv5V9WbYw
QBTk9CWCrRyNXaFwadSmkvuWvCiCivC+SQVml37qNMt6ckkRjGClZlOxqK9Drc/u
graRgpVwPgeFFlvTCacOPd0FLt0HHGjaBdCsRJeyo3+oRN/57rXTXamVgsRlykwI
JskeYZHzTgqEO/aCf+4+2wKU9rRl/g==
=f+O1
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
