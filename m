Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC15BA0359
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1NhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:37:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40944 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfH1NhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 09:37:17 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id C98C982573; Wed, 28 Aug 2019 15:37:00 +0200 (CEST)
Date:   Wed, 28 Aug 2019 15:37:13 +0200
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
Message-ID: <20190828133713.GF8052@amd>
References: <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
 <20190828120024.GF4920@zn.tnic>
 <20190828120935.GD8052@amd>
 <20190828121628.GG4920@zn.tnic>
 <20190828122913.GE8052@amd>
 <20190828124621.GI4920@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Content-Disposition: inline
In-Reply-To: <20190828124621.GI4920@zn.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-08-28 14:46:21, Borislav Petkov wrote:
> On Wed, Aug 28, 2019 at 02:29:13PM +0200, Pavel Machek wrote:
> > This is not a way to have an inteligent conversation.
>=20
> No, this *is* the way to keep the conversation sane, without veering
> off into some absurd claims.
>=20
> So, to cut to the chase: you can simply add "rdrand=3Dforce" to your
> cmdline parameters and get back to using RDRAND.
>=20
> And yet if you still feel this fix does not meet your expectations,
> you were told already to either produce patches or who to contact. I'm
> afraid complaining on this thread won't get you anywhere but that's your
> call.

No, this does not meet my expectations, it violates stable kernel
rules, and will cause regression to some users, while better solution
is known to be available.

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1mg4kACgkQMOfwapXb+vJ5lQCfe67ZQO1KqO+Emi7h3sVMu+RT
SAEAn1oFIuqthMNyVQDSzzirRUHxxId7
=FeXY
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
