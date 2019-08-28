Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F97A00FE
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 13:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfH1Ltv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 07:49:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40467 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfH1Ltu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 07:49:50 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id B97E581423; Wed, 28 Aug 2019 13:49:34 +0200 (CEST)
Date:   Wed, 28 Aug 2019 13:49:47 +0200
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
Message-ID: <20190828114947.GC8052@amd>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > There is no way to reinitialize RDRAND from the kernel otherwise we w=
ould
> > > have exactly done that. If you know how to do that please tell.
> >=20
> > Would they? AMD is not exactly doing good job with communication
>=20
> Yes they would. Stop making up weird conspiracy theories.

> > here. If BIOS can do it, kernel can do it, too...
>=20
> May I recommend to read up on SMM and BIOS being able to lock down access
> to certain facilities?
>=20
> > or do you have information saying otherwise?
>=20
> Yes. It was clearly stated by Tom that it can only be done in the
> BIOS.

Do you have a link for that? Because I don't think I seen that one.

> > > Also disabling it for every BIOS is the only way which can be done be=
cause
> > > there is no way to know whether the BIOS is fixed or not at cold boot
> > > time. And it has to be known there because applications cache the
> >=20
> > I'm pretty sure DMI-based whitelist would help here. It should be
> > reasonably to fill it with the common machines at least.
>=20
> Send patches to that effect.

Why should it be my job? AMD screwed this up, they should fix it
properly. And you should insist on proper fix.

> > Plus, where is the CVE, and does AMD do anything to make BIOS vendors
> > fix them?
>=20
> May I redirect you to: https://www.amd.com/en/corporate/contact

That will certainly make communication easier, right.

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1malsACgkQMOfwapXb+vKGNQCfex+HxrNNM1zW06KK6370wJxS
AHgAn3isBqW2j5ATWV822FJMAu++J1j4
=41iR
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
