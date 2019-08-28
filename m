Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6084FA0152
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfH1MJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:09:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46996 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1MJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 08:09:39 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id EB15781E70; Wed, 28 Aug 2019 14:09:22 +0200 (CEST)
Date:   Wed, 28 Aug 2019 14:09:36 +0200
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
Message-ID: <20190828120935.GD8052@amd>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
 <20190828120024.GF4920@zn.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
In-Reply-To: <20190828120024.GF4920@zn.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-08-28 14:00:24, Borislav Petkov wrote:
> On Wed, Aug 28, 2019 at 01:49:47PM +0200, Pavel Machek wrote:
> > AMD screwed this up,
>=20
> Except that it wasn't AMD who screwed up but BIOS on *some* laptops.

Yes, and now AMD has patch to break it on *all* machines.

Hmm. "Get random data" instruction that fails to return random data,
depending on BIOS... (and even indicates success, IIRC)... Sounds like
CPU vendor screwup to me.

And they can also fix it up. If re-initing random generator is
impossible from kernel, surely CPU microcode can be either updated to
do the init automatically, or at least allow kernel to do the init.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1mbv8ACgkQMOfwapXb+vKuGQCggrpXRxPboGyVt8+wPQDzbHsk
Y5AAoJH+7uzv6qf18s+wwWNFoIo3pTOc
=xR92
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
