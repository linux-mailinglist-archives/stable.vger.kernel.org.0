Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC89FFED
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfH1KbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:31:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48064 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbfH1KbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 06:31:16 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id BBF1F81097; Wed, 28 Aug 2019 12:31:00 +0200 (CEST)
Date:   Wed, 28 Aug 2019 12:31:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Yu <yu.c.chen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4.19 72/98] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20190828103113.GA14677@amd>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-08-27 15:30:30, Thomas Gleixner wrote:
> On Tue, 27 Aug 2019, Pavel Machek wrote:
>=20
> > On Tue 2019-08-27 09:50:51, Greg Kroah-Hartman wrote:
> > > From: Tom Lendacky <thomas.lendacky@amd.com>
> > >=20
> > > commit c49a0a80137c7ca7d6ced4c812c9e07a949f6f24 upstream.
> > >=20
> > > There have been reports of RDRAND issues after resuming from suspend =
on
> > > some AMD family 15h and family 16h systems. This issue stems from a B=
IOS
> > > not performing the proper steps during resume to ensure RDRAND contin=
ues
> > > to function properly.
> >=20
> > Yes. And instead of reinitializing the RDRAND on resume, this patch
> > breaks support even for people with properly functioning BIOSes...
>=20
> There is no way to reinitialize RDRAND from the kernel otherwise we would
> have exactly done that. If you know how to do that please tell.

Would they? AMD is not exactly doing good job with communication
here. If BIOS can do it, kernel can do it, too... or do you have
information saying otherwise?

> Also disabling it for every BIOS is the only way which can be done because
> there is no way to know whether the BIOS is fixed or not at cold boot
> time. And it has to be known there because applications cache the

I'm pretty sure DMI-based whitelist would help here. It should be
reasonably to fill it with the common machines at least.

Plus, where is the CVE, and does AMD do anything to make BIOS vendors
fix them?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1mV/EACgkQMOfwapXb+vKEEACfa9KYDavWYmga5YIPImafscUZ
6ToAoKvc4xitFnoM3ETkUUD2cV1in6+x
=OTpt
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
