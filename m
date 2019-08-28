Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FFEA0D21
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 00:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfH1WFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 18:05:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57054 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfH1WFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 18:05:38 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 74EDA820AE; Thu, 29 Aug 2019 00:05:21 +0200 (CEST)
Date:   Thu, 29 Aug 2019 00:05:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Pavel Machek <pavel@denx.de>, Borislav Petkov <bp@alien8.de>,
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
Message-ID: <20190828220533.GA24056@amd>
References: <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
 <20190828120024.GF4920@zn.tnic>
 <20190828120935.GD8052@amd>
 <20190828121628.GG4920@zn.tnic>
 <20190828122913.GE8052@amd>
 <20190828124621.GI4920@zn.tnic>
 <20190828133713.GF8052@amd>
 <alpine.DEB.2.21.1908281610310.23149@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908281610310.23149@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-08-28 16:15:06, Thomas Gleixner wrote:
> On Wed, 28 Aug 2019, Pavel Machek wrote:
> > On Wed 2019-08-28 14:46:21, Borislav Petkov wrote:
> > > On Wed, Aug 28, 2019 at 02:29:13PM +0200, Pavel Machek wrote:
> > > > This is not a way to have an inteligent conversation.
> > >=20
> > > No, this *is* the way to keep the conversation sane, without veering
> > > off into some absurd claims.
> > >=20
> > > So, to cut to the chase: you can simply add "rdrand=3Dforce" to your
> > > cmdline parameters and get back to using RDRAND.
> > >=20
> > > And yet if you still feel this fix does not meet your expectations,
> > > you were told already to either produce patches or who to contact. I'm
> > > afraid complaining on this thread won't get you anywhere but that's y=
our
> > > call.
> >=20
> > No, this does not meet my expectations, it violates stable kernel
> > rules, and will cause regression to some users, while better solution
> > is known to be available.
>=20
> Your unqualified ranting does not meet my expectation either and it
> violates any rule of common sense.
>=20
> For the record:
>=20
>   Neither AMD nor we have any idea which particular machines have a fixed
>   BIOS and which have not. There is no technical indicator either at boot
>   time as the wreckage manifests itself only after resume.
>=20
>   So in the interest of users the only sensible decision is to disable
>   RDRAND for this class of CPUs.

No.

Obviously best solution would be microcode update to fix the problem,
or to enable kernel to fix the problem.

>   If you have a list of machines which have a fixed BIOS, then provide it
>   in form of patches. If not then stop claiming that there is a better
>   solution available.

And yes, whitelist would be already better than present solution. It is
not my duty to submit fixes to your proposed patch.

> Anyway, I'm done with that and further rants of yours go directly to
> /dev/null.
>=20
> Thanks for wasting everyones time

Thanks for your profesional attitude.

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1m+q0ACgkQMOfwapXb+vJDbwCeJQ0WoYyf8A/jB7OEGuIzpOov
WaQAn2Wcm/aEi77wq5CWOsCPWQNaLvO6
=Fjjn
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
