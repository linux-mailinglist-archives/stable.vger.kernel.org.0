Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49A49BF38
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 20:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfHXSTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 14:19:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47033 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfHXSTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Aug 2019 14:19:34 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E32C681339; Sat, 24 Aug 2019 20:19:16 +0200 (CEST)
Date:   Sat, 24 Aug 2019 20:19:29 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     linux-kernel@vger.kernel.org
Cc:     linux-tip-commits@vger.kernel.org,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chen Yu <yu.c.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [tip: x86/urgent] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20190824181929.GA18551@amd>
References: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
 <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2019-08-23 01:10:49, tip-bot2 for Tom Lendacky wrote:
> The following commit has been merged into the x86/urgent branch of tip:
>=20
> Commit-ID:     c49a0a80137c7ca7d6ced4c812c9e07a949f6f24
> Gitweb:        https://git.kernel.org/tip/c49a0a80137c7ca7d6ced4c812c9e07=
a949f6f24
> Author:        Tom Lendacky <thomas.lendacky@amd.com>
> AuthorDate:    Mon, 19 Aug 2019 15:52:35=20
> Committer:     Borislav Petkov <bp@suse.de>
> CommitterDate: Mon, 19 Aug 2019 19:42:52 +02:00
>=20
> x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h
>=20
> There have been reports of RDRAND issues after resuming from suspend on
> some AMD family 15h and family 16h systems. This issue stems from a BIOS
> not performing the proper steps during resume to ensure RDRAND continues
> to function properly.

There are quite a few unanswered questions here.

a) Is there/should there be CVE for this?

b) Can we perform proper steps in kernel, thus making RDRAND usable
even when BIOS is buggy?

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1hf7EACgkQMOfwapXb+vJr8ACfYYvoVV2o2HMsFRXMI3vauU/K
0fEAn3xhQSvQ1Slrcy2GZlR7YLTFuEsf
=//ju
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
