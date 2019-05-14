Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA51CE7C
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfENSFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 14:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfENSFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 14:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF642084F;
        Tue, 14 May 2019 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557857100;
        bh=C/7GuWRLVwvhinFn/YTjd2e8x6SMfDBo1hjamCVEWK8=;
        h=Date:From:To:Cc:Subject:From;
        b=XlfHBXTgDrTtVMnK8w88OG7Q1dFFCGZjZ9AT64u9WSxKIItNPZM/MRSsebV+5j2pD
         OPiisIF2OFBLV2rXnEhpOcoqJcDNpW738nYtoZNv5t9ilTKsX8JTxUBfHEXBOKI0Pq
         qXOtXFRuzFgSdYebKDrGgGjCh5fwlV0+vNCbgiNs=
Date:   Tue, 14 May 2019 20:04:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.16
Message-ID: <20190514180457.GA13092@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.16 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
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
      Linux 5.0.16

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


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzbA0kACgkQONu9yGCS
aT6L7RAAjH4GyoZEY017Ur4kzU7pOhqRwBAWh0VQF/xR1o86LhsAeHE1K9IrleSY
hRQCbpUJ5B7IAcQ1CL6eTdNfirl2ve+vNgxjo46oxNxwSB87hE/xSYvZLUWboZgY
SusrIuvV6nngqYGLnRkgG1qZDRyAyQuglMsuV1lvaTeC9FVYraer1AuftEem5y5v
To1uEBoTcRagqPAiEUk4566T0fMy+RgWyCUEc2BrzRDAoRsZmCsC/RhqpmkjAo4v
nxCZRw2T4xZJDfCKnlpz49SaL+OJNuz+dfqdyfXO958zE+Ab9Az27LpNmlAkSshT
VCA81nGfH266U/1ahKWBrX0t8YOsepL282xNomcWKIk2xZ79qodJ6yy7HUGFzY5p
K5q1Yey2MSPKAljpI1bwIBATFaqe3JWxGEdUYty/b5XzdzByRlwiPB8aZKScs2I0
WiVv+hYMUcSptBI6l5wq3O1vbqdnEcDieXeKewy7AwDX3mHQKseH/P0TNoWjO4bG
6xJathItgtqgm6YJlzbtzGYwbknIrcREYglAI36kQiW7Hhat0ZPUb1FOxQgXuk/V
2xKNZKGOp0XTQARP6rwidlAasso8rZcWl22WVSUXm5t6Dg6A8TF6WuIRKJ29utIk
znvo3qoexyPGXqECsc8iO+3V1ysHBDONm4gO6QmlFLx8BUHiG7I=
=Ki73
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
