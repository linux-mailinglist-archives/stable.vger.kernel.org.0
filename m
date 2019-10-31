Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A0CEB992
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 23:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfJaWOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 18:14:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59024 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728640AbfJaWOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 18:14:39 -0400
Received: from 188.29.164.72.threembb.co.uk ([188.29.164.72] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iQIi6-0001MD-If; Thu, 31 Oct 2019 22:14:37 +0000
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iQIhw-0000pL-Vi; Thu, 31 Oct 2019 22:14:20 +0000
Message-ID: <05be6a70382f1990a2ba6aba9ac75dac0c55f7fb.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 47/47] KVM: x86/vPMU: refine kvm_pmu err msg when
 event creation failed
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Oct 2019 22:14:15 +0000
In-Reply-To: <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
References: <lsq.1572026582.631294584@decadent.org.uk>
         <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-hKUhIv2BLLOi+f5RLV/D"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 188.29.164.72
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hKUhIv2BLLOi+f5RLV/D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-10-25 at 12:05 -0700, Joe Perches wrote:
> On Fri, 2019-10-25 at 19:03 +0100, Ben Hutchings wrote:
> > 3.16.76-rc1 review patch.  If anyone has any objections, please let me =
know.
>=20
> This seems more like an enhancement than a bug fix.
>=20
> Is this really the type of patch that is appropriate
> for stable?

Apparently so:

v4.14.135: eba797dbf352 KVM: x86/vPMU: refine kvm_pmu err msg when event cr=
eation failed
v4.19.61: ba27a25df6df KVM: x86/vPMU: refine kvm_pmu err msg when event cre=
ation failed
v4.4.187: 505c011f9f53 KVM: x86/vPMU: refine kvm_pmu err msg when event cre=
ation failed
v4.9.187: 3984eae04473 KVM: x86/vPMU: refine kvm_pmu err msg when event cre=
ation failed
v5.1.20: edadec197fbf KVM: x86/vPMU: refine kvm_pmu err msg when event crea=
tion failed
v5.2.3: 9f062aef7356 KVM: x86/vPMU: refine kvm_pmu err msg when event creat=
ion failed

Ben.

> > ------------------
> >=20
> > From: Like Xu <like.xu@linux.intel.com>
> >=20
> > commit 6fc3977ccc5d3c22e851f2dce2d3ce2a0a843842 upstream.
> >=20
> > If a perf_event creation fails due to any reason of the host perf
> > subsystem, it has no chance to log the corresponding event for guest
> > which may cause abnormal sampling data in guest result. In debug mode,
> > this message helps to understand the state of vPMC and we may not
> > limit the number of occurrences but not in a spamming style.
> >=20
> > Suggested-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > [bwh: Backported to 3.16: adjust context]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  arch/x86/kvm/pmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -187,8 +187,8 @@ static void reprogram_counter(struct kvm
> >  						 intr ? kvm_perf_overflow_intr :
> >  						 kvm_perf_overflow, pmc);
> >  	if (IS_ERR(event)) {
> > -		printk_once("kvm: pmu event creation failed %ld\n",
> > -				PTR_ERR(event));
> > +		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->id=
x =3D %d\n",
> > +			    PTR_ERR(event), pmc->idx);
> >  		return;
> >  	}
> > =20
> >=20
--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                               A fail-safe circuit will destroy others.



--=-hKUhIv2BLLOi+f5RLV/D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl27XLgACgkQ57/I7JWG
EQkqSQ//RR8xY73bxtHVjVHg0wo49KzosxapaAi+qo+HxB2zL7OfW9CJVOMTpOk+
QT+iqkYNNcMAbRClkb86WoATNzC5Crau5quovdJdLbPNq/ANd1HP91jTwAhHc/cK
8rSZTzUz1c13mBSFHGbTn+HQaiDsw+iElA06hcqARpe0lxm7m4Usvp6kiKOwlShK
NKGzUz7GjntXzj+0r02jwKc7OEx73bQRc4Zng2QrAFwC4smeghiSm7zrrG12SC2Y
Jipc6cGdeQ1/RVcnuEO93ZCEl6PHTZ4ngKlpdB5u9nFPgYvIQ60U6w/USNcdIu6C
yNmnnOMt3XNOpYdeqYm1dYQ2jPy0S2POBawDd3+B68fLBgNt54lhIIgJt0imybj4
/u9mznUCt+KWNAgwR5tYapxgWlrsAyH775S/7+0Svxir162A6YzCckGG7g0y7Ln0
Q8Wp3jIQyq35ofh7gl69H/68A7FFKUnsvPKpxT/8QS67MCzDzSXxuTReHQaSLeVA
638YTj0JAfEXipA1bP0JTcsBJaNEeqxwJHYwwz3exTL+Kr/a/C8WrvPSLGpmG1O3
KugLzLeoJ0s66qnZdD79B/LKulAm6bP5GS1ujvvnuBYOOLlLwvCHw7nMmEq/YWEd
lxWi06TTgsZ2+PhXBQvQspX966YWifIPjTBmtVyhVq7i1puVbBM=
=r0nb
-----END PGP SIGNATURE-----

--=-hKUhIv2BLLOi+f5RLV/D--
