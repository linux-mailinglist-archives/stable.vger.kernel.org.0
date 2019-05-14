Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29611CE77
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfENSE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 14:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfENSE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 14:04:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEE5C20879;
        Tue, 14 May 2019 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557857067;
        bh=X0/lbKH2AUqKaAiLjI7cBgYjtfplulL9FaB7Ihki0zs=;
        h=Date:From:To:Cc:Subject:From;
        b=tYzeqMSKI8mry2AkxqUiJ+f8lF3feEMuG3+sm9OyEE5DBNX0XM/E3Ti2efWcSHu6l
         ikUmRkxPzAXgkk0lRR/gIzDusw3Cfh1F7qe1AjtUejW/q0MjHDbOHRtVGdCXboW+uF
         HyUOeDgSt378amQQqj4bxQMa8fx+A+ai1q1PlEYg=
Date:   Tue, 14 May 2019 20:04:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.2
Message-ID: <20190514180424.GA11131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.2 kernel.

All users of the 5.1 kernel series must upgrade.  Well, kind of, let me rep=
hrase that...

All users of Intel processors made since 2011 must upgrade.

Note, this release, and the other stable releases that are all being
released right now at the same time, just went out all contain patches
that have only seen the "public eye" for about 5 minutes.  So be
forwarned, they might break things, they might not build, but hopefully
they fix things.  Odds are we will be fixing a number of small things in
this area for the next few weeks as things shake out on real hardware
and workloads.  So don't think you are done updating your kernel, you
never are done with that :)

As for what specifically these changes fix, I'll let the tech news sites
fill you in on the details.  Or go read the excellently written Xen
Security Advisory 297:
	https://xenbits.xen.org/xsa/advisory-297.html
That should give you a good idea of what a number of people have been
dealing with for many many many months now.

Many thanks goes out to Thomas Gleixner for going above and beyond to do
the backports to the 5.1, 5.0, 4.19, and 4.14 kernel trees, and to Ben
Hutchings for doing the 4.9 work.  And of course to all of the
developers who have been working on this in secret and doing reviews of
the many different proposals and versions of the patches.

As I said before just over a year ago, Intel once again owes a bunch of
people a lot of drinks for fixing their hardware bugs, in our
software...

Anyway, as usual, the updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |    4=20
 Documentation/admin-guide/hw-vuln/index.rst        |   13=20
 Documentation/admin-guide/hw-vuln/l1tf.rst         |  615 ++++++++++++++++=
+++++
 Documentation/admin-guide/hw-vuln/mds.rst          |  308 ++++++++++
 Documentation/admin-guide/index.rst                |    6=20
 Documentation/admin-guide/kernel-parameters.txt    |   62 ++
 Documentation/admin-guide/l1tf.rst                 |  614 ----------------=
----
 Documentation/index.rst                            |    1=20
 Documentation/x86/conf.py                          |   10=20
 Documentation/x86/index.rst                        |    8=20
 Documentation/x86/mds.rst                          |  225 +++++++
 Makefile                                           |    2=20
 arch/powerpc/kernel/security.c                     |    6=20
 arch/powerpc/kernel/setup_64.c                     |    2=20
 arch/s390/kernel/nospec-branch.c                   |    3=20
 arch/x86/entry/common.c                            |    3=20
 arch/x86/include/asm/cpufeatures.h                 |    3=20
 arch/x86/include/asm/irqflags.h                    |    4=20
 arch/x86/include/asm/msr-index.h                   |   39 -
 arch/x86/include/asm/mwait.h                       |    7=20
 arch/x86/include/asm/nospec-branch.h               |   50 +
 arch/x86/include/asm/processor.h                   |    6=20
 arch/x86/kernel/cpu/bugs.c                         |  146 ++++
 arch/x86/kernel/cpu/common.c                       |  121 ++--
 arch/x86/kernel/nmi.c                              |    4=20
 arch/x86/kernel/traps.c                            |    8=20
 arch/x86/kvm/cpuid.c                               |    3=20
 arch/x86/kvm/vmx/vmx.c                             |    7=20
 arch/x86/mm/pti.c                                  |    4=20
 drivers/base/cpu.c                                 |    8=20
 include/linux/cpu.h                                |   26=20
 kernel/cpu.c                                       |   15=20
 tools/power/x86/turbostat/Makefile                 |    2=20
 tools/power/x86/x86_energy_perf_policy/Makefile    |    2=20
 34 files changed, 1632 insertions(+), 705 deletions(-)

Andi Kleen (2):
      x86/speculation/mds: Add basic bug infrastructure for MDS
      x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests

Boris Ostrovsky (1):
      x86/speculation/mds: Fix comment

Greg Kroah-Hartman (1):
      Linux 5.1.2

Josh Poimboeuf (9):
      x86/speculation/mds: Add mds=3Dfull,nosmt cmdline option
      x86/speculation: Move arch_smt_update() call to after mitigation deci=
sions
      x86/speculation/mds: Add SMT warning message
      cpu/speculation: Add 'mitigations=3D' cmdline option
      x86/speculation: Support 'mitigations=3D' cmdline option
      powerpc/speculation: Support 'mitigations=3D' cmdline option
      s390/speculation: Support 'mitigations=3D' cmdline option
      x86/speculation/mds: Add 'mitigations=3D' support for MDS
      x86/speculation/mds: Fix documentation typo

Konrad Rzeszutek Wilk (1):
      x86/speculation/mds: Print SMT vulnerable on MSBDS with mitigations o=
ff

Thomas Gleixner (12):
      x86/msr-index: Cleanup bit defines
      x86/speculation: Consolidate CPU whitelists
      x86/speculation/mds: Add BUG_MSBDS_ONLY
      x86/speculation/mds: Add mds_clear_cpu_buffers()
      x86/speculation/mds: Clear CPU buffers on exit to user
      x86/kvm/vmx: Add MDS protection when L1D Flush is not active
      x86/speculation/mds: Conditionally clear CPU buffers on idle entry
      x86/speculation/mds: Add mitigation control for MDS
      x86/speculation/mds: Add sysfs reporting for MDS
      x86/speculation/mds: Add mitigation mode VMWERV
      Documentation: Move L1TF to separate directory
      Documentation: Add MDS vulnerability documentation

Tyler Hicks (1):
      Documentation: Correct the possible MDS sysfs values

speck for Pawan Gupta (1):
      x86/mds: Add MDSUM variant to the MDS documentation


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzbAyUACgkQONu9yGCS
aT5Q6RAAskoO7Bxj/EY+uVB2nFhNZ9i93zwDOxoNtw+L1lPnod73BVEHFHmprrys
wN4S+yHkn8SENDCMc79H2X5Xe7EqgENEtWoJqfCSC0foKiW3aNSas5Co4d+rEWyh
kU/Fyi65a6WzKKNuIcX80fk9q/iHwxMi6nrfRGVzXsfFjsAYVD4I9VfOtkiKubL4
TNwIF94EcaJXh8ADi1XJSWhh20xQ1OhcLDyL6Rc945i0oNBFS4faKIBGCzyKAjmY
RzVUyaa+d7HVx0lzpmCpl/qDoNmE90nI9TyK909ba8f4gC75I7a/S8NsjkxK91rn
NHOWOh+dxBD54fkxEKN3pG8pG+OypkjO1Rz0EbGCw/pEIir0oBvrVQfX/pV5aDoe
9+POwhlTOIMem6yCd2ZTpyVfwboTM2YmiUlcarQAOMxM4tO7qfNis/2bgGnZZmYD
gfYQLKOr4HGzGktV34TC3rowindDtm4L85N24rLVjnlEpRhvqs12OlHeWhMEjRrt
B+b8O7CBjVK85xc5BMKAVYI+9/XoijVYRM49CS30IBwUIXd90HDYvos3scbq8opU
OcM1HkxJjCBanas80QO9Ke7pqoL22HyH8ve6+50PybXqgyDGjYkhCWqnSwAdrdmG
eRdKKelRjqB3hsmf1LyPgjrwTVZ4S7xHrsdl1CeeMuOi6Z1S6ws=
=hOy1
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
