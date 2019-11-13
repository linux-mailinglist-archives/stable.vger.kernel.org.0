Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD59FAEA1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 11:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfKMKfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 05:35:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48400 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfKMKfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 05:35:34 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 960281C122C; Wed, 13 Nov 2019 11:35:32 +0100 (CET)
Date:   Wed, 13 Nov 2019 11:35:31 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        linux-drivers-review@eclists.intel.com,
        linux-perf@eclists.intel.com, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 097/125] perf/x86/uncore: Fix event group support
Message-ID: <20191113103531.GB32553@amd>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181452.768177907@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <20191111181452.768177907@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

>  	return ret;
>  }
> =20
> +static void uncore_pmu_enable(struct pmu *pmu)
> +{
> +	struct intel_uncore_pmu *uncore_pmu;
> +	struct intel_uncore_box *box;
> +
> +	uncore_pmu =3D container_of(pmu, struct intel_uncore_pmu, pmu);
> +	if (!uncore_pmu)
> +		return;

AFAICT this test can never trigger.

> +static void uncore_pmu_disable(struct pmu *pmu)
> +{
> +	struct intel_uncore_pmu *uncore_pmu;
> +	struct intel_uncore_box *box;
> +
> +	uncore_pmu =3D container_of(pmu, struct intel_uncore_pmu, pmu);
> +	if (!uncore_pmu)
> +		return;

And neither can this one.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3L3HMACgkQMOfwapXb+vKJOQCgkm41YCUpNuyFUIS1TlRBAuN1
OSwAoJ+mR7PwHs7iO2U9UhToNz4WjdWr
=ZP7K
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
