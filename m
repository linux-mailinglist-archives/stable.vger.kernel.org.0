Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B6A01B1
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfH1M3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:29:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51339 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfH1M3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 08:29:15 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 05AD9825D9; Wed, 28 Aug 2019 14:28:59 +0200 (CEST)
Date:   Wed, 28 Aug 2019 14:29:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Pavel Machek <pavel@denx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Message-ID: <20190828122913.GE8052@amd>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
 <20190828120024.GF4920@zn.tnic>
 <20190828120935.GD8052@amd>
 <20190828121628.GG4920@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Content-Disposition: inline
In-Reply-To: <20190828121628.GG4920@zn.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-08-28 14:16:28, Borislav Petkov wrote:
> On Wed, Aug 28, 2019 at 02:09:36PM +0200, Pavel Machek wrote:
> > Yes, and now AMD has patch to break it on *all* machines.
>=20
> It doesn't break all machines - you need to look at that patch again.

This is not a way to have an inteligent conversation.

The patch clearly breaks more machines than it has to. It is known to
cause regression. You snipped the rest of the email with better ways
to solve this.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1mc5kACgkQMOfwapXb+vIz7QCgqGdVM5QcSn7YV7viJnMiuqQs
H2kAn3NoOi6AbQxnnAtd3nKdvRrtQcrx
=Kb80
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
